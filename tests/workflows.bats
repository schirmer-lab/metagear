#!/usr/bin/env bats

load '../lib/workflows.sh'

@test "download_databases omits --input" {
  result="$(run_workflows download_databases)"
  [[ "$result" != *"--input"* ]]
}

@test "qc_dna includes --input" {
  result="$(run_workflows qc_dna)"
  [[ "$result" == *"--input"* ]]
}
