#!/usr/bin/bash

mkdir -p build
rm build/*

function build_file() {
    local TARGET_FILE_NAME=$1
    local ELF_FILE=build/$TARGET_FILE_NAME.elf
    local BIN_FILE=build/$TARGET_FILE_NAME.bin
    local MEM_FILE=build/$TARGET_FILE_NAME.mem
    local ASM_FILE=src/$TARGET_FILE_NAME.s

    # riscv64-elf-as -march=rv32i -mabi=ilp32 $ASM_FILE -o $ELF_FILE
    riscv64-elf-as \
        -march=rv32i \
        -mabi=ilp32 \
        -o $ELF_FILE \
        $ASM_FILE


    riscv64-elf-objcopy -O binary $ELF_FILE $BIN_FILE
    riscv64-elf-objdump -d $ELF_FILE > $ELF_FILE.dump
    hexdump -v -e '1/1 "%02x\n"' $BIN_FILE > $MEM_FILE.temp
    cat <(echo -e "13\n00\n00\n00") $MEM_FILE.temp > $MEM_FILE
    rm $MEM_FILE.temp
}

for file in $(find src -type f | xargs -I % basename % .s); do
    build_file $file
done