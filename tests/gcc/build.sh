#!/usr/bin/bash

mkdir -p build
rm build/*

function build_file() {
    local TARGET_FILE_NAME=$1
    local ELF_FILE=build/$TARGET_FILE_NAME.elf
    local BIN_FILE=build/$TARGET_FILE_NAME.bin
    local MEM_FILE=build/$TARGET_FILE_NAME.mem
    local C_FILE=test_programs/$TARGET_FILE_NAME.c

    riscv64-elf-gcc \
        -Os \
        -march=rv32i \
        -mabi=ilp32 \
        -nostdlib \
        -nostartfiles \
        -ffreestanding \
        -fno-builtin \
        -static \
        -Wl,-N \
        -Wl,--no-dynamic-linker \
        -T libs/link.ld \
        -o $ELF_FILE \
        libs/crt0.s \
        $C_FILE


    riscv64-elf-objcopy -O binary $ELF_FILE $BIN_FILE
    riscv64-elf-objdump -d $ELF_FILE > $ELF_FILE.dump
    # hexdump -v -e '1/1 "%02x\n"' $BIN_FILE > $MEM_FILE.temp
    hexdump -v -e '1/4 "%08x\n"' $BIN_FILE > $MEM_FILE.temp
    # cat <(echo -e "13\n00\n00\n00") $MEM_FILE.temp > $MEM_FILE
    cat <(echo -e "13000000") $MEM_FILE.temp > $MEM_FILE
    rm $MEM_FILE.temp
}

for file in $(find test_programs -type f | xargs -I % basename % .c); do
    build_file $file
done