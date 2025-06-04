#!/usr/bin/env bash

# Check Bash version 4+.
if [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
    echo "Bash version 4 or higher is required (found version ${BASH_VERSINFO[0]})."
    exit 1
fi


# Resolve script directory and source common functions
UTILITIES_DIR="$(dirname "$(realpath "$0")")"
PIPELINE_DIR="$HOME/.metagear/latest"
LAUNCH_DIR="$PWD"

source "${UTILITIES_DIR}/lib/common.sh"
source "${UTILITIES_DIR}/lib/workflows.sh"

check_metagear_home

# Ensure a command is provided
if [ $# -eq 0 ]; then
    usage
fi

COMMAND="$1"
shift

check_command "$COMMAND"

# Detect preview mode and filter it from the arguments
PREVIEW=false
REMAINING_ARGS=()
while (( $# > 0 )); do
    case "$1" in
        -preview|--preview)
            PREVIEW=true
            ;;
        *)
            REMAINING_ARGS+=("$1")
            ;;
    esac
    shift
done

mkdir -p $LAUNCH_DIR/.metagear

custom_config_files=( $PIPELINE_DIR/conf/metagear/$COMMAND.config $HOME/.metagear/metagear.config )
metagear_config_files=( $PIPELINE_DIR/conf/metagear/*.config )
all_config_files=( "${metagear_config_files[@]}" "${custom_config_files[@]}" )

$UTILITIES_DIR/lib/merge_configuration.sh ${all_config_files[@]} > $LAUNCH_DIR/$COMMAND.config

nf_cmd_workflow_part=$(run_workflows $COMMAND "${REMAINING_ARGS[@]}")

cat $HOME/.metagear/metagear.env > $LAUNCH_DIR/metagear_$COMMAND.sh

echo "" >> $LAUNCH_DIR/metagear_$COMMAND.sh
echo "nextflow run $PIPELINE_DIR/main.nf \\
        $nf_cmd_workflow_part \\
        -c $LAUNCH_DIR/$COMMAND.config \\
        \$RUN_PROFILES -w \\
        \$NF_WORK -resume" >> $LAUNCH_DIR/metagear_$COMMAND.sh
echo "" >> $LAUNCH_DIR/metagear_$COMMAND.sh

chmod +x $LAUNCH_DIR/metagear_$COMMAND.sh

if [ "$PREVIEW" = true ]; then
    echo "------ Preview mode ------"
    cat "$LAUNCH_DIR/metagear_$COMMAND.sh"
    echo "--------------------------"
    echo "The script above was generated at $LAUNCH_DIR/metagear_$COMMAND.sh"
    echo "Run it directly or re-run this command without the preview flag to execute."
else
    $LAUNCH_DIR/metagear_$COMMAND.sh
fi
