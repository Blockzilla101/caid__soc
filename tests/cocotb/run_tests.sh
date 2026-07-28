#!/usr/bin/env bash

CWD=$(pwd)

LIBRELANE_PATH=$HOME/ic-design/librelane

cd ${LIBRELANE_PATH}
eval "$(nix print-dev-env)"

cd $CWD

mkdir -p waves
rm waves/*

WAVES=1 uv run run_tests.py