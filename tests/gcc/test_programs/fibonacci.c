#define DMEM_BASE ((volatile unsigned int *)0x4)

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

    DMEM_BASE[0] = 1;
    DMEM_BASE[1] = f1;
}