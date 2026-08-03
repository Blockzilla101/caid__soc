    addi x3 , x0 , 0
    addi x4 , x0 , 1
    addi x10, x0 , 144
fib:
    add  x5 , x3 , x4
    add  x3 , x0 , x4
    add  x4 , x0 , x5
    bne  x5 , x10, fib

halt:
    jal  x0 , halt
