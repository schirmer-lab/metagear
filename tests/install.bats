#!/usr/bin/env bats

# Test Cases:
# 1. install.sh creates wrapper and installation files
# 2. install.sh skips existing config files
# 3. install.sh creates config files when they don't exist
# 4. install.sh handles partial existing files correctly

@test "install.sh creates wrapper and installation files" {
    # 0) Create and change to temporary working directory
    temp_work_dir=$(mktemp -d)
    original_dir="$PWD"
    cd "$temp_work_dir"

    # 1) Create temporary directory
    temp_dir=$(mktemp -d)/metagear
    mkdir -p "$temp_dir"

    # 2) Call install.sh with --install-dir
    install_script="$BATS_TEST_DIRNAME/../install.sh"
    run bash "$install_script" --install-dir "$temp_dir"

    # 3) Check that installation completed successfully
    [ "$status" -eq 0 ]

    # 4) Check that metagear wrapper is created in current directory
    [ -f metagear ]

    # 5) Check that metagear.config, and metagear.env exists in the installation directory
    [ -f "$temp_dir/metagear.config" ]
    [ -f "$temp_dir/metagear.env" ]

    # Clean up
    cd "$original_dir"
    rm -rf "$temp_dir"
    rm -rf "$temp_work_dir"
}

@test "install.sh skips existing config files" {
    # 0) Create and change to temporary working directory
    temp_work_dir=$(mktemp -d)
    original_dir="$PWD"
    cd "$temp_work_dir"

    # 1) Create temporary directory
    temp_dir=$(mktemp -d)/metagear
    mkdir -p "$temp_dir"

    # 2) Create existing config files with original content
    echo "# Original config content" > "$temp_dir/metagear.config"
    echo "# Original env content" > "$temp_dir/metagear.env"

    # 3) Call install.sh with --install-dir
    install_script="$BATS_TEST_DIRNAME/../install.sh"
    run bash "$install_script" --install-dir "$temp_dir"

    # 4) Check that installation completed successfully
    [ "$status" -eq 0 ]

    # 5) Check that original files are preserved and unchanged
    [ -f "$temp_dir/metagear.config" ]
    [ -f "$temp_dir/metagear.env" ]
    grep "Original config content" "$temp_dir/metagear.config"
    grep "Original env content" "$temp_dir/metagear.env"

    # 6) Check that no .new files are created
    [ ! -f "$temp_dir/metagear.config.new" ]
    [ ! -f "$temp_dir/metagear.env.new" ]

    # 7) Check that output mentions skipping
    [[ "$output" =~ "Configuration file already exists, skipping" ]]
    [[ "$output" =~ "Environment file already exists, skipping" ]]

    # Clean up
    cd "$original_dir"
    rm -rf "$temp_dir"
    rm -rf "$temp_work_dir"
}

@test "install.sh creates config files when they don't exist" {
    # 0) Create and change to temporary working directory
    temp_work_dir=$(mktemp -d)
    original_dir="$PWD"
    cd "$temp_work_dir"

    # 1) Create a truly clean temporary directory for installation
    temp_dir=$(mktemp -d)

    # Ensure directory is completely clean
    rm -rf "$temp_dir"/*
    rm -rf "$temp_dir"/.* 2>/dev/null || true

    # 2) Call install.sh with --install-dir (no existing config files)
    install_script="$BATS_TEST_DIRNAME/../install.sh"
    run bash "$install_script" --install-dir "$temp_dir"

    # 3) Check that installation completed successfully
    [ "$status" -eq 0 ]

    # 4) Check that config files are created
    [ -f "$temp_dir/metagear.config" ]
    [ -f "$temp_dir/metagear.env" ]

    # 5) Verify config files contain expected template content
    grep "max_cpus" "$temp_dir/metagear.config"
    grep "NXF_SINGULARITY_CACHEDIR" "$temp_dir/metagear.env"

    # 6) Check that output mentions creation
    [[ "$output" =~ "User configuration created:" ]]
    [[ "$output" =~ "metagear.config" ]]
    [[ "$output" =~ "Environment file created:" ]]
    [[ "$output" =~ "metagear.env" ]]

    # Clean up
    cd "$original_dir"
    rm -rf "$temp_dir"
    rm -rf "$temp_work_dir"
}

@test "install.sh handles partial existing files correctly" {
    # 0) Create and change to temporary working directory
    temp_work_dir=$(mktemp -d)
    original_dir="$PWD"
    cd "$temp_work_dir"

    # 1) Create temporary directory
    temp_dir=$(mktemp -d)/metagear
    mkdir -p "$temp_dir"

    # 2) Create only one existing config file
    echo "# Original config content" > "$temp_dir/metagear.config"
    # Note: metagear.env does not exist

    # 3) Call install.sh with --install-dir
    install_script="$BATS_TEST_DIRNAME/../install.sh"
    run bash "$install_script" --install-dir "$temp_dir"

    # 4) Check that installation completed successfully
    [ "$status" -eq 0 ]

    # 5) Check that existing file is preserved
    [ -f "$temp_dir/metagear.config" ]
    grep "Original config content" "$temp_dir/metagear.config"

    # 6) Check that non-existing file is created
    [ -f "$temp_dir/metagear.env" ]
    grep "NXF_SINGULARITY_CACHEDIR" "$temp_dir/metagear.env"

    # 7) Check output messages
    [[ "$output" =~ "Configuration file already exists, skipping" ]]
    [[ "$output" =~ "Environment file created:" ]]

    # Clean up
    cd "$original_dir"
    rm -rf "$temp_dir"
    rm -rf "$temp_work_dir"
}
