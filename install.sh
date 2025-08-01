#!/usr/bin/env bash
set -euo pipefail


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
echo "→ Setting Up MetaGEAR utilities"

# echo "→ Cleaning old Utilities directory"
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
  echo "→ Extracting to ${UTILS_EXTRACTED_DIR}"
  unzip -qo "${UTILS_TMP_ZIP}" -d "${UTILS_EXTRACTED_DIR}"

  mv ${UTILS_EXTRACTED_DIR}/metagear-main ${INSTALL_DIR}/utilities
fi


# 4) Install the Pipeline
echo ""
echo "→ Installing MetaGEAR"

rm -rf "${INSTALL_DIR}/latest"

if [[ -n "${CUSTOM_PIPELINE_PATH}" ]]; then # If pipeline path is provided, we use it directly
  echo "  Using custom pipeline directory: ${CUSTOM_PIPELINE_PATH}"
  ln -s "${CUSTOM_PIPELINE_PATH}" "${INSTALL_DIR}/latest"
  
else # Otherwise, download the default pipeline
  echo "→ Installing v${PIPELINE_VERSION} from GitHub"

  EXTRACTED_DIR="${INSTALL_DIR}/downloads/v${PIPELINE_VERSION}"
  PIPELINE_DIR="${INSTALL_DIR}/v${PIPELINE_VERSION}"

  ZIP_URL="https://github.com/${ORGANIZATION}/${PIPELINE_REPOSITORY}/archive/refs/tags/${PIPELINE_VERSION}.zip"
  TMP_ZIP="${INSTALL_DIR}/downloads/metagear-${PIPELINE_VERSION}.zip"

  rm -rf "${PIPELINE_DIR}"

  wget -qO "${TMP_ZIP}" "${ZIP_URL}"

  echo "→ Extracting to ${EXTRACTED_DIR}"
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

# 6) Remove temporary files
echo ""
echo "→ Cleaning up"
rm -rf "${INSTALL_DIR}/downloads"


# 7) Done
echo
echo "✔ Installed MetaGEAR Pipeline"
echo "  • Installation directory: ${INSTALL_DIR}"
echo "    - Pipeline"
echo "    - Utilities"
echo ""
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)
echo "${YELLOW}Next steps:${RESET}"
echo "  • Move '${WRAPPER_PATH}' into a directory in your PATH (e.g. /usr/local/bin)"
echo "  • Run './${WRAPPER_NAME}' once to create default configuration files"
echo "  • Review ${INSTALL_DIR}/metagear.config before running pipelines"
