#include "stm32f10x.h"
#include "stm32f10x_gpio.h"
#include "stm32f10x_rcc.h"
#include "stm32f10x_adc.h"
#include "stm32f10x_can.h"

void GPIO_Config(void);

volatile uint32_t adc_val = 100;

int main(void)
{
    GPIO_Config();

    while (1){
        GPIO_ResetBits(GPIOC, GPIO_Pin_13);
        for (volatile int i = 0; i < 500000; i++); 

        GPIO_SetBits(GPIOC, GPIO_Pin_13);
        for (volatile int i = 0; i < 500000; i++); 
        adc_val = 99;
    }
}

void GPIO_Config(void)
{
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE);

    GPIO_InitTypeDef GPIO_InitStructure;
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_13;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_Init(GPIOC, &GPIO_InitStructure);
}
