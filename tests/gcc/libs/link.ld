OUTPUT_ARCH("riscv")
ENTRY(_start)

MEMORY
{
  IMEM (rx) : ORIGIN = 0x00000000, LENGTH = 2K
  DMEM (rw) : ORIGIN = 0x00000000, LENGTH = 2K
}

SECTIONS
{
  .text : ALIGN(4)
  {
    KEEP(*(.text.init))   /* Startup/Reset code */
    *(.text .text.*)      /* Program instructions */
    *(.rodata .rodata.*)  /* Read-only constant data */
    . = ALIGN(4);
    _etext = .;
  } > IMEM

  .data : ALIGN(4)
  {
    _data_start = .;
    *(.data .data.*)
    *(.sdata .sdata.*) 
    . = ALIGN(4);
    _edata = .;
  } > DMEM AT > IMEM

  .bss : ALIGN(4)
  {
    _bss_start = .;
    *(.bss .bss.*)
    *(.sbss .sbss.*)
    *(COMMON)
    . = ALIGN(4);
    _bss_end = .;
  } > DMEM

  PROVIDE(__global_pointer$ = _data_start + 0x800);
  _stack_top = ORIGIN(DMEM) + LENGTH(DMEM);
}
