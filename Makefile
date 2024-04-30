SHELL=bash
BATS_SUPPORT_VERSION=0.3.0
BATS_ASSERT_VERSION=2.1.0
BATS = bats/bin/bats


all: check-cli/ALL

assert-bats:
	@git submodule init
	@git submodule update
	@cd tests-cli && command -v "${BATS}" > /dev/null || { >&2 echo "ERROR: bats is not installed"; exit 1; }


# ------------------------------------------------------------
# Submodules
# ------------------------------------------------------------
seguid-%: 
	git submodule status $@ &> /dev/null || git submodule add https://github.com/seguid/$@ $@
	git submodule init
	git submodule update
	cd "$@" && git pull origin main

# ------------------------------------------------------------
# Check CLI API
# ------------------------------------------------------------
assert-CLI_CALL:
	@[[ -n "${CLI_CALL}" ]] || { >&2 echo "ERROR: CLI_CALL is not specified"; exit 1; }

check-cli: assert-CLI_CALL assert-bats
	cd tests-cli && $(BATS) *.bats

check-cli/seguid-javascript:
	$(MAKE) check-cli CLI_CALL="npx seguid" 

check-cli/seguid-python:
	$(MAKE) check-cli CLI_CALL="python -m seguid" 

check-cli/seguid-r:
	$(MAKE) check-cli CLI_CALL="Rscript --no-init-file -e seguid::seguid --args"

check-cli/seguid-tcl: seguid-tcl
	$(MAKE) check-cli CLI_CALL="tclsh $(CURDIR)/$</seguid"

check-cli/ALL: check-cli/seguid-javascript check-cli/seguid-python check-cli/seguid-r check-cli/seguid-tcl



# ------------------------------------------------------------
# Check language API
# ------------------------------------------------------------
assert-SCRIPT_CALL:
	@[[ -n "${SCRIPT_CALL}" ]] || { >&2 echo "ERROR: SCRIPT_CALL is not specified"; exit 1; }

check-api: assert-SCRIPT_CALL assert-bats
	cd tests-api && $(BATS) *.bats

## FIXME: How do I use node/npm so it finds the 'seguid' module?
check-api/seguid-javascript: seguid-javascript
	$(MAKE) check-api NODE_PATH="$(shell pwd)/$<" SCRIPT_CALL="node" SCRIPT_PREAMBLE="const { seguid, lsseguid, ldseguid, csseguid, cdseguid } = require('seguid'); async function print(x) { try { const result = await x; console.log(result); } catch (error) { console.error(error); } }" SCRIPT_PRINT_FMT="print(%s)" SCRIPT_ARGS_SEP=", "

check-api/seguid-python:
	$(MAKE) check-api SCRIPT_CALL="python" SCRIPT_PREAMBLE="from seguid import *" SCRIPT_PRINT_FMT="out=%s\nif isinstance(out, tuple):\n     out=' '.join(out)\nprint(out)" SCRIPT_ARGS_SEP=", "

check-api/seguid-r:
	$(MAKE) check-api SCRIPT_CALL="Rscript --no-init-file" SCRIPT_PREAMBLE="library(seguid)" SCRIPT_PRINT_FMT="cat(%s)" SCRIPT_ARGS_SEP=", "

check-api/seguid-tcl: seguid-tcl
	TCL_PATH="$(shell pwd)/$<"; $(MAKE) check-api SCRIPT_CALL="tclsh" SCRIPT_PREAMBLE="source $${TCL_PATH}/src/base64.tcl; source $${TCL_PATH}/src/sha1.tcl; source $${TCL_PATH}/src/seguid.tcl;" SCRIPT_PRINT_FMT="puts stdout [%s]" SCRIPT_ARGS_SEP=" " SCRIPT_CALL_FMT="%s %s"

check-api/ALL: check-api/seguid-javascript check-api/seguid-python check-api/seguid-r
