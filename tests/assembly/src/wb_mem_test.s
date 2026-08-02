    li  x1, 0x000000ff
    li  x2, 0x0000ffcc
    li  x3, 0x00ffcccc
    li  x4, 0xffcccccc


    sw  x1, 0(x0)
    nop
    lw  x5, 0(x0)

    bne x1, x5, halt

    nop
    nop


    sw  x2, 0(x0)
    lw  x6, 0(x0)

    bne x2, x6, halt

    sb  x2, 0(x0)
    lbu x6, 0(x0)

    beq x2, x6, halt

    nop
    nop

    li  t0, 0
    sw  t0, 4(zero)
    li  t0, 1
    sw  t0, 8(zero)
    li  t0, 144
    sw  t0, 12(zero)
fib:
    lw  t0, 4(zero)
    lw  t1, 8(zero)

    add t2, t1, t0
    sw  t1, 4(zero)
    sw  t2, 8(zero)

    lw  t3, 12(zero)
    bne t3, t2, fib

halt:
    jal x0, halt
