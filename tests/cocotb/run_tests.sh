#!/usr/bin/env bash

mkdir -p waves
rm waves/*

export WISHBONE_TEST=1
# export ASM_TEST=1
# export GCC_TEST=1

WAVES=1 uv run run_tests.py
