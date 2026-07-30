    li  x1, 0x000000ff
    li  x2, 0x0000ffcc
    li  x3, 0x00ffcccc
    li  x4, 0xffcccccc


    sw  x1, 0(x0)

z:
    jal x0, z


    lw  x5, 0(x0)

    nop
    nop


    sw  x1, 0(x0)
    nop
    lw  x5, 0(x0)

    nop
    nop

    sw  x1, 0(x0)
    sw  x2, 4(x0)
    sw  x3, 8(x0)
    sw  x4, 12(x0)

    lw  x5, 0(x0)
    lw  x6, 4(x0)
    lw  x7, 8(x0)
    lw  x8, 12(x0)

    nop
    nop
    nop
    nop

    lw  x5, 0(x0)
    nop
    lw  x6, 4(x0)
    nop
    lw  x7, 8(x0)
    nop
    lw  x8, 12(x0)
    nop

halt:
    jal x0, halt
