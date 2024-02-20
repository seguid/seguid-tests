SHELL=bash
BATS_SUPPORT_VERSION=0.3.0
BATS_ASSERT_VERSION=2.1.0

all: check-cli/seguid-python check-cli/seguid-r

assert-bats:
	command -v "bats" || { >&2 echo "ERROR: Please install Bats (https://bats-core.readthedocs.io/)"; exit 1; }

assert-CLI_CALL:
	[[ -n "${CLI_CALL}" ]] || { >&2 echo "ERROR: CLI_CALL is not specified"; exit 1; }

check-cli: assert-CLI_CALL assert-bats tests/test_helper/bats
	cd tests/; \
	bats *.bats

check-cli/seguid-python:
	make check-cli CLI_CALL="python -m seguid" 

check-cli/seguid-r:
	make check-cli CLI_CALL="Rscript -e seguid::seguid --args"

tests/test_helper/bats: tests/test_helper/bats-support tests/test_helper/bats-assert

tests/test_helper/bats-support:
	mkdir -p tests/test_helper; \
	file="v$(BATS_SUPPORT_VERSION).tar.gz"; \
	echo "file=$${file}"; \
	curl -L -O https://github.com/bats-core/$(@F)/archive/refs/tags/$${file} && tar xf "$${file}" && mv "$(@F)-$(BATS_SUPPORT_VERSION)" "tests/test_helper/$(@F)" && rm "$${file}"

tests/test_helper/bats-assert:
	mkdir -p tests/test_helper; \
	file="v$(BATS_ASSERT_VERSION).tar.gz"; \
	echo "file=$${file}"; \
	curl -L -O https://github.com/bats-core/$(@F)/archive/refs/tags/$${file} && tar xf "$${file}" && mv "$(@F)-$(BATS_ASSERT_VERSION)" "tests/test_helper/$(@F)" && rm "$${file}"
