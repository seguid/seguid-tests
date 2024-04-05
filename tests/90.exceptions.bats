#!/usr/bin/env bats

setup() {
    load "test_helper/bats-support/load"
    load "test_helper/bats-assert/load"

    read -r -a cli_call <<< "${CLI_CALL:?}"
    echo "cli_call: [n=${#cli_call[@]}] ${cli_call[*]}"
}


## --------------------------------------------------------
## Exceptions: Empty input is assume to be a user error
## --------------------------------------------------------
@test "<CLI call> --type=seguid <<< '' (empty input)" {
    run "${cli_call[@]}" --type=seguid <<< ''
    assert_failure
}

@test "<CLI call> --type=lsseguid <<< '' (empty input)" {
    run "${cli_call[@]}" --type=lsseguid <<< ''
    assert_failure
}

@test "<CLI call> --type=csseguid <<< '' (empty input)" {
    run "${cli_call[@]}" --type=csseguid <<< ''
    assert_failure
}

@test "<CLI call> --type=ldseguid <<< '' (empty input)" {
    run "${cli_call[@]}" --type=ldseguid <<< ''
    assert_failure
}

@test "<CLI call> --type=cdseguid <<< '' (empty input)" {
    run "${cli_call[@]}" --type=cdseguid <<< ''
    assert_failure
}


## --------------------------------------------------------
## Exceptions: Too many lines of input data
## --------------------------------------------------------
@test "<CLI call> --type=seguid <<< \$'ACTG\nTGCA' (too many lines)" {
    run "${cli_call[@]}" --type=seguid <<< $'ACTG\nTGCA'
    assert_failure
}

@test "<CLI call> --type=seguid <<< 'ACTG;ACGT' (too many strands)" {
    run "${cli_call[@]}" --type=seguid <<< 'ACTG;ACGT'
    assert_failure
}

@test "<CLI call> --type=lsseguid <<< \$'ACTG\nTGCA' (too many lines)" {
    run "${cli_call[@]}" --type=lsseguid <<< $'ACTG\nTGCA'
    assert_failure
}

@test "<CLI call> --type=lsseguid <<< 'ACTG;ACGT' (too many strands)" {
    run "${cli_call[@]}" --type=lsseguid <<< 'ACTG;ACGT'
    assert_failure
}

@test "<CLI call> --type=ldseguid <<< \$'ACTG\nTGCA\nTGCA' (too many lines)" {
    run "${cli_call[@]}" --type=ldseguid <<< $'ACTG\nTGCA\nTGCA'
    assert_failure
}

@test "<CLI call> --type=ldseguid <<< 'ACTG;ACGT;TGCA' (too many strings)" {
    run "${cli_call[@]}" --type=ldseguid <<< 'ACTG;ACGT;TGCA'
    assert_failure
}

@test "<CLI call> --type=cdseguid <<< \$'ACTG\nTGCA\nTGCA' (too many lines)" {
    run "${cli_call[@]}" --type=cdseguid <<< $'ACTG\nTGCA\nTGCA'
    assert_failure
}

@test "<CLI call> --type=cdseguid <<< 'ACTG;ACGT;TGCA' (too many strands)" {
    run "${cli_call[@]}" --type=cdseguid <<< 'ACTG;ACGT;TGCA'
    assert_failure
}


## --------------------------------------------------------
## Exceptions: Invalid symbols
## --------------------------------------------------------
@test "<CLI call> <<< 'aCGT' gives error (invalid symbol)" {
    run "${cli_call[@]}" <<< 'aCGT'
    assert_failure
}

@test "<CLI call> <<< ' ACGT' gives error (invalid symbol)" {
    run "${cli_call[@]}" <<< ' ACGT'
    assert_failure
}

@test "<CLI call> --type=ldseguid <<< \$' ACGT\nTGCA' gives error (invalid symbol)" {
    run "${cli_call[@]}" --type=ldseguid <<< $' ACGT\nTGCA '
    assert_failure
}

@test "<CLI call> --type=ldseguid <<< ' ACGT;ACGT' gives error (invalid symbol)" {
    run "${cli_call[@]}" --type=ldseguid <<< ' ACGT;ACGT'
    assert_failure
}


## --------------------------------------------------------
## Exceptions: Non-matching strands
## --------------------------------------------------------
@test "<CLI call> --type=ldseguid <<< \$'ACGT\nTGC' gives error (unbalanced lengths)" {
    run "${cli_call[@]}" --type=ldseguid <<< $'ACGT\nTGC'
    assert_failure
}

@test "<CLI call> --type=ldseguid <<< 'ACGT;CGT' gives error (unbalanced lengths)" {
    run "${cli_call[@]}" --type=ldseguid <<< 'ACGT;CGT'
    assert_failure
}

@test "<CLI call> --type=ldseguid <<< \$'ACGT\nTGCC' gives error (incompatible sequences)" {
    run "${cli_call[@]}" --type=ldseguid <<< $'ACGT\nTGCC'
    assert_failure
}

@test "<CLI call> --type=ldseguid <<< 'ACGT;CCGT' gives error (incompatible sequences)" {
    run "${cli_call[@]}" --type=ldseguid <<< 'ACGT;CCGT'
    assert_failure
}
