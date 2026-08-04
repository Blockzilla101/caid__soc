#include <stdint.h>
#define DMEM_BASE ((volatile uint32_t *)0x0004)
#define GPIO_BASE ((volatile uint16_t *)0x1000)

void sleep(int cycles)
{
    for (int i = 0; i < cycles; i++)
    {
        __asm__("nop");
    }
}

int main()
{
    while (1)
    {
        *GPIO_BASE = 0xf0;
        sleep(2500000);
        *GPIO_BASE = 0xf1;
        sleep(2500000);
    }
}