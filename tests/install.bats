#!/usr/bin/env -S bats --shell /usr/bin/env bash

setup() {
  TEST_HOME="$BATS_TMPDIR/home"
  mkdir -p "$TEST_HOME"
  export HOME="$TEST_HOME"
}

teardown() {
  rm -rf "$TEST_HOME"
}

@test "install.sh creates wrapper and templates" {
  cd "$BATS_TMPDIR"
  run "$BATS_TEST_DIRNAME/../install.sh"
  [ -f metagear ]
  [ -f "$HOME/.metagear/utilities/templates/metagear.config" ]
  [ -f "$HOME/.metagear/utilities/templates/metagear.env" ]
}
