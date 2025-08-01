#!/usr/bin/env bats

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

    # 5) Run metagear wrapper once to trigger config file creation (metagear.config is created when main.sh is first run)
    export INSTALL_DIR="$temp_dir"
    run "./metagear" --help

    # 6) Check that metagear.config, and metagear.env exists in the installation directory
    [ -f "$temp_dir/metagear.config" ]
    [ -f "$temp_dir/metagear.env" ]
    
    # Clean up
    cd "$original_dir"
    rm -rf "$temp_dir"
    rm -rf "$temp_work_dir"
}
