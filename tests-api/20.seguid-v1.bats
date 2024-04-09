#!/usr/bin/env bats

setup() {
    load "test_helper/bats-support/load"
    load "test_helper/bats-assert/load"
    source "utils.sh"
    setup_api_test
}

## --------------------------------------------------------
## SEGUID v1
## --------------------------------------------------------
@test "seguid('ACGT')" {
    run api_call "seguid" "'ACGT'"
    assert_success
    assert_output "seguid=IQiZThf2zKn/I1KtqStlEdsHYDQ"
}

@test "seguid('A')" {
    run api_call "seguid" "'A'"
    assert_success
    assert_output "seguid=bc1M4j2I4u6VaLpUbAB8Y9kTHBs"
}
