#!/usr/bin/env bash
set -euo pipefail

# Color codes for terminal output
YELLOW=$(tput setaf 3)
GREEN=$(tput setaf 2)
RESET=$(tput sgr0)

# 1) Config
INSTALL_DIR="${HOME}/.metagear"
ORGANIZATION="schirmer-lab"
PIPELINE_REPOSITORY="metagear-pipeline"
PIPELINE_VERSION=0.1.1
UTILS_REPOSITORY="metagear"
SCRIPT="main.sh"

WRAPPER_NAME="metagear"
WRAPPER_PATH="${PWD}/${WRAPPER_NAME}"

# Optional development pipeline path
CUSTOM_PIPELINE_PATH=""

# Optional custom utilities repository
CUSTOM_UTILS_PATH=""

# Parse optional arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --install-dir)
      shift
      if [[ $# -eq 0 ]]; then
        echo "Error: --install-dir requires a path argument" >&2
        exit 1
      fi
      INSTALL_DIR="$(realpath "$1")"
      shift
      ;;
    --pipeline)
      shift
      if [[ $# -eq 0 ]]; then
        echo "Error: --pipeline requires a path argument" >&2
        exit 1
      fi
      CUSTOM_PIPELINE_PATH="$(realpath "$1")"
      shift
      ;;
    --utilities)
      shift
      if [[ $# -eq 0 ]]; then
        echo "Error: --utilities requires a repository argument" >&2
        exit 1
      fi
      CUSTOM_UTILS_PATH="$1"
      shift
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done


# 2) Prepare install directory
mkdir -p "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"/downloads

# Welcome message
echo "Welcome to the MetaGEAR installation script!"
echo "This script will install MetaGEAR v${PIPELINE_VERSION} and its utilities."
echo ""

# 3) Install utilities
echo "${GREEN}→ Setting Up MetaGEAR utilities${RESET}"

rm -rf "${INSTALL_DIR}/utilities"

if [[ -n "${CUSTOM_UTILS_PATH}" ]]; then # If utilities path is provided, we use it directly
  echo "  Using custom utilities directoy: ${CUSTOM_UTILS_PATH}"
  ln -s "${CUSTOM_UTILS_PATH}" "${INSTALL_DIR}/utilities"
  
else # Otherwise, download the default utilities
  echo "  Downloading MetaGEAR utilities from default repository..."
  UTILS_ZIP_URL="https://github.com/${ORGANIZATION}/${UTILS_REPOSITORY}/archive/refs/heads/main.zip"
  UTILS_TMP_ZIP="${INSTALL_DIR}/downloads/utilities.zip"
  UTILS_EXTRACTED_DIR="${INSTALL_DIR}/downloads/utilities"

  wget -qO "${UTILS_TMP_ZIP}" "${UTILS_ZIP_URL}"
  echo "  Extracting to ${UTILS_EXTRACTED_DIR}"
  unzip -qo "${UTILS_TMP_ZIP}" -d "${UTILS_EXTRACTED_DIR}"

  mv ${UTILS_EXTRACTED_DIR}/metagear-main ${INSTALL_DIR}/utilities
fi


# 4) Install the Pipeline
echo ""
echo "${GREEN}→ Installing MetaGEAR${RESET}"

rm -rf "${INSTALL_DIR}/latest"

if [[ -n "${CUSTOM_PIPELINE_PATH}" ]]; then # If pipeline path is provided, we use it directly
  echo "  Using custom pipeline directory: ${CUSTOM_PIPELINE_PATH}"
  ln -s "${CUSTOM_PIPELINE_PATH}" "${INSTALL_DIR}/latest"
  
else # Otherwise, download the default pipeline
  echo "  Installing v${PIPELINE_VERSION} from GitHub"

  EXTRACTED_DIR="${INSTALL_DIR}/downloads/v${PIPELINE_VERSION}"
  PIPELINE_DIR="${INSTALL_DIR}/v${PIPELINE_VERSION}"

  ZIP_URL="https://github.com/${ORGANIZATION}/${PIPELINE_REPOSITORY}/archive/refs/tags/${PIPELINE_VERSION}.zip"
  TMP_ZIP="${INSTALL_DIR}/downloads/metagear-${PIPELINE_VERSION}.zip"

  rm -rf "${PIPELINE_DIR}"

  wget -qO "${TMP_ZIP}" "${ZIP_URL}"

  echo "  Extracting to ${EXTRACTED_DIR}"
  unzip -qo "${TMP_ZIP}" -d "${EXTRACTED_DIR}"
  mv ${EXTRACTED_DIR}/${PIPELINE_REPOSITORY}-${PIPELINE_VERSION} ${PIPELINE_DIR}

  ln -s "${PIPELINE_DIR}" "${INSTALL_DIR}/latest"

fi


# 5) Create the relocatable wrapper
cat > "${WRAPPER_PATH}" << EOF
#!/usr/bin/env bash
export INSTALL_DIR="${INSTALL_DIR}"
exec "\${INSTALL_DIR}/utilities/${SCRIPT}" "\$@"
EOF
chmod +x "${WRAPPER_PATH}"

# 6) Create configuration files
echo ""
echo "${GREEN}→ Creating configuration files${RESET}"

# Load system utilities to get system information
source "${INSTALL_DIR}/utilities/lib/system_utils.sh"

user_config_file="${INSTALL_DIR}/metagear.config"
user_env_file="${INSTALL_DIR}/metagear.env"

total_cpu_count=$(get_cpu_count)
total_memory_gb=$(get_total_memory_gb)

echo "  - Found ${total_cpu_count} CPUs and ${total_memory_gb} GB of Memory in the system."

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

echo "  - MetaGEAR will use ${default_cpu_count} CPUs and ${default_memory_gb} GB of Memory."

# Export variables for envsubst
export INSTALL_DIR="${INSTALL_DIR}"
export MAX_CPUS="${default_cpu_count}"
export MAX_MEMORY="${default_memory_gb}"

# Create configuration file with environment variable substitution
envsubst < "${INSTALL_DIR}/utilities/templates/metagear.config" > "$user_config_file"

# Create environment file with INSTALL_DIR substitution
envsubst < "${INSTALL_DIR}/utilities/templates/metagear.env" > "$user_env_file"

echo "  - User configuration created: ${INSTALL_DIR}/metagear.config"
echo "  - Environment file created: ${INSTALL_DIR}/metagear.env"

# Check dependencies and provide informational warnings
echo ""
echo "${GREEN}→ Checking runtime dependencies${RESET}"

dep_missing=false

# Check Bash version 4+
if [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
    echo "  ⚠ WARNING: Bash version 4 or higher is required (found version ${BASH_VERSINFO[0]})" >&2
    dep_missing=true
fi

# Check for nextflow
if ! command -v nextflow >/dev/null 2>&1; then
    echo "  ⚠ WARNING: Nextflow is not installed"
    dep_missing=true
fi

# Check for container engines
if ! command -v singularity >/dev/null 2>&1 && ! command -v docker >/dev/null 2>&1; then
    echo "  ⚠ WARNING: Neither Singularity nor Docker is installed (one is required)"
    dep_missing=true
fi

if [ "$dep_missing" = false ]; then
    echo "  ✓ All runtime dependencies are available"
fi

# 7) Remove temporary files
rm -rf "${INSTALL_DIR}/downloads"


# 8) Done
echo
echo "${GREEN}✔ Installed MetaGEAR Pipeline${RESET}"
echo "  • Installation directory: ${INSTALL_DIR}"
echo "    - Pipeline"
echo "    - Utilities"
echo "    - Configuration files"
echo ""
echo "${YELLOW}Next steps:${RESET}"
echo "  • Add '${WRAPPER_PATH}' to your \$PATH (e.g. copy/move to /usr/local/bin)"
echo "  • Review ${INSTALL_DIR}/metagear.config and adjust as needed"
echo "  • Run './${WRAPPER_NAME}' (or just 'metagear' when it's already in your \$PATH) to start using MetaGEAR"
