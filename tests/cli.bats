#!/usr/bin/env bats

setup() {
    load "test_helper/bats-support/load"
    load "test_helper/bats-assert/load"

    read -r -a cli_call <<< "${CLI_CALL:?}"
    echo "cli_call: [n=${#cli_call[@]}] ${cli_call[*]}"
}


## --------------------------------------------------------
## Help and version
## --------------------------------------------------------
@test "Version tested" {
    >&3 "${cli_call[@]}" --version
}

@test "<CLI call> --version" {
    run "${cli_call[@]}" --version
    assert_success
    ## Assert numeric x.y.z format
    assert_output --regexp "[[:digit:]]+([.][[:digit:]]+)$"
}

@test "<CLI call> --help" {
    run "${cli_call[@]}" --help
    assert_success
    assert_output --partial "seguid"
    assert_output --partial "--version"
    assert_output --partial "--help"
    assert_output --regexp "[Uu]sage:"
}


## --------------------------------------------------------
## SEGUID v1
## --------------------------------------------------------
@test "<CLI call> <<< \"ACGT\"" {
    run "${cli_call[@]}" <<< "ACGT"
    assert_success
    assert_output "seguid=IQiZThf2zKn/I1KtqStlEdsHYDQ"
}

@test "<CLI call> --type=seguid <<< \"ACGT\"" {
    run "${cli_call[@]}" --type=seguid <<< "ACGT"
    assert_success
    assert_output "seguid=IQiZThf2zKn/I1KtqStlEdsHYDQ"
}

@test "<CLI call> --type=seguid <<< \"\" (single-symbol input)" {
    run "${cli_call[@]}" --type=seguid <<< "A"
    assert_success
    assert_output "seguid=bc1M4j2I4u6VaLpUbAB8Y9kTHBs"
}


## --------------------------------------------------------
## lsseguid()
## --------------------------------------------------------
@test "<CLI call> --type=lsseguid <<< \"ACGT\"" {
    run "${cli_call[@]}" --type=lsseguid <<< "ACGT"
    assert_success
    assert_output "lsseguid=IQiZThf2zKn_I1KtqStlEdsHYDQ"
}

@test "<CLI call> --type=lsseguid <<< \"\" (single-symbol input)" {
    run "${cli_call[@]}" --type=lsseguid <<< "A"
    assert_success
    assert_output "lsseguid=bc1M4j2I4u6VaLpUbAB8Y9kTHBs"
}


## --------------------------------------------------------
## ldsseguid()
## --------------------------------------------------------
@test "<CLI call> --type=ldseguid <<< \$'AACGT\\nTTGCA'" {
    run "${cli_call[@]}" --type=ldseguid <<< $'AACGT\nTTGCA'
    assert_success
    assert_output "ldseguid=5fHMG19IbYxn7Yr7_sOCkvaaw7U"
}

@test "<CLI call> --type=ldseguid <<< \$'ACGTT\\nTGCAA' (strand symmetry)" {
    truth=$("${cli_call[@]}" --type=ldseguid <<< $'AACGT\nTTGCA')
    run "${cli_call[@]}" --type=ldseguid <<< $'ACGTT\nTGCAA'
    assert_success
    assert_output "${truth}"
}

@test "<CLI call> --type=ldseguid <<< \$'-CGT\\nTGCA'" {
    run "${cli_call[@]}" --type=ldseguid <<< $'-CGT\nTGCA'
    assert_success
    assert_output "ldseguid=PVID4ZDkJEzFu2w2RLBCMQdZgvE"
}

@test "<CLI call> --type=ldseguid <<< \$'-CGT\nTGC-'" {
    run "${cli_call[@]}" --type=ldseguid <<< $'-CGT\nTGC-'
    assert_success
    assert_output "ldseguid=s_nCUnQCNz7NjQQTOBmoqIvXexA"
}

@test "<CLI call> --type=ldseguid <<< \$'--TTACA\nCTAATG-'" {
    run "${cli_call[@]}" --type=ldseguid <<< $'--TTACA\nCTAATG-'
    assert_success
    assert_output "ldseguid=4RNiS6tZ_3dnHmqD_15_83vEqKQ"
}

