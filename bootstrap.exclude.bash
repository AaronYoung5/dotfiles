#!/usr/bin/env bash

source ./helpers.exclude.sh

# --------------------

sh ./bootstrap.exclude.sh bash

# --------------------
# bash specific
symlink_configs bash.exclude/
check_shell bash
# --------------------

true
