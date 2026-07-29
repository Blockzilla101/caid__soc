.section .text.init
.global _start

_start:
    la   sp, _stack_top
    addi sp, sp, -16

.option push
.option norelax
    la gp, __global_pointer$
.option pop

    la   t0  , _bss_start
    la   t1  , _bss_end
clear_bss:
    bge  t0  , t1, done_bss
    sw   zero, 0(t0)
    addi t0  , t0, 4
    j    clear_bss
done_bss:

    call main

trap:
    j    trap