@test "<CLI call> --type=ldseguid <<< \$'A\nT' (single-symbol input)" {
    run "${cli_call[@]}" --type=ldseguid <<< $'A\nT'
    assert_success
    assert_output "ldseguid=ydezQsYTZgUCcb3-adxMaq_Xf8g"
}


## --------------------------------------------------------
## csseguid()
## --------------------------------------------------------
@test "<CLI call> --type=csseguid <<< \"ACGT\"" {
    run "${cli_call[@]}" --type=csseguid <<< "ACGT"
    assert_success
    assert_output "csseguid=IQiZThf2zKn_I1KtqStlEdsHYDQ"
}

@test "<CLI call> --type=csseguid <<< \"CGTA\" (rotation invariant)" {
    truth=$("${cli_call[@]}" --type=csseguid <<< "ACGT")
    run "${cli_call[@]}" --type=csseguid <<< "CGTA"
    assert_success
    assert_output "${truth}"
}

@test "<CLI call> --type=csseguid <<< \"GTAC\" (rotation invariant)" {
    truth=$("${cli_call[@]}" --type=csseguid <<< "ACGT")
    run "${cli_call[@]}" --type=csseguid <<< "GTAC"
    assert_success
    assert_output "${truth}"
}

@test "<CLI call> --type=csseguid <<< \"\" (single-symbol input)" {
    run "${cli_call[@]}" --type=csseguid <<< "A"
    assert_success
    assert_output "csseguid=bc1M4j2I4u6VaLpUbAB8Y9kTHBs"
}


## --------------------------------------------------------
## cdseguid()
## --------------------------------------------------------
@test "<CLI call> --type=cdseguid <<< \$'AACGT\\nTTGCA'" {
    run "${cli_call[@]}" --type=cdseguid <<< $'AACGT\nTTGCA'
    assert_success
    assert_output "cdseguid=5fHMG19IbYxn7Yr7_sOCkvaaw7U"
}

@test "<CLI call> --type=cdseguid <<< \$'CGTAA\\nGCATT' (rotation invariant)" {
    run "${cli_call[@]}" --type=cdseguid <<< $'CGTAA\nGCATT'
    assert_success
    assert_output "cdseguid=5fHMG19IbYxn7Yr7_sOCkvaaw7U"
}

@test "<CLI call> --type=cdseguid <<< \$'GTAAC\\nCATTG' (rotation invariant)" {
    truth=$("${cli_call[@]}" --type=cdseguid <<< $'CGTAA\nGCATT')
    run "${cli_call[@]}" --type=cdseguid <<< $'GTAAC\nCATTG'
    assert_success
    assert_output "${truth}"
}

@test "<CLI call> --type=cdseguid <<< \$'GTTAC\\nCAATG' (strand symmetry)" {
    truth=$("${cli_call[@]}" --type=cdseguid <<< $'CGTAA\nGCATT')
    run "${cli_call[@]}" --type=cdseguid <<< $'GTTAC\nCAATG'
    assert_success
    assert_output "${truth}"
}

@test "<CLI call> --type=cdseguid <<< \$'A\nT' (single-symbol input)" {
    run "${cli_call[@]}" --type=cdseguid <<< $'A\nT'
    assert_success
    assert_output "cdseguid=ydezQsYTZgUCcb3-adxMaq_Xf8g"
}


## --------------------------------------------------------
## Output forms
## --------------------------------------------------------
@test "<CLI call> --type=seguid --alphabet='{DNA}' --form='long' <<< \"ACGT\"" {
    run "${cli_call[@]}" --type=seguid --alphabet='{DNA}' --form='long' <<< "ACGT"
    assert_success
    assert_output "seguid=IQiZThf2zKn/I1KtqStlEdsHYDQ"
}

@test "<CLI call> --type=seguid --alphabet='{DNA}' --form='short' <<< \"ACGT\"" {
    run "${cli_call[@]}" --type=seguid --alphabet='{DNA}' --form='short' <<< "ACGT"
    assert_success
    assert_output "IQiZTh"
}

