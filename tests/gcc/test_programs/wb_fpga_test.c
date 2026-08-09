#include <stdint.h>
#define DMEM_BASE ((volatile uint32_t *)0x0004)
#define GPIO_BASE ((volatile uint8_t *)0x1000)

void sleep(int cycles)
{
    for (int i = 0; i < cycles; i++)
    {
        __asm__("nop");
    }
}

int main()
{
    int value = 0b1;
    int reverse = 0;
    while (1)
    {
        if (value == 0b0 || value == 0b1000000)
        {
            reverse = !reverse;
            value = reverse ? 0b100000 : 0x1;
        }
        else
        {
            value = reverse ? value >> 1 : value << 1;
        }
        *GPIO_BASE = value;
        sleep(2500000);
    }
}