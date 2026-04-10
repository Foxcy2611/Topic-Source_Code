#include "stm32f10x.h"
#include "stm32f10x_gpio.h"             // Keil::Device:StdPeriph Drivers:GPIO
#include "stm32f10x_rcc.h"              // Keil::Device:StdPeriph Drivers:RCC
#include "misc.h"                       // Keil::Device:StdPeriph Drivers:Framework

#define Re_State 0x99
#define Re_Pass 0x55AA

void Delay(uint32_t time);
void LED_Config(void);
void UART_App_Config(void); // UART + NVIC => NHAN TIN HIEU


int main(void)
{
	SystemInit();

	NVIC_SetVectorTable(NVIC_VectTab_FLASH, 0x4000); // --> 0x8000 4000
	__enable_irq();

	LED_Config();
  UART_App_Config();
	while (1)
	{
		GPIO_ResetBits(GPIOA, GPIO_Pin_1);       
		Delay(300); 
			
		GPIO_SetBits(GPIOA, GPIO_Pin_1); 
		Delay(300);
	}
}

void Delay(uint32_t time)
{
  for(volatile int i = 0 ; i < time ; i++)
	{
		for(volatile int j = 0 ; j < 0x2aff ; j++);
	}
}

void LED_Config(void){
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
	GPIO_InitTypeDef gp;
	gp.GPIO_Pin = GPIO_Pin_1;
	gp.GPIO_Mode = GPIO_Mode_Out_PP;
	gp.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_Init(GPIOA, &gp);
}

void UART_App_Config(void){
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA | RCC_APB2Periph_USART1 |
												 RCC_APB2Periph_AFIO, ENABLE);
	GPIO_InitTypeDef gp;
	NVIC_InitTypeDef nvic;
	USART_InitTypeDef uart;
	
	gp.GPIO_Mode = GPIO_Mode_AF_PP;
	gp.GPIO_Pin = GPIO_Pin_9;
	gp.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_Init(GPIOA, &gp);
	
	gp.GPIO_Mode = GPIO_Mode_IN_FLOATING;
	gp.GPIO_Pin = GPIO_Pin_10;
	GPIO_Init(GPIOA, &gp);
	
	uart.USART_BaudRate = 115200;
	uart.USART_HardwareFlowControl = USART_HardwareFlowControl_None;
	uart.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;
	uart.USART_Parity = USART_Parity_No;
	uart.USART_StopBits = USART_StopBits_1;
	uart.USART_WordLength = USART_WordLength_8b;
	USART_Init(USART1, &uart);
	
	USART_ITConfig(USART1, USART_IT_RXNE, ENABLE);
	
	NVIC_PriorityGroupConfig(NVIC_PriorityGroup_0);
	nvic.NVIC_IRQChannel = USART1_IRQn;
	nvic.NVIC_IRQChannelPreemptionPriority = 0;
	nvic.NVIC_IRQChannelSubPriority = 0;
	nvic.NVIC_IRQChannelCmd = ENABLE;
	NVIC_Init(&nvic);
	
	USART_Cmd(USART1, ENABLE);
}

void USART1_IRQHandler(void){
	if(USART_GetITStatus(USART1, USART_IT_RXNE) != RESET){
		uint8_t data = USART_ReceiveData(USART1);
		
		if(data == Re_State){
			RCC_APB1PeriphClockCmd(RCC_APB1Periph_PWR | RCC_APB1Periph_BKP, 
														 ENABLE);
			
			PWR_BackupAccessCmd(ENABLE);
			
			BKP_WriteBackupRegister(BKP_DR1, Re_Pass);
			
			NVIC_SystemReset();
		}
	}
}
