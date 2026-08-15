#!/usr/bin/env bash


if ! (env | grep -q ^OPENRAM_BUILD_PATH=)
then
    export OPENRAM_BUILD_PATH=../macro-gen/openram/build
fi

function copy_openram_macro() {
    name=$1
    OUT_PATH=$OPENRAM_BUILD_PATH/$name

    rm -v **/$name*

    cp -v $OUT_PATH/$name.gds  gds/$name.gds
    cp -v $OUT_PATH/$name.lef  lef/$name.lef
    # cp -v $OUT_PATH/$name.nl.v  verilog/$name.nl.v
    cp -v $OUT_PATH/$name.v  verilog/$name.v
    cp -v $OUT_PATH/$name_*.lib  lib/
}


copy_openram_macro sram_1rw1r_32x1024