#!/usr/bin/env bats

setup() {
    load "test_helper/bats-support/load"
    load "test_helper/bats-assert/load"
    source "utils.sh"
    setup_api_test
}

## --------------------------------------------------------
## lsseguid()
## --------------------------------------------------------
@test "lsseguid('ACGT')" {
    run api_call "lsseguid" "'ACGT'"
    assert_success
    assert_output "lsseguid=IQiZThf2zKn_I1KtqStlEdsHYDQ"
}

@test "lsseguid('A') (single-symbol input)" {
    run api_call "lsseguid" "'A'"
    assert_success
    assert_output "lsseguid=bc1M4j2I4u6VaLpUbAB8Y9kTHBs"
}


## --------------------------------------------------------
## ldsseguid()
## --------------------------------------------------------
@test "ldseguid('AACGT', 'ACGTT')" {
    run api_call "ldseguid" "'AACGT'" "'ACGTT'"
    assert_success
    assert_output "ldseguid=5fHMG19IbYxn7Yr7_sOCkvaaw7U"
}

@test "ldseguid('ACGTT', 'AACGT' (strand symmetry)" {
    truth=$(api_call "ldseguid" "'AACGT', 'ACGTT'")
    run api_call "ldseguid" "'ACGTT', 'AACGT'"
    assert_success
    assert_output "${truth}"
}

@test "ldseguid('-CGT', 'ACGT')" {
    run api_call "ldseguid" "'-CGT'" "'ACGT'"
    assert_success
    assert_output "ldseguid=PVID4ZDkJEzFu2w2RLBCMQdZgvE"
}

@test "ldseguid('-CGT', '-CGT')" {
    run api_call "ldseguid" "'-CGT'" "'-CGT'"
    assert_success
    assert_output "ldseguid=s_nCUnQCNz7NjQQTOBmoqIvXexA"
}

@test "ldseguid('--TTACA', '-GTAATC')" {
    run api_call "ldseguid" "'--TTACA'" "'-GTAATC'"
    assert_success
    assert_output "ldseguid=4RNiS6tZ_3dnHmqD_15_83vEqKQ"
}

@test "ldseguid('A', 'T') (single-symbol input)" {
    run api_call "ldseguid" "'A'" "'T'"
    assert_success
    assert_output "ldseguid=ydezQsYTZgUCcb3-adxMaq_Xf8g"
}


## --------------------------------------------------------
## csseguid()
## --------------------------------------------------------
@test "csseguid('ACGT')" {
    run api_call "csseguid" "'ACGT'"
    assert_success
    assert_output "csseguid=IQiZThf2zKn_I1KtqStlEdsHYDQ"
}

@test "csseguid('CGTA') (rotation invariant)" {
    truth=$(api_call "csseguid" "'ACGT'")
    run api_call "csseguid" "'CGTA'"
    assert_success
    assert_output "${truth}"
}

@test "csseguid('GTAC') (rotation invariant)" {
    truth=$(api_call "csseguid" "'ACGT'")
    run api_call "csseguid" "'GTAC'"
    assert_success
    assert_output "${truth}"
}

@test "csseguid('A') (single-symbol input)" {
    run api_call "csseguid" "'A'"
    assert_success
    assert_output "csseguid=bc1M4j2I4u6VaLpUbAB8Y9kTHBs"
}


## --------------------------------------------------------
## cdseguid()
## --------------------------------------------------------
@test "cdseguid('AACGT', 'ACGTT')" {
    run api_call "cdseguid" "'AACGT'" "'ACGTT'"
    assert_success
    assert_output "cdseguid=5fHMG19IbYxn7Yr7_sOCkvaaw7U"
}

@test "cdseguid('CGTAA', 'TTACG') (rotation invariant)" {
    run api_call "cdseguid" "'CGTAA'" "'TTACG'"
    assert_success
    assert_output "cdseguid=5fHMG19IbYxn7Yr7_sOCkvaaw7U"
}

@test "cdseguid('GTAAC', 'GTTAC') (rotation invariant)" {
    truth=$(api_call "cdseguid" "'CGTAA'" "'TTACG'")
    run api_call "cdseguid" "'GTAAC'" "'GTTAC'"
    assert_success
    assert_output "${truth}"
}

@test "cdseguid('GTTAC', 'GTAAC') (strand symmetry)" {
    truth=$(api_call "cdseguid" "'CGTAA'" "'TTACG'")
    run api_call "cdseguid" "'GTTAC'" "'GTAAC'"
    assert_success
    assert_output "${truth}"
}

@test "cdseguid('A', 'T') (single-symbol input)" {
    run api_call "cdseguid" "'A'" "'T'"
    assert_success
    assert_output "cdseguid=ydezQsYTZgUCcb3-adxMaq_Xf8g"
}
