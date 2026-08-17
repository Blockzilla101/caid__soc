#!/usr/bin/env bash


if ! (env | grep -q ^OPENRAM_BUILD_PATH=)
then
    export OPENRAM_BUILD_PATH=../macro-gen/openram/build
fi

SRAM_PATH=/home/blockzilla/ic-design/tools/sram22_sky130_macros

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

function copy_sram22_macro() {
    name=$1
    OUT_PATH=$SRAM_PATH/$name

    rm -v **/$name*
    
    cp -v $OUT_PATH/$name.gds  gds/$name.gds
    cp -v $OUT_PATH/$name.lef  lef/$name.lef
    # cp -v $OUT_PATH/$name.nl.v  verilog/$name.nl.v
    cp -v $OUT_PATH/$name.v  verilog/$name.v
    cp -v $OUT_PATH/$name_*.lib  lib/
}

copy_openram_macro sky130_sram_4kbyte_1rw1r_32x1024_8
copy_openram_macro sky130_rom_1kbyte

copy_sram22_macro sram22_1024x32m8w8
