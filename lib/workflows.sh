#!/usr/bin/env bash
# lib/common.sh

LAUNCH_DIR="$PWD"

declare -A require_input=(
    [download_databases]="false"
    [qc_dna]="true"
    [qc_rna]="true"
    [microbial_profiles]="true"
    [gene_call]="true"
)


function run_workflows() {
    workflow="$1"
    shift

    local default_input_file="$LAUNCH_DIR/input_${workflow}.csv"
    local default_outdir="$LAUNCH_DIR/results"

    while (( $# > 0 )); do
        case "$1" in
            --input)
                shift
                input_file="$1"
                ;;
            --outdir)
                shift
                outdir="$1"
                ;;
            *)
                echo "Invalid option: $1"
                usage
                ;;
        esac
        shift
    done

    # echo "require_input[$workflow] = ${require_input[$workflow]}"

    # Require an input file for workflows that need one
    if [[ "${require_input[$workflow]}" == "true" ]]; then
        if [ -z "${input_file:-}" ]; then
            echo "Error: --input is required for $workflow workflow." >&2
            exit 1
        fi
        cp "$input_file" "$default_input_file"
    fi

    if [ -z "${outdir:-}" ]; then
        outdir="$default_outdir"
    fi


    mkdir -p "$outdir"

    cmd="--workflow $workflow"
    if [[ "${require_input[$workflow]}" == "true" ]]; then
        cmd+=" --input $input_file"
    fi
    cmd+=" --outdir $outdir"

    echo "$cmd"
}

