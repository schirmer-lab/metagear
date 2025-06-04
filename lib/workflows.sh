#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
# Share parameter configuration with other scripts
source "$SCRIPT_DIR/workflow_definitions.sh"

LAUNCH_DIR="$PWD"



function run_workflows() {
    workflow="$1"
    shift

    local default_input_file="$LAUNCH_DIR/input_${workflow}.csv"

    # Parse the parameter specification for this workflow
    def="${workflow_definitions[$workflow]}"
    params="${def#*|}"
    params="${params## }"
    read -ra tokens <<< "$params"
    local allowed=()
    local required=()
    declare -A defaults=()
    for t in "${tokens[@]}"; do
        local param="$t"
        local is_required=false
        if [[ $param == *\* ]]; then
            param="${param%\*}"  # remove trailing '*'
            is_required=true
        fi
        local regex='^([A-Za-z_]+)\(([^)]+)\)$'
        if [[ $param =~ $regex ]]; then
            param="${BASH_REMATCH[1]}"
            defaults[$param]="${BASH_REMATCH[2]}"
        fi
        allowed+=("$param")
        $is_required && required+=("$param")
    done

    declare -A values=()

    while (( $# > 0 )); do
        case "$1" in
            --*)
                param="${1#--}"
                shift
                value="$1"
                if [[ ! " ${allowed[@]} " =~ " ${param} " ]]; then
                    echo "Invalid option: --$param for $workflow workflow." >&2
                    usage
                fi
                values[$param]="$value"
                ;;
            *)
                echo "Invalid option: $1" >&2
                usage
                ;;
        esac
        shift
    done

    for req in "${required[@]}"; do
        if [ -z "${values[$req]:-}" ]; then
            echo "Error: --$req is required for $workflow workflow." >&2
            exit 1
        fi
    done

    for param in "${allowed[@]}"; do
        if [ -z "${values[$param]:-}" ] && [ -n "${defaults[$param]:-}" ]; then
            values[$param]="${defaults[$param]}"
        fi
    done

    local outdir="${values[outdir]:-${defaults[outdir]}}"

    if [[ " ${allowed[@]} " =~ " input " ]] && [ -n "${values[input]:-}" ]; then
        cp "${values[input]}" "$default_input_file"
    fi

    mkdir -p "$outdir"

    cmd="--workflow $workflow"
    for param in "${allowed[@]}"; do
        [[ "$param" == "outdir" ]] && continue
        if [ -n "${values[$param]:-}" ]; then
            cmd+=" --$param ${values[$param]}"
        fi
    done
    cmd+=" --outdir $outdir"

    echo "$cmd"
}

