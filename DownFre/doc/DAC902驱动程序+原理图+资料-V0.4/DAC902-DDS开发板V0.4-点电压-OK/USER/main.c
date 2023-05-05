/**********************************************************
                       ��������					 
���ܣ�����DAC902ģ�����һ����ѹ
�ӿڣ�	
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
ʱ�䣺2015/11/3
�汾��1.0
Ӳ��ƽ̨����������������
���ߣ���������
������

������������뵽�Ա��꣬�������ӽ߳�Ϊ������ ^_^
https://kvdz.taobao.com/

**********************************************************/

#include "stm32_config.h"
#include "stdio.h"
# include <DAC902.h>
#include "timer.h"

int main(void)
{
	MY_NVIC_PriorityGroup_Config(NVIC_PriorityGroup_2);	//�����жϷ���
	delay_init(72);	//��ʼ����ʱ����
	DAC902_Init();
	delay_ms(300);
	DAC902WriteData(4095);
	DAC902WriteData(0);
	while(1);
}

