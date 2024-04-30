#!/usr/bin/env bash

setup_api_test() {
  read -r -a script_call <<< "${SCRIPT_CALL:?}"
  echo "script_call: [n=${#script_call[@]}] ${script_call[*]}"
  [[ ${#script_call[@]} -gt 0 ]] || fail "SCRIPT_CALL is empty"
  
  script_preamble="${SCRIPT_PREAMBLE[@]}"
  echo "script_preamble: [n=${#script_preamble[@]}] ${script_preamble[*]}"

  script_print_fmt="${SCRIPT_PRINT_FMT:-print(%s)}"
  echo "script_print_fmt: ${script_print_fmt}"
  [[ -n ${script_print_fmt} ]] || fail "SCRIPT_PRINT_FMT is empty"

  script_args_sep="${SCRIPT_ARGS_SEP}"
  if [[ -z ${script_args_sep} ]]; then
      script_args_sep=" "
  fi
  echo "script_args_sep: ${script_args_sep}"

  script_arg_fmt="${SCRIPT_ARG_FMT:-\"%s\"}"
  echo "script_arg_fmt: ${script_arg_fmt}"
  [[ -n ${script_arg_fmt} ]] || fail "SCRIPT_ARG_FMT is empty"
  
  script_call_fmt="${SCRIPT_CALL_FMT:-%s(%s)}"
  echo "script_call_fmt: ${script_call_fmt}"
  [[ -n ${script_call_fmt} ]] || fail "SCRIPT_CALL_FMT is empty"
}


args_to_string() {
  local res
  local arg
  res=""
  for arg in "$@"; do
      arg=$(printf "${script_arg_fmt}" "${arg}")
      if [[ -z ${res} ]]; then
          res=${arg}
      else
          res="${res}${script_args_sep}${arg}"
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
  call=$(printf "${script_call_fmt}" "${fcn}" "$(args_to_string "${args[@]}")")
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
