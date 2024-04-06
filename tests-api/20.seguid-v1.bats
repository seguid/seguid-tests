#!/usr/bin/env bats

setup() {
    load "test_helper/bats-support/load"
    load "test_helper/bats-assert/load"

    read -r -a script_call <<< "${SCRIPT_CALL:?}"
    echo "script_call: [n=${#script_call[@]}] ${script_call[*]}"
    
    script_preamble="${SCRIPT_PREAMBLE[@]}"
    echo "script_preamble: [n=${#script_preamble[@]}] ${script_preamble[*]}"

    script_print_fmt="${SCRIPT_PRINT_FMT:-print(%s)}"
    echo "script_print_fmt: ${script_print_fmt}"
}

args_to_string() {
  local res
  local arg
  res=""
  for arg in "$@"; do
    if [[ -z ${res} ]]; then
      res=${arg}
    else
      res="${res}, ${arg}"
    fi
  done
  echo "${res}"
}

api_call() {
  local fcn
  local -a args
  local call
  local tf
  local res
  
  fcn=${1:?}
  shift
  args=("$@")

  tf=$(mktemp)
  ## Add script preamble
  printf "%s\n" "${script_preamble[@]}" > "${tf}"
  ## Generate API call
  call="${fcn}($(args_to_string "${args[@]}"))"
  ## Wrap API call in print statement
  call=$(printf "${script_print_fmt}" "${call}")
  printf "%s\n" "${call}" >> "${tf}"

  ## Call script
#  >&3 cat "${tf}"
  "${script_call[@]}" "${tf}"
  res=$?
  rm "${tf}"
  return "${res}"
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
