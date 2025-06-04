#!/usr/bin/env -S bats --shell /usr/bin/env bash

setup() {
  TEST_HOME="$BATS_TMPDIR/home"
  mkdir -p "$TEST_HOME"
  export HOME="$TEST_HOME"
  mkdir -p "$HOME/.metagear/latest/conf/metagear"
  cp "$BATS_TEST_DIRNAME/../templates/metagear.config" "$HOME/.metagear/metagear.config"
  cp "$BATS_TEST_DIRNAME/../templates/metagear.env" "$HOME/.metagear/metagear.env"
  touch "$HOME/.metagear/latest/conf/metagear/qc_dna.config"
}

teardown() {
  rm -rf "$TEST_HOME"
}

@test "main.sh preview outputs script" {
  cd "$BATS_TMPDIR"
  echo -e "sample,fastq_1,fastq_2\nS1,a,b" > test.csv
  run "$BATS_TEST_DIRNAME/../main.sh" qc_dna --input test.csv -preview
  [ -f metagear_qc_dna.sh ]
  [[ "$output" == *"Preview mode"* ]]
  [[ "$output" == *"metagear_qc_dna.sh"* ]]
}