@test "<CLI call> --type=seguid --alphabet='{DNA}' --form='both' <<< \"ACGT\"" {
    run "${cli_call[@]}" --type=seguid --alphabet='{DNA}' --form='both' <<< "ACGT"
    assert_success
    assert_output "IQiZTh seguid=IQiZThf2zKn/I1KtqStlEdsHYDQ"
}


## --------------------------------------------------------
## Alphabet: DNA
## --------------------------------------------------------
@test "<CLI call> --type=seguid --alphabet='{DNA}' <<< \"ACGT\"" {
    run "${cli_call[@]}" --type=seguid --alphabet='{DNA}' <<< "ACGT"
    assert_success
    assert_output "seguid=IQiZThf2zKn/I1KtqStlEdsHYDQ"
}


## --------------------------------------------------------
## Alphabet: RNA
## --------------------------------------------------------
@test "<CLI call> --alphabet='{RNA}' <<< \"ACGU\"" {
    run "${cli_call[@]}" --alphabet='{RNA}' <<< "ACGU"
    assert_success
    assert_output "seguid=LLaWk2Jb8NGt20QXhgm+cSVat34"
}

@test "<CLI call>--type=seguid --alphabet='{RNA}' <<< \"ACGU\"" {
    run "${cli_call[@]}" --type=seguid --alphabet='{RNA}' <<< "ACGU"
    assert_success
    assert_output "seguid=LLaWk2Jb8NGt20QXhgm+cSVat34"
}

@test "<CLI call> --type=lsseguid --alphabet='{RNA}' <<< \"ACGU\"" {
    run "${cli_call[@]}" --type=lsseguid --alphabet='{RNA}' <<< "ACGU"
    assert_success
    assert_output "lsseguid=LLaWk2Jb8NGt20QXhgm-cSVat34"
}

@test "<CLI call> --type=csseguid --alphabet='{RNA}' <<< \"ACGU\"" {
    run "${cli_call[@]}" --type=csseguid --alphabet='{RNA}' <<< "ACGU"
    assert_success
    assert_output "csseguid=LLaWk2Jb8NGt20QXhgm-cSVat34"
}

@test "<CLI call> --type=ldseguid --alphabet='{RNA}' <<< \$'AACGU\\nUUdTGCA'" {
    run "${cli_call[@]}" --type=ldseguid --alphabet='{RNA}' <<< $'AACGU\nUUGCA'
    assert_success
    assert_output "ldseguid=x5iCPrq2tytNXOWgZroz1u6AN2Y"
}

@test "<CLI call> --type=cdseguid --alphabet='{RNA}' <<< \$'AACGU\\nUUGCA'" {
    run "${cli_call[@]}" --type=cdseguid --alphabet='{RNA}' <<< $'AACGU\nUUGCA'
    assert_success
    assert_output "cdseguid=x5iCPrq2tytNXOWgZroz1u6AN2Y"
}


## --------------------------------------------------------
## Alphabet: protein
## --------------------------------------------------------
## Source: http://bioinformatics.anl.gov/seguid/ftp.aspx
@test "<CLI call> --alphabet='{protein}' <<< 'PQITLWQRPIATIKVGGQLKEALLDTGADDTVLEEMNLPGRWKPKLIGGIGGFVKVRQYDQIPIEICGHQAIGTVLVGPTPANIIGRNLLTQIGCTLNF'" {
    run "${cli_call[@]}" --alphabet='{protein}' <<< "PQITLWQRPIATIKVGGQLKEALLDTGADDTVLEEMNLPGRWKPKLIGGIGGFVKVRQYDQIPIEICGHQAIGTVLVGPTPANIIGRNLLTQIGCTLNF"
    assert_success
    assert_output "seguid=N4/z+gxAPfkFozbb3f3vStDB/5g"
}

@test "<CLI call> --alphabet='{protein}' <<< 'MTEYKLVVVGAGGVGKSALTIQLTQNHFVDEYDPTIE'" {
    run "${cli_call[@]}" --alphabet='{protein}' <<< "MTEYKLVVVGAGGVGKSALTIQLTQNHFVDEYDPTIE"
    assert_success
    assert_output "seguid=PdwDBhhFjE6qlPmSWCJCOjKIDeA"
}

