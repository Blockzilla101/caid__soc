#!/usr/bin/bash
klayout
# activate-openram

cwd=$(pwd)

echo $OPENRAM_HOME

export OPENRAM_PATH="$HOME/ic-design/OpenRAM"
export OPENRAM_HOME="$OPENRAM_PATH/compiler"
export OPENRAM_TECH="$OPENRAM_PATH/technology"
export PYTHONPATH="$OPENRAM_HOME:$OPENRAM_TECH/sky130:$OPENRAM_TECH/sky130/custom"

export PDK_ROOT=$HOME/.ciel

export SKY130_PDK="$PDK_ROOT/sky130A"

cd $OPENRAM_PATH
source <(nix print-dev-env)

cd $cwd

SRAM_COMPILER=$OPENRAM_PATH/sram_compiler.py

function compile() {
    TARGET=$1

    export OPENRAM_TMP=build/$TARGET/tmp
    python3 -u $SRAM_COMPILER -v $TARGET
}

compile sram_1rw1r_32x1024
