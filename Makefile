SHELL=bash

all: check-cli/seguid-python check-cli/seguid-r

assert-bats:
	command -v "bats" || { >&2 echo "ERROR: Please install Bats (https://bats-core.readthedocs.io/)"; exit 1; }

assert-CLI_CALL:
	[[ -n "${CLI_CALL}" ]] || { >&2 echo "ERROR: CLI_CALL is not specified"; exit 1; }

check-cli: assert-CLI_CALL assert-bats
	cd tests/; \
	bats *.bats

check-cli/seguid-python:
	make check-cli CLI_CALL="python -m seguid" 

check-cli/seguid-r:
	make check-cli CLI_CALL="Rscript -e seguid::seguid --args"

