#!/usr/bin/bash

mkdir -p build
rm build/*

AS=$([ -e "$(which riscv64-elf-as 2> /dev/null)" ] && echo -n "riscv64-elf-as" || echo -n "riscv64-unknown-elf-as")
OBJCOPY=$([ -e "$(which riscv64-elf-objcopy 2> /dev/null)" ] && echo -n "riscv64-elf-objcopy" || echo -n "riscv64-unknown-elf-objcopy")
OBJDUMP=$([ -e "$(which riscv64-elf-objdump 2> /dev/null)" ] && echo -n "riscv64-elf-objdump" || echo -n "riscv64-unknown-elf-objdump")

function build_file() {
    local TARGET_FILE_NAME=$1
    local ELF_FILE=build/$TARGET_FILE_NAME.elf
    local BIN_FILE=build/$TARGET_FILE_NAME.bin
    local MEM_FILE=build/$TARGET_FILE_NAME.mem
    local ASM_FILE=src/$TARGET_FILE_NAME.s

    # riscv64-elf-as -march=rv32i -mabi=ilp32 $ASM_FILE -o $ELF_FILE
    $AS \
        -march=rv32i \
        -mabi=ilp32 \
        -o $ELF_FILE \
        $ASM_FILE


    $OBJCOPY -O binary $ELF_FILE $BIN_FILE
    $OBJDUMP -d $ELF_FILE > $ELF_FILE.dump
    # hexdump -v -e '1/1 "%02x\n"' $BIN_FILE > $MEM_FILE.temp
    hexdump -v -e '1/4 "%08x\n"' $BIN_FILE > $MEM_FILE.temp
    # cat <(echo -e "13\n00\n00\n00") $MEM_FILE.temp > $MEM_FILE
    cat <(echo -e "13000000") $MEM_FILE.temp > $MEM_FILE
    rm $MEM_FILE.temp
}

for file in $(find src -type f | xargs -I % basename % .s); do
    build_file $file
done