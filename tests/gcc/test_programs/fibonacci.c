int main()
{
    volatile int f0 = 0;
    volatile int f1 = 1;
    while (f1 != 144)
    {
        int fn = f0 + f1;
        f0 = f1;
        f1 = fn;
    }

    __asm__("addi x0, x0, 0");
    __asm__("addi x0, x0, 0");
    __asm__("addi x0, x0, 0");
    __asm__("addi x0, x0, 0");
    __asm__("addi x0, x0, 0");
    __asm__("addi x0, x0, 0");
    __asm__("addi x0, x0, 0");
    __asm__("addi x0, x0, 0");
    __asm__("addi x0, x0, 0");
    __asm__("addi x0, x0, 0");
    __asm__("addi x0, x0, 0");
    __asm__("addi x0, x0, 0");
}