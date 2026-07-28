#!/usr/bin/bash

mkdir -p build

TARGET_FILE_NAME=sample_one
ELF_FILE=build/$TARGET_FILE_NAME.elf
BIN_FILE=build/$TARGET_FILE_NAME.bin
MEM_FILE=build/$TARGET_FILE_NAME.mem
C_FILE=test_programs/$TARGET_FILE_NAME.c

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
    -o build/$ELF_FILE \
    libs/crt0.s \
    $C_FILE


riscv64-elf-objcopy -O binary $ELF_FILE $BIN_FILE
riscv64-elf-objdump -d $ELF_FILE
hexdump -v -e '1/1 "%02x\n"' $BIN_FILE > $MEM_FILE.temp
cat <(echo -e "13\n00\n00\n00") $MEM_FILE.temp > $MEM_FILE
rm $MEM_FILE.temp