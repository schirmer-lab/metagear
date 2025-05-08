#!/usr/bin/env bash
set -euo pipefail


# 1) Config
INSTALL_DIR="${HOME}/.metagear"
ORGANIZATION="schirmer-lab"
PIPLINE_REPOSITORY="metagear-pipeline"
PIPELINE_VERSION=0.1.0
UTILS_REPOSITORY="metagear-utilities"
SCRIPT="main.sh"


ZIP_URL="https://github.com/${ORGANIZATION}/${PIPLINE_REPOSITORY}/archive/refs/tags/${PIPELINE_VERSION}.zip"
TMP_ZIP="${INSTALL_DIR}/downloads/metagear-${PIPELINE_VERSION}.zip"

EXTRACTED_DIR="${INSTALL_DIR}/downloads/v${PIPELINE_VERSION}"
PIPELINE_DIR="${INSTALL_DIR}/v${PIPELINE_VERSION}"

WRAPPER_NAME="metagear"
WRAPPER_PATH="${PWD}/${WRAPPER_NAME}"


# 2) Prepare install directory
mkdir -p "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"/downloads

# 3) Install utilities
echo "→ Installing MetaGEAR utilities..."
UTILS_ZIP_URL="https://github.com/${ORGANIZATION}/${UTILS_REPOSITORY}/archive/refs/heads/main.zip"
UTILS_TMP_ZIP="${INSTALL_DIR}/downloads/utilities.zip"
EXTRACTED_DIR="${INSTALL_DIR}/downloads/utilities"

wget -qO "${UTILS_TMP_ZIP}" "${UTILS_ZIP_URL}"
unzip -qo "${UTILS_TMP_ZIP}" -d "${EXTRACTED_DIR}"

if [ -d "${INSTALL_DIR}/utilities" ]; then
  echo "→ Removing old Utilities directory"
  rm -rf "${INSTALL_DIR}/utilities"
fi

mv ${EXTRACTED_DIR}/metagear-utilities-main ${INSTALL_DIR}/utilities

# 3) Download the tagged release
echo "→ Downloading MetaGEAR v${PIPELINE_VERSION} from GitHub"
wget -qO "${TMP_ZIP}" "${ZIP_URL}"

# 4) Clean up any old unpacked folder
if [ -d "${PIPELINE_DIR}" ]; then
  echo "→ Removing old pipeline directory"
  rm -rf "${PIPELINE_DIR}"
fi

# 5) Unzip into place
echo "→ Extracting to ${EXTRACTED_DIR}"
unzip -qo "${TMP_ZIP}" -d "${EXTRACTED_DIR}"
mv ${EXTRACTED_DIR}/${PIPLINE_REPOSITORY}-${PIPELINE_VERSION} ${PIPELINE_DIR}

ln -s ${PIPELINE_DIR} ${INSTALL_DIR}/latest


# 6) Create the relocatable wrapper
cat > "${WRAPPER_PATH}" << EOF
#!/usr/bin/env bash
exec "${INSTALL_DIR}/utilities/${SCRIPT}" "\$@"
EOF
chmod +x "${WRAPPER_PATH}"

#7) Remove temporary files
echo "→ Cleaning up"
rm -rf "${INSTALL_DIR}/downloads"


# 8) Done
echo
echo "✔ Installed metagear v${PIPELINE_VERSION}"
echo "  • Pipeline directory: ${PIPELINE_DIR}"
echo ""
echo "You can now move '${WRAPPER_PATH}' into your PATH (e.g. /usr/local/bin) and run 'metagear'."