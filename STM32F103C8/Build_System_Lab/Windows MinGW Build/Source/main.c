#include <stdint.h>

// Định nghĩa địa chỉ thanh ghi (Tra Reference Manual)
#define RCC_BASE        0x40021000
#define GPIOC_BASE      0x40011000

#define RCC_APB2ENR     (*(volatile uint32_t *)(RCC_BASE + 0x18))
#define GPIOC_CRH       (*(volatile uint32_t *)(GPIOC_BASE + 0x04))
#define GPIOC_ODR       (*(volatile uint32_t *)(GPIOC_BASE + 0x0C))

int main(void){
    RCC_APB2ENR |= (1 << 4);

    GPIOC_CRH &= ~(0xF << 20);
    GPIOC_CRH |= (2 << 20);

    while(1){
        GPIOC_ODR ^= (1 << 13);

        for(int i = 0; i < 100000; i++);
    }
}