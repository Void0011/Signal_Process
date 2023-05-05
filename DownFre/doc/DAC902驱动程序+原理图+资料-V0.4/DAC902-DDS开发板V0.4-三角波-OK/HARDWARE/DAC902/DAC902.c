
# include <DAC902.h>
# include <stdio.h>


void DAC902_IO_Init(void)
{
   GPIO_InitTypeDef GPIO_InitStructure ; 
	
	 RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA|RCC_APB2Periph_GPIOC, ENABLE);	 //使能PB,PE端口时钟

	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0| GPIO_Pin_1| GPIO_Pin_2| GPIO_Pin_3| GPIO_Pin_4| GPIO_Pin_5| GPIO_Pin_6| GPIO_Pin_7| GPIO_Pin_8| GPIO_Pin_9| GPIO_Pin_10| GPIO_Pin_11| GPIO_Pin_12 ; 
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOC ,&GPIO_InitStructure) ;
	
	GPIO_InitStructure.GPIO_Pin =  GPIO_Pin_4; 
	GPIO_Init(GPIOA ,&GPIO_InitStructure) ;

}
/*
void DAC902WhiteData(u16 dat)
{
	u16 io;
	DAC902_CLK = 1;
	io = GPIO_ReadOutputData(GPIOC);
	io &= 0xf000;
	io = ((dat&0x0fff)|io);
	GPIO_Write(GPIOC, io);
	DAC902_CLK = 0;
}
*/
void DAC902WriteData(u16 dat)
{
	u16 io;
	
	io = GPIO_ReadOutputData(GPIOC);
	io &= 0xf000;
	io = ((dat&0x0fff)|io);
	GPIO_Write(GPIOC, io);
	DAC902_CLK = 1;

	DAC902_CLK = 0;
}
void DAC902_Init(void)
{
	DAC902_IO_Init();
	DAC902_CLK = 0;
	DAC902_PowerON();
	DAC902WriteData(4094);
	DAC902WriteData(4094);
}