@test "<CLI call> --alphabet='{protein}' <<< 'ARDNAKNTLYLQMSRLRSEDTAMYYCAR'" {
    run "${cli_call[@]}" --alphabet='{protein}' <<< "ARDNAKNTLYLQMSRLRSEDTAMYYCAR"
    assert_success
    assert_output "seguid=IdtGC8ZYgDbkA0i4u4n0tiAQwng"
}


## --------------------------------------------------------
## Alphabet: custom
## --------------------------------------------------------
@test "<CLI call> --alphabet='AU,UA,CG,GC' <<< \"ACGU\"" {
    run "${cli_call[@]}" --alphabet='AU,UA,CG,GC' <<< "ACGU"
    assert_success
    assert_output "seguid=LLaWk2Jb8NGt20QXhgm+cSVat34"
}

@test "<CLI call> --type=seguid --alphabet='AT,TA,CG,GC' <<< \"ACGT\"" {
    run "${cli_call[@]}" --type=seguid --alphabet='AT,TA,CG,GC' <<< "ACGT"
    assert_success
    assert_output "seguid=IQiZThf2zKn/I1KtqStlEdsHYDQ"
}

@test "<CLI call> --alphabet='A,C,D,E,F,G,H,I,K,L,M,N,P,Q,R,S,T,V,W,Y' <<< 'ARDNAKNTLYLQMSRLRSEDTAMYYCAR'" {
    run "${cli_call[@]}" --alphabet='A,C,D,E,F,G,H,I,K,L,M,N,P,Q,R,S,T,V,W,Y' <<< "ARDNAKNTLYLQMSRLRSEDTAMYYCAR"
    assert_success
    assert_output "seguid=IdtGC8ZYgDbkA0i4u4n0tiAQwng"
}

# Expanded epigenetic alphabet per Viner et al. (2024)
@test "<CLI call> --type=lsseguid --alphabet='{DNA},m1,1m,h2,2h,f3,3f,c4,4c' <<< 'AmT2C'" {
    run "${cli_call[@]}" --type=lsseguid --alphabet="{DNA},m1,1m,h2,2h,f3,3f,c4,4c" <<< 'AmT2C'
    assert_success
    assert_output "lsseguid=MW4Rh3lGY2mhwteaSKh1-Kn2fGA"
}

# Expanded epigenetic alphabet per Viner et al. (2024)
@test "<CLI call> --type=ldseguid --alphabet='{DNA},m1,1m,h2,2h,f3,3f,c4,4c' <<< \$'AmT2C\nT1AhG'" {
    run "${cli_call[@]}" --type=ldseguid --alphabet="{DNA},m1,1m,h2,2h,f3,3f,c4,4c" <<< $'AmT2C\nT1AhG'
    assert_success
    assert_output "ldseguid=bFZedILTms4ORUi3SSMfU0FUl7Q"
}

# Ambigous expanded epigenetic alphabet per Viner et al. (2024)
@test "<CLI call> --type=ldseguid --alphabet='{DNA},m1,1m,h2,2h,f3,3f,c4,4c,w6,6w,x7,7x,y8,8y,z9,9z' <<< \$'AmT2C\nT1AhG'" {
    run "${cli_call[@]}" --type=ldseguid --alphabet="{DNA},m1,1m,h2,2h,f3,3f,c4,4c,w6,6w,x7,7x,y8,8y,z9,9z" <<< $'AAAhyAmA\nTTT28T1T'
    assert_success
    assert_output "ldseguid=7-4HH4Evl9RhN0OzTK18QPoqjWo"
}

# Non-bijective complementary alphabets
@test "<CLI call> --alphabet='{DNA},AU,UA' <<< \"ACGTU\"" {
    run "${cli_call[@]}" --alphabet='{DNA},AU,UA' <<< "ACGTU"
    assert_success
    assert_output "seguid=w13LHbo0Y8FHo+vaowojJkwh9nY"
}

# Non-bijective complementary alphabets
@test "<CLI call> --type=ldseguid --alphabet='{DNA},AU,UA' <<< \$'AAT\nTUA'" {
    run "${cli_call[@]}" --type=ldseguid --alphabet='{DNA},AU,UA' <<< $'AAT\nTUA'
    assert_success
    assert_output "ldseguid=fHXyliATc43ySIxHY2Zjlepnupo"
}


