/**********************************************************
                       康威电子					 
功能：利用DAC902模块产生一个电压
接口：	
				PC12	->	DAC902_PowerON
				PA04	->	DAC902_CLK
				
				PC00	->	D11
				PC01	->	D10
				PC02	->	D09
				.
				.
				.
				PC09	->	D02
				PC10	->	D01
				PC11	->	D00
时间：2015/11/3
版本：1.0
硬件平台：康威数采驱动板
作者：康威电子
其他：

更多电子需求，请到淘宝店，康威电子竭诚为您服务 ^_^
https://kvdz.taobao.com/

**********************************************************/

#include "stm32_config.h"
#include "stdio.h"
# include <DAC902.h>
#include "timer.h"

int main(void)
{
	MY_NVIC_PriorityGroup_Config(NVIC_PriorityGroup_2);	//设置中断分组
	delay_init(72);	//初始化延时函数
	DAC902_Init();
	delay_ms(300);
	DAC902WriteData(4095);
	DAC902WriteData(0);
	while(1);
}

