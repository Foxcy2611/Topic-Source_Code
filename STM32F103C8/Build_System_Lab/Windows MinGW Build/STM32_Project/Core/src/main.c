#include "stm32f10x.h"

void Blink_Led(void);
void Delay(uint16_t ms);
void Setup(void);

void Setup(void){
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
	
	GPIO_InitTypeDef gp;
	gp.GPIO_Mode = GPIO_Mode_Out_PP;
	gp.GPIO_Pin = GPIO_Pin_5;
	gp.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_Init(GPIOA, &gp);
}

void Delay(uint16_t ms){
	for(int i = 0 ; i < ms ; i++){
		for(int j = 0 ; j < 0x2aff ; j++);
	}
}

void Blink_Led(void){
	GPIO_SetBits(GPIOA, GPIO_Pin_5);
	Delay(500);
	GPIO_ResetBits(GPIOA, GPIO_Pin_5);
	Delay(500);
}

int main(){
	Setup();
	
	while(1){
		Blink_Led();
	}
}
