#include <stdint.h>
#define DMEM_BASE ((volatile uint32_t *)0x4)

int main()
{
    for (int i = 0; i < 32; i++)
    {
        DMEM_BASE[i] = i;
    }
}