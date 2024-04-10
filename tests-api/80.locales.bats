#!/usr/bin/env bats

setup() {
    load "test_helper/bats-support/load"
    load "test_helper/bats-assert/load"
    source "utils.sh"
    setup_api_test
}


## --------------------------------------------------------
## Lexicographic ordering in current locale
## --------------------------------------------------------
@test "csseguid('0A', '0,A') with current LC_COLLATE" {
    local alphabet seq truth
    seq="0A"
    alphabet="0,A"
    truth=$(api_call "lsseguid" "'${seq}'" "'${alphabet}'")
    truth=${truth/lsseguid=/csseguid=}
    echo "truth=${truth:?}"
    locale -a | grep "${LC_COLLATE}"
    echo "LC_COLLATE=${LC_COLLATE:-<not set>}"
    run api_call "csseguid" "'${seq}'" "'${alphabet}'"
    assert_success
    assert_output --partial "${truth}"
}

@test "csseguid('0a', '0,a') with current LC_COLLATE" {
    local alphabet seq truth
    seq="0a"
    alphabet="0,a"
    truth=$(api_call "lsseguid" "'${seq}'" "'${alphabet}'")
    truth=${truth/lsseguid=/csseguid=}
    echo "truth=${truth:?}"
    locale -a | grep "${LC_COLLATE}"
    echo "LC_COLLATE=${LC_COLLATE:-<not set>}"
    run api_call "csseguid" "'${seq}'" "'${alphabet}'"
    assert_success
    assert_output --partial "${truth}"
}

@test "csseguid('Aa', 'A,a') with current LC_COLLATE" {
    local alphabet seq truth
    seq="Aa"
    alphabet="A,a"
    truth=$(api_call "lsseguid" "'${seq}'" "'${alphabet}'")
    truth=${truth/lsseguid=/csseguid=}
    echo "truth=${truth:?}"
    locale -a | grep "${LC_COLLATE}"
    echo "LC_COLLATE=${LC_COLLATE:-<not set>}"
    run api_call "csseguid" "'${seq}'" "'${alphabet}'"
    assert_success
    assert_output --partial "${truth}"
}

@test "csseguid('TZ', 'T,Z') with current LC_COLLATE" {
    local alphabet seq truth
    seq="TZ"
    alphabet="T,Z"
    truth=$(api_call "lsseguid" "'${seq}'" "'${alphabet}'")
    truth=${truth/lsseguid=/csseguid=}
    echo "truth=${truth:?}"
    locale -a | grep "${LC_COLLATE}"
    echo "LC_COLLATE=${LC_COLLATE:-<not set>}"
    run api_call "csseguid" "'${seq}'" "'${alphabet}'"
    assert_success
    assert_output --partial "${truth}"
}
