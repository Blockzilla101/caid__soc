#include <stdint.h>
#define DMEM_BASE ((volatile uint32_t *)0x4)
#define GPIO_BASE ((volatile uint32_t *)0x1000)

int main()
{
    for (int i = 0; i < 32; i++)
    {
        DMEM_BASE[i] = i;
    }

    for (int i = 0; i < 10; i++)
    {
        GPIO_BASE[0] = i;
    }
}