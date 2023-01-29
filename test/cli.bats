#!/usr/bin/env bats

setup() { load "bats-setup.bash"; }

@test "cli options --version" {
  run bash-helper --version
  assert_success
  # assert_line ''
}

@test "cli options --help" {
  run bash-helper --help
  assert_success
  assert_line '## Usage ##'
  assert_line '## Modes ##'
}

# vim:ft=bash
