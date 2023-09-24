#!/usr/bin/env bash

source ./helpers.exclude.sh

# --------------------

sh ./bootstrap.exclude.sh bash

# --------------------
# bash specific
symlink_configs bash/
check_shell bash
# --------------------

true
