OUTPUT_ARCH("riscv")
ENTRY(_start)

MEMORY
{
  IMEM (rx) : ORIGIN = 0x00000000, LENGTH = 2K
  DMEM (rw) : ORIGIN = 0x00000000, LENGTH = 2K
}

SECTIONS
{
  /* ------------------------------------------------------------------------
   * INSTRUCTION MEMORY (IMEM)
   * ------------------------------------------------------------------------ */
  .text : ALIGN(4)
  {
    KEEP(*(.text.init))   /* Startup/Reset code */
    *(.text .text.*)      /* Program instructions */
    *(.rodata .rodata.*)  /* Read-only constant data */
    . = ALIGN(4);
    _etext = .;
  } > IMEM

  /* ------------------------------------------------------------------------
   * DATA MEMORY (DMEM)
   * ------------------------------------------------------------------------ */

  /* Initialized static/global variables (.data) */
  /* Placed in DMEM, but initial values (LMA) are stored in IMEM right after .text */
  .data : ALIGN(4)
  {
    _data_start = .;
    *(.data .data.*)
    *(.sdata .sdata.*)   /* Small data section for gp-relative addressing */
    . = ALIGN(4);
    _edata = .;
  } > DMEM AT > IMEM

  /* Uninitialized static/global variables (.bss) initialized to zero */
  .bss : ALIGN(4)
  {
    _bss_start = .;
    *(.bss .bss.*)
    *(.sbss .sbss.*)
    *(COMMON)
    . = ALIGN(4);
    _bss_end = .;
  } > DMEM

  /* Set Global Pointer (gp) for RISC-V relaxed addressing optimization */
  PROVIDE(__global_pointer$ = _data_start + 0x800);

  /* Set Stack Pointer top (Stack grows DOWNWARDS from the end of 2KB DMEM) */
  _stack_top = ORIGIN(DMEM) + LENGTH(DMEM);
}