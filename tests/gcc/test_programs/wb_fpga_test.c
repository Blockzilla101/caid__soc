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
    uint8_t value = 0b1;
    uint8_t reverse = 0;
    while (1)
    {
        if (value == 0b0 || value == 0b100000 || value == 0b1)
        {
            reverse = !reverse;
            value = reverse ? 0b010000 : 0b10;
        }
        else
        {
            value = reverse ? value >> 1 : value << 1;
        }
        *GPIO_BASE = ~value;
        sleep(2500000);
    }
}