## --------------------------------------------------------
## Use checksums as filenames
## --------------------------------------------------------
@test "<CLI call> --type='lsseguid' <<< \"GATTACA\" checksum can be used as a filename" {
    seq="GATTACA"
    ## Comment:
    ## The   SEGUID check is seguid=tp2jzeCM2e3W4yxtrrx09CMKa/8
    ## The slSEGUID check is seguid=tp2jzeCM2e3W4yxtrrx09CMKa_8
    td=$(mktemp -d)
    filename=$("${cli_call[@]}" --type='lsseguid' <<< "${seq}")
    pathname="${td}/${filename}"
    echo "${seq}" > "${pathname}"
    [[ -f "${pathname}" ]]
    run cat "${pathname}"
    assert_success
    assert_output "${seq}"
    rm "${pathname}"
    rmdir "${td}"
}


## --------------------------------------------------------
## Exceptions: Empty input is assume to be a user error
## --------------------------------------------------------
@test "<CLI call> --type=seguid <<< \"\" (empty input)" {
    run "${cli_call[@]}" --type=seguid <<< ""
    assert_failure
}

@test "<CLI call> --type=lsseguid <<< \"\" (empty input)" {
    run "${cli_call[@]}" --type=lsseguid <<< ""
    assert_failure
}

@test "<CLI call> --type=csseguid <<< \"\" (empty input)" {
    run "${cli_call[@]}" --type=csseguid <<< ""
    assert_failure
}

@test "<CLI call> --type=ldseguid <<< \"\" (empty input)" {
    run "${cli_call[@]}" --type=ldseguid <<< ""
    assert_failure
}

@test "<CLI call> --type=cdseguid <<< \"\" (empty input)" {
    run "${cli_call[@]}" --type=cdseguid <<< ""
    assert_failure
}


## --------------------------------------------------------
## Exceptions: Too many lines of input data
## --------------------------------------------------------
@test "<CLI call> --type=seguid <<< \$'ACTG\\nTGCA' (too many lines)" {
    run "${cli_call[@]}" --type=seguid <<< $'ACTG\nTGCA'
    assert_failure
}

@test "<CLI call> --type=lsseguid <<< \$'ACTG\nTGCA' (too many lines)" {
    run "${cli_call[@]}" --type=lsseguid <<< $'ACTG\nTGCA'
    assert_failure
}

@test "<CLI call> --type=ldseguid <<< \$'ACTG\\nTGCA\\nTGCA' (too many lines)" {
    run "${cli_call[@]}" --type=ldseguid <<< $'ACTG\nTGCA\nTGCA'
    assert_failure
}

@test "<CLI call> --type=cdseguid <<< \$'ACTG\\nTGCA\\nTGCA' (too many lines)" {
    run "${cli_call[@]}" --type=cdseguid <<< $'ACTG\nTGCA\nTGCA'
    assert_failure
}


## --------------------------------------------------------
## Exceptions: Invalid symbols
## --------------------------------------------------------
@test "<CLI call> <<< \"aCGT\" gives error (invalid symbol)" {
    run "${cli_call[@]}" <<< "aCGT"
    assert_failure
}

@test "<CLI call> <<< \" ACGT\" gives error (invalid symbol)" {
    run "${cli_call[@]}" <<< " ACGT"
    assert_failure
}

@test "<CLI call> --type=ldseguid <<< \$' ACGT\\nTGCA' gives error (invalid symbol)" {
    run "${cli_call[@]}" --type=ldseguid <<< $' ACGT\nTGCA '
    assert_failure
}


## --------------------------------------------------------
## Exceptions: Non-matching strands
## --------------------------------------------------------
@test "<CLI call> --type=ldseguid <<< \$'ACGT\\nTGC' gives error (unbalanced lengths)" {
    run "${cli_call[@]}" --type=ldseguid <<< $'ACGT\nTGC'
    assert_failure
}

@test "<CLI call> --type=ldseguid <<< \$'ACGT\\nTGCC' gives error (incompatible sequences)" {
    run "${cli_call[@]}" --type=ldseguid <<< $'ACGT\nTGCC'
    assert_failure
}
