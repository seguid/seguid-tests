#!/usr/bin/env bats

setup() {
    load "test_helper/bats-support/load"
    load "test_helper/bats-assert/load"
    source "utils.sh"
    setup_api_test
}


## --------------------------------------------------------
## Alphabet: custom
## --------------------------------------------------------
@test "seguid('ACGU', 'AU,CG')" {
    run api_call "seguid" "'ACGU'" "'AU,CG'"
    assert_success
    assert_output "seguid=LLaWk2Jb8NGt20QXhgm+cSVat34"
}

@test "seguid('ACGT', 'AT,CG')" {
    run api_call "seguid" "'ACGT'" "'AT,CG'"
    assert_success
    assert_output "seguid=IQiZThf2zKn/I1KtqStlEdsHYDQ"
}

@test "seguid('ARDNAKNTLYLQMSRLRSEDTAMYYCAR', 'A,C,D,E,F,G,H,I,K,L,M,N,P,Q,R,S,T,V,W,Y')" {
    run api_call "seguid" "'ARDNAKNTLYLQMSRLRSEDTAMYYCAR'" "'A,C,D,E,F,G,H,I,K,L,M,N,P,Q,R,S,T,V,W,Y'"
    assert_success
    assert_output "seguid=IdtGC8ZYgDbkA0i4u4n0tiAQwng"
}

# Expanded epigenetic alphabet per Viner et al. (2024)
@test "lsseguid('AmT2C', '{DNA},m1,h2,f3,c4')" {
    run api_call "lsseguid" "'AmT2C'" "'{DNA},m1,h2,f3,c4'"
    assert_success
    assert_output "lsseguid=MW4Rh3lGY2mhwteaSKh1-Kn2fGA"
}

# Expanded epigenetic alphabet per Viner et al. (2024)
@test "ldseguid('AmT2C', 'GhA1T', '{DNA},m1,h2,f3,c4')" {
    run api_call "ldseguid" "'AmT2C'" "'GhA1T'" "'{DNA},m1,h2,f3,c4'"
    assert_success
    assert_output "ldseguid=bFZedILTms4ORUi3SSMfU0FUl7Q"
}

# Ambigous expanded epigenetic alphabet per Viner et al. (2024)
@test "ldseguid('AAAhyAmA', 'T1T82TTT', '{DNA},m1,h2,f3,c4,w6,x7,y8,z9')" {
    run api_call "ldseguid" "'AAAhyAmA'" "'T1T82TTT'" "'{DNA},m1,h2,f3,c4,w6,x7,y8,z9'"
    assert_success
    assert_output "ldseguid=7-4HH4Evl9RhN0OzTK18QPoqjWo"
}

# Non-bijective complementary alphabets
@test "seguid('ACGTU', '{DNA},AU')" {
    run api_call "seguid" "'ACGTU'" "'{DNA},AU'"
    assert_success
    assert_output "seguid=w13LHbo0Y8FHo+vaowojJkwh9nY"
}

# Non-bijective complementary alphabets
@test "ldseguid('AAT', 'AUT', '{DNA},AU')" {
    run api_call "ldseguid" "'AAT'" "'AUT'" "'{DNA},AU'"
    assert_success
    assert_output "ldseguid=fHXyliATc43ySIxHY2Zjlepnupo"
}
