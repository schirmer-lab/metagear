#!/usr/bin/env bash
set -euo pipefail


# 1) Config
INSTALL_DIR="${HOME}/.metagear"
ORGANIZATION="gariem"
REPO_NAME="test_tag"
SCRIPT="command.sh"
VERSION=0.0.2
# REPO_NAME="schirmer-lab/metagear-pipeline"
# VERSION=1.0
SCRIPT="install.sh"

ZIP_URL="https://github.com/${ORGANIZATION}/${REPO_NAME}/archive/refs/tags/${VERSION}.zip"
TMP_ZIP="${INSTALL_DIR}/downloads/metagear-${VERSION}.zip"

EXTRACTED_DIR="${INSTALL_DIR}/downloads/v${VERSION}"
PIPELINE_DIR="${INSTALL_DIR}/v${VERSION}"

WRAPPER_NAME="metagear"
WRAPPER_PATH="${PWD}/${WRAPPER_NAME}"


# 2) Prepare install directory
mkdir -p "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"/downloads


# 3) Download the tagged release
echo "→ Downloading MetaGEAR v${VERSION} from GitHub"
wget -qO "${TMP_ZIP}" "${ZIP_URL}"

# 5) Clean up any old unpacked folder
if [ -d "${PIPELINE_DIR}" ]; then
  echo "→ Removing old pipeline directory"
  rm -rf "${PIPELINE_DIR}"
fi

# 4) Unzip into place
echo "→ Extracting to ${EXTRACTED_DIR}"
unzip -qo "${TMP_ZIP}" -d "${EXTRACTED_DIR}"
mv ${EXTRACTED_DIR}/${REPO_NAME}-${VERSION} ${PIPELINE_DIR}
ln -s ${PIPELINE_DIR} ${INSTALL_DIR}/latest


# 7) Create the relocatable wrapper
cat > "${WRAPPER_PATH}" << 'EOF'
#!/usr/bin/env bash
exec "${HOME}/.metagear/latest/.metagear.sh" "$@"
EOF
chmod +x "${WRAPPER_PATH}"


# 8) Done
echo
echo "✔ Installed metagear v${VERSION}"
echo "  • Pipeline directory: ${PIPELINE_DIR}"
echo "  • Wrapper script:     ${WRAPPER_PATH}"
echo
echo "You can now move '${WRAPPER_PATH}' into your PATH (e.g. /usr/local/bin) and run 'metagear'."