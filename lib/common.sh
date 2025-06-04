#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Load platform-specific utilities (Linux/macOS)
source "$SCRIPT_DIR/lib/system_utils.sh"
source "$SCRIPT_DIR/lib/workflow_definitions.sh"




# Usage message
function usage() {
    echo ""
    echo "Usage: metagear <command> [options]"
    echo "Commands:"
    for cmd in "${!workflow_definitions[@]}"; do
        desc="${workflow_definitions[$cmd]}"
        desc="${desc%%|*}"
        printf "  %-20s %s\n" "$cmd" "$desc."
    done
    echo ""
    exit 1
}


function check_command {
    # Check if the command exists in the workflow_definitions array
    if ! [[ -v workflow_definitions[$1] ]]; then
        echo "Error: Command '$1' not found."
        usage
        exit 1
    fi
}


check_requirements() {
    # Array to store error messages.
    local errors=()

    # Check Bash version 4+.
    if [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
        errors+=("Bash version 4 or higher is required (found version ${BASH_VERSINFO[0]}).")
    fi

    # Check for nextflow.
    if ! command -v nextflow >/dev/null 2>&1; then
        errors+=("Nextflow is not installed.")
    fi

    # Check for a container engine: either singularity or docker.
    if ! command -v singularity >/dev/null 2>&1 && ! command -v docker >/dev/null 2>&1; then
        errors+=("Neither Singularity nor Docker is installed (one is required).")
    fi

    # If there are missing requirements, report them and exit.
    if [ ${#errors[@]} -gt 0 ]; then
        echo "---------------------------------------" >&2
        echo "The following requirements are missing:" >&2
        echo "---------------------------------------" >&2
        for error in "${errors[@]}"; do
            echo "   - $error" >&2
        done
        echo "---------------------------------------" >&2
        echo "Please install the missing requirements and try again." >&2
    fi

}


function check_metagear_home() {

    user_config_file=$HOME/.metagear/metagear.config
    user_env_file=$HOME/.metagear/metagear.env

    if [ ! -f $user_config_file ]; then

        echo "-----------------"
        echo "System resources:"
        echo "-----------------"

        total_cpu_count=$(get_cpu_count)
        echo "CPU Count: ${total_cpu_count}"

        total_memory_gb=$(get_total_memory_gb)
        echo "Installed RAM: ${total_memory_gb} GB"

        if (( total_cpu_count < 48 )) && (( $(printf '%.0f' "$total_memory_gb") < 80 )); then
            default_cpu_count=$(( total_cpu_count * 80 / 100 ))
            if (( default_cpu_count < 1 )); then
                default_cpu_count=1
            fi
            default_memory_gb=$(awk -v mem="$total_memory_gb" 'BEGIN{printf "%.0f", mem*0.8}')
        else
            default_cpu_count=48
            default_memory_gb=80
        fi

        cp $HOME/.metagear/utilities/templates/metagear.config $user_config_file

        # detect macOS vs Linux so we can pass the right -i flag
        if [[ "$(uname)" == "Darwin" ]]; then
        # macOS sed: -i requires a backup‐suffix, so we give it an empty one
        SED_INPLACE=(-i '')
        else
        # GNU sed: -i works with no suffix
        SED_INPLACE=(-i)
        fi

        # now the three edits, using a more precise regex for CPUs and escaping properly:

        # 1) Update max_memory
        sed "${SED_INPLACE[@]}" \
            "s/^max_memory = '[0-9]\+\(\.[0-9]\+\)\?GB'/max_memory = '${default_memory_gb}GB'/" \
            "$user_config_file"

        # 2) Update max_cpus
        sed "${SED_INPLACE[@]}" \
            "s/^max_cpus = [0-9]\+/max_cpus = ${default_cpu_count}/" \
            "$user_config_file"

        # 3) Update databases_root (using | as delimiter so we don’t have to escape /)
        sed "${SED_INPLACE[@]}" \
            "s|^databases_root = \".*\"|databases_root = \"${HOME}/.metagear/databases\"|" \
            "$user_config_file"

        cp $HOME/.metagear/utilities/templates/metagear.env $user_env_file

        GREEN=$(tput setaf 2)
        YELLOW=$(tput setaf 3)
        BOLD=$(tput bold)
        RESET=$(tput sgr0)

        echo ""
        echo "${GREEN}It seems this is the first time MetaGEAR runs in this system...${RESET}"
        echo ""
        check_requirements
        echo ""
        echo "   - User configuration was created in ~/.metagear/metagear.config"
        echo "   - Environment file was created in ~/.metagear/metagear.env"
        echo ""
        echo "${BOLD}${YELLOW}IMPORTANT: Review these files before re-launching the MetaGEAR pipeline.${RESET}"
        echo ""

        exit 0

    fi

}


detect_container_tool() {
    # Check for singularity first and return it if found.
    if command -v singularity >/dev/null 2>&1; then
        echo "singularity"
    # Else check for docker and return it if found.
    elif command -v docker >/dev/null 2>&1; then
        echo "docker"
    # Return "none" if neither is available.
    else
        echo "Error: MetaGEAR requires Singularity (recommended) or Docker. Please install one of those in your system." >&2
        echo "  Singularity: https://docs.sylabs.io/guides/3.0/user-guide/installation.html" >&2
        echo "  Docker: https://docs.docker.com/engine/install/" >&2
        exit 1
    fi
}
