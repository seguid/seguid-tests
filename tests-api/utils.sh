#!/usr/bin/env bash

setup_api_test() {
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

  if [[ ${#script_call[@]} -eq 0 ]]; then
      fail "Bash array 'script_call' is empty"
  fi
  
  tf=$(mktemp)
  ## Add script preamble
  printf "%s\n" "${script_preamble[@]}" > "${tf}"
  ## Generate API call
  call="${fcn}($(args_to_string "${args[@]}"))"
  ## Wrap API call in print statement
  call=$(printf "${script_print_fmt}" "${call}")
  printf "%s\n" "${call}" >> "${tf}"

  ## Call script
  if ${BATS_DEBUG:-false}; then
    >&3 echo "--- script ----------------------"
    >&3 cat "${tf}"
    >&3 echo "---------------------------------"
  fi
  
  "${script_call[@]}" "${tf}"
  res=$?
  rm "${tf}"
  return "${res}"
}