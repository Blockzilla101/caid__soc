ENTRY(_start)

MEMORY
{
    IMEM (rx)  : ORIGIN = 0x00000000, LENGTH = 2K
    DMEM  (rwx) : ORIGIN = 0x00001000, LENGTH = 2K
}

/* Explicitly tell the linker NOT to emit program headers into memory */
PHDRS
{
    none PT_NULL ;
}

SECTIONS
{
    .text :
    {   
        KEEP(*(.text.startup))
        *(.text*)
        *(.rodata*)
    } > IMEM :none

    .data :
    {
        *(.sdata*)
        *(.data*)
    } > DMEM AT > IMEM :none

    .bss :
    {
        __bss_start = .;
        *(.sbss*)
        *(.bss*)
        *(COMMON)
        __bss_end = .;
    } > DMEM :none

    . = ALIGN(4);
    _end = .;
}