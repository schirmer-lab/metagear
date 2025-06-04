#!/usr/bin/env -S bats --shell /usr/bin/env bash

setup() {
  source "$BATS_TEST_DIRNAME/../lib/workflows.sh"
  load ../lib/workflows.sh
  #source "lib/workflows.sh"
}

@test "download_databases omits --input" {
  source "lib/workflows.sh"
  workflow="download_databases"
  result="$(run_workflows $workflow)"
  
  echo "require_input: ${require_input[$workflow]}, result: $result"

  [[ "$result" != *"--input"* ]]
}

@test "qc_dna includes --input" {
  source "lib/workflows.sh"
  workflow="qc_dna"

  result="$(run_workflows $workflow --input test.csv)"
  
  echo "require_input: ${require_input[$workflow]}, result: $result"
  
  [[ "$result" == *"--input"* ]]
}
