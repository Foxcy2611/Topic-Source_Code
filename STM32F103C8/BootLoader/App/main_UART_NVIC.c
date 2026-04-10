#include "stm32f10x.h"

#define RX_BUFFER_SIZE 100

volatile uint8_t rx_buffer[RX_BUFFER_SIZE];
volatile uint8_t rx_index = 0;
volatile uint8_t rx_done = 0;

void GPIO_Config(void);
void USART1_Config(void);
void USART_SendString(USART_TypeDef* USARTx, char *str);

int main(void)
{
			NVIC_SetVectorTable(NVIC_VectTab_FLASH, 0x4000);
	__enable_irq();
    GPIO_Config();
    USART1_Config();

    USART_SendString(USART1, "UART READY\r\n");

    while (1)
    {
        if (rx_done)
        {
            // Có th? x? lý chu?i ? dây n?u mu?n
            // rx_buffer ch?a chu?i nh?n du?c

            USART_SendString(USART1, "OK\r\n");

            rx_index = 0;
            rx_done = 0;
        }
    }
}

/* ================= GPIO ================= */
void GPIO_Config(void)
{
    GPIO_InitTypeDef gpio;

    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA | RCC_APB2Periph_AFIO, ENABLE);

    /* PA9 - TX */
    gpio.GPIO_Pin = GPIO_Pin_9;
    gpio.GPIO_Mode = GPIO_Mode_AF_PP;
    gpio.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOA, &gpio);

    /* PA10 - RX */
    gpio.GPIO_Pin = GPIO_Pin_10;
    gpio.GPIO_Mode = GPIO_Mode_IN_FLOATING;
    GPIO_Init(GPIOA, &gpio);
}

/* ================= USART ================= */
void USART1_Config(void)
{
    USART_InitTypeDef usart;
    NVIC_InitTypeDef nvic;

    RCC_APB2PeriphClockCmd(RCC_APB2Periph_USART1, ENABLE);

    usart.USART_BaudRate = 115200;
    usart.USART_WordLength = USART_WordLength_8b;
    usart.USART_StopBits = USART_StopBits_1;
    usart.USART_Parity = USART_Parity_No;
    usart.USART_HardwareFlowControl = USART_HardwareFlowControl_None;
    usart.USART_Mode = USART_Mode_Tx | USART_Mode_Rx;
    USART_Init(USART1, &usart);

    /* B?t ng?t RX */
    USART_ITConfig(USART1, USART_IT_RXNE, ENABLE);

    /* NVIC */
    nvic.NVIC_IRQChannel = USART1_IRQn;
    nvic.NVIC_IRQChannelPreemptionPriority = 1;
    nvic.NVIC_IRQChannelSubPriority = 1;
    nvic.NVIC_IRQChannelCmd = ENABLE;
    NVIC_Init(&nvic);

    USART_Cmd(USART1, ENABLE);
}

/* ================= SEND STRING ================= */
void USART_SendString(USART_TypeDef* USARTx, char *str)
{
    while (*str)
    {
        while (USART_GetFlagStatus(USARTx, USART_FLAG_TXE) == RESET);
        USART_SendData(USARTx, *str++);
    }
}

/* ================= IRQ HANDLER ================= */
void USART1_IRQHandler(void)
{
    if (USART_GetITStatus(USART1, USART_IT_RXNE) != RESET)
    {
        uint8_t data = USART_ReceiveData(USART1);

        if (data == '.')
        {
            rx_buffer[rx_index] = '\0';
            rx_done = 1;
        }
        else
        {
            if (rx_index < RX_BUFFER_SIZE - 1)
            {
                rx_buffer[rx_index++] = data;
            }
        }

        USART_ClearITPendingBit(USART1, USART_IT_RXNE);
    }
}
