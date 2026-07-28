int main()
{
    volatile int f0 = 0;
    volatile int f1 = 1;
    for (int i = 0; i < 50; i++)
    {
        int fn = f0 + f1;
        f0 = f1;
        f1 = fn;
    }
}