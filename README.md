[![JavaScript checks](https://github.com/seguid/seguid-tests/actions/workflows/check-javascript.yml/badge.svg)](https://github.com/seguid/seguid-tests/actions/workflows/check-javascript.yml)
[![Python checks](https://github.com/seguid/seguid-tests/actions/workflows/check-python.yml/badge.svg)](https://github.com/seguid/seguid-tests/actions/workflows/check-python.yml)
[![R checks](https://github.com/seguid/seguid-tests/actions/workflows/check-r.yml/badge.svg)](https://github.com/seguid/seguid-tests/actions/workflows/check-r.yml)
[![Tcl checks](https://github.com/seguid/seguid-tests/actions/workflows/check-tcl.yml/badge.svg)](https://github.com/seguid/seguid-tests/actions/workflows/check-tcl.yml)


# seguid-tests: Test Suite for SEGUID Implementations

This repository provides as set of unit tests for validating current
and to-be-release SEGUID implementations. It provides tests that
validates the application programming interface (API) and tests that
validated the command-line interface (CLI). If an implementation
passes these checks, the implementation is considered compliant with
the offical SEGUID v2 specifications.


## TL;DR

To check the CLI for Python, R, etc., use:

```sh
make check-cli/seguid-python
make check-cli/seguid-r
```

To check the API for Python, R, etc., use:

```sh
make check-api/seguid-python
make check-api/seguid-r
```


## Details

### Testing the command-line interface

To test the CLI of a specific implementation, use format:

```sh
$ make check-cli CLI_CALL="cmd <options>" 
```

where `"cmd <options>"` is the command with options use to call the
SEGUID CLI.  For example, the CLI of the Python **seguid** package is
called using the format:

```sh
$ python -m seguid ...
```

Thus, to test this interface, call:

```sh
$ make check-cli CLI_CALL="python -m seguid" 
```

A pre-defined short version of this is:

```sh
$ make check-cli/seguid-python
```

Similarly, for the CLI of the R **seguid** package, use:


```sh
$ make check-cli CLI_CALL="Rscript -e seguid::seguid --args" 
```

or short:

```sh
$ make check-cli/seguid-r
```


For the Javascript **seguid** package, use:


```sh
$ make check-cli CLI_CALL="npx seguid" 
```

or short:

```sh
$ make check-cli/seguid-javascript
```


### Testing the application programming interface

To test the API of a specific implementation, use format:

```sh
$ make check-api SCRIPT_CALL="cmd <options>" SCRIPT_PREAMBLE="<script header>" SCRIPT_PRINT_FMT="<print call>"
```

For example, to test the API of the Python implementation, call:

```sh
$ make check-api SCRIPT_CALL="node" SCRIPT_PREAMBLE="const { seguid, lsseguid, ldseguid, csseguid, cdseguid } = require('seguid')" SCRIPT_PRINT_FMT="console.log(%s)"
```

A pre-defined short version of this is:

```sh
$ make check-api/seguid-python
```

Similarly, for the API of the R **seguid** package, use:


```sh
$ make check-api SCRIPT_CALL="Rscript --no-init-file" SCRIPT_PREAMBLE="library(seguid)" SCRIPT_PRINT_FMT="cat(%s)"
```

or short:

```sh
$ make check-api/seguid-r
```

## Parallel option

Pass a `BATS_JOBS` environment variable, e.g. `BATS_JOBS=16 make`.
You need [GNU parallel](https://www.gnu.org/software/parallel/) for
this to work.

## Requirements

The checks are implemented in Bash and Bats (Bash Automated Testing
System):

* Bash
* [bats-core]

[bats-core]: https://bats-core.readthedocs.io/en/stable/
