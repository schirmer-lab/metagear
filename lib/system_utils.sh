#!/usr/bin/env bash
set -euo pipefail

# Function to get total installed memory in GB.
get_total_memory_gb() {
    case "$(uname)" in
        Linux)
            # Read MemTotal (in kB) from /proc/meminfo
            local mem_total_kb
            mem_total_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
            # Convert kB to GB
            awk -v mem="$mem_total_kb" 'BEGIN {printf "%.2f", mem/1048576}'
            ;;
        Darwin)
            # macOS: sysctl hw.memsize returns bytes
            local mem_bytes
            mem_bytes=$(sysctl -n hw.memsize)
            # Convert bytes to GB
            awk -v mem="$mem_bytes" 'BEGIN {printf "%.2f", mem/1024/1024/1024}'
            ;;
        *)
            echo "0"
            ;;
    esac
}

# Function to get the number of available CPUs.
get_cpu_count() {
    case "$(uname)" in
        Linux)
            if command -v nproc >/dev/null 2>&1; then
                nproc
            else
                echo "1"
            fi
            ;;
        Darwin)
            # macOS: sysctl hw.ncpu returns the CPU count
            sysctl -n hw.ncpu
            ;;
        *)
            echo "1"
            ;;
    esac
}
