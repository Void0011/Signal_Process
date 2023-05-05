#include "stm32_config.h"
#include "stdio.h"
# include <DAC902.h>
#include "timer.h"
#include "lcd.h"

#define ALL_POINT 200

u8 duty = 50; //占空比修改变量
u8 duty_buf=0;

//u32 Fre_In = 451000;//设置频率
u32 Fre_In = 1000000;//设置频率	1K Hz
//u32 Fre_In = 1000;//设置频率	1 Hz
u32 Fre_In_buf =0;

u16 down_point = 64;
u16 down_add = 4096;
u16 up_point =  0;
u16 up_add = 0;
u16 all_point=200;
u16 down_dip=0,up_dip=0;
u16 data = 0;
u8 down = 0;

void Set_Fre(u32 mfre)
{
	u16 count=0;
	TIM_Cmd(TIM4, DISABLE);  //使能TIMx	
	if(mfre > 10000)
	{
		all_point = ALL_POINT;
		count = 72000000000/(mfre*all_point);
		TIM_SetAutoreload(TIM4,count-1);
	}else
	{
		all_point = ALL_POINT*10;
		count = 72000000000/(mfre*all_point);
		TIM_SetAutoreload(TIM4,count-1);
	}
	TIM_Cmd(TIM4, ENABLE);  //使能TIMx	
}

void SetUpDownPoint(void)
{
	if(Fre_In_buf != Fre_In || duty_buf != duty)
	{
		Set_Fre(Fre_In);
		delay_ms(10);
		down_dip = 0;
		up_dip = 0;		
		up_point = 0;
		down_point = 0;		
		data = 0;
		down = 0;
		down_point=all_point*duty/100;
		up_point = all_point - down_point;
		down_add = 4096/down_point;
		up_add = down_add*down_point/up_point;
	}
	Fre_In_buf = Fre_In;
	duty_buf = duty;
}

void Triangle_Wave(void)
{
	if(data >= 0X0FFF)
		data = 0X0FFF;
	if(!down)
	{
		DAC902WriteData(data);
		down_dip++;
		if(down_dip >= down_point)
		{
			data -=up_add;
			down = 1;
			up_dip=0;
		}else data +=down_add;
	}else
	{
			DAC902WriteData(data);
			up_dip++;
			if(up_dip >= up_point)
			{
				
				data = down_add;
				down = 0;
				down_dip=0;
			}else 	data -=up_add;
	}
}

int main(void)
{
	MY_NVIC_PriorityGroup_Config(NVIC_PriorityGroup_2);	//设置中断分组
	delay_init(72);	//初始化延时函数
	DAC902_Init();
	delay_ms(300);
	initial_lcd();
	LCD_Show_CEStr(0,0,"DAC902");//黑色
	LCD_Show_CEStr(0,2,"Triangle Test");//黑色
	LCD_Refresh_Gram();
	
	TIM4_Int_Init(999,0);
	DAC902WriteData(4095);
	DAC902WriteData(0);
	while(1)
	{
		SetUpDownPoint();
	}
}

