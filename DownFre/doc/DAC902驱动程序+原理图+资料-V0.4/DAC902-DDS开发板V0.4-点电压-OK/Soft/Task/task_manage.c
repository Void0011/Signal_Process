#include "task_manage.h"
#include "delay.h"
#include "key.h"

#define OUT_KEY  GPIO_ReadInputDataBit(GPIOA,GPIO_Pin_2)//读取按键0
#define FLASH_SAVE_ADDR  0x0801F000  				//设置FLASH 保存地址(必须为偶数)
u8 Firt_In = 1;
u8 Task_Index = 0;
u8 _return=0;
u8 Task_Delay(u32 delay_time, u8* delay_ID)
{
	static u8 Time_Get = 0;
	static u32 Time_Triger;
    if(Time_Get == 0)
    {
      Time_Triger = SysTimer + delay_time;
      Time_Get = 1;
    }
    if(SysTimer >= Time_Triger)
    { 
      Time_Get = 0;
			*delay_ID = 1;		//	后续代码已被执行一遍
			return 1;
    }
		return 0;
}

//u8 TaskOneToIdel(void)
//{
//	static u8 delay_ID0 = 0;
//	static u8 delay_ID1 = 0;
//	static u8 delay_ID2 = 0;
//	static u8 delay_ID3 = 0;
//	u8 delay_arrive0 = 0;
//	u8 delay_arrive1 = 0;
//	u8 delay_arrive2 = 0;
//	u8 delay_arrive3 = 0;
//	
//	delay_arrive0 = Task_Delay(100, &delay_ID0);
//	delay_arrive1 = Task_Delay(100, &delay_ID1);
//	delay_arrive2 = Task_Delay(100, &delay_ID2);
//	delay_arrive3 = Task_Delay(100, &delay_ID3);
//	if((delay_arrive0 == 0) && (delay_ID0 == 0))
//		return 0;
//	else if((delay_arrive0) && (delay_ID0))
//	{
//			//执行本延时后代码
//	}
//		
//	
//	
//	if(delay_ID0&&delay_ID1&&delay_ID2&&delay_ID3)
//	{
//		delay_ID0 = 0;
//		delay_ID1 = 0;
//		delay_ID2 = 0;
//		delay_ID3 = 0;
//	}
//}

u8 TaskCycleDelay(u32 delay_time, u8* Last_delay_ID, u8* Self_delay_ID)
{
	static u8 Time_Get = 0;
	static u32 Time_Triger;
	
	if(!(*Last_delay_ID))
		return 0;
	if(Time_Get == 0)
	{
		Time_Triger = SysTimer + delay_time;
		Time_Get = 1;
	}
	if(SysTimer >= Time_Triger)
	{ 
		Time_Get = 0;
		*Last_delay_ID = 0;
		*Self_delay_ID = 1;		//	后续代码已被执行一遍
		return 1;
	}
	return 0;
}


void Copybuf2dis(u8 *source, u8 dis[10], u8  dispoint)
{
	dis[0] = *source + 		 '0';
	dis[1] = *(source+1) + '0';
	dis[2] = *(source+2) + '0';
	dis[3] = '%';
	dis[4] = 0;

	if(dispoint < 3) dis[dispoint] += 128;
}

void Set_Duty(u32 Key_Value, u8* Task_ID)
{
	static u8 P_Index = 0;

	u8 duty_buf[9];
	u8 display[15];

	if(Firt_In) 
	{
		Key_Value = K_2_L;
		LCD_Clear();
//		LCD_Show_CEStr(0,0,"    输出频率    ");
		LCD_Show_CEStr(0,6,"↑   ←→     ↓");
		Firt_In = 0;
		_return=1;		
	}
	duty_buf[0] = (u8)duty%1000/100;
	duty_buf[1] = (u8)duty%100/10;
	duty_buf[2] = (u8)duty%10;
	
	switch(Key_Value)
	{
		case K_4_S: duty_buf[P_Index]++;break;
		case K_4_L: duty_buf[P_Index]++;break;
		case K_5_L: P_Index++;break;
		case K_5_S: P_Index++;break;
		case K_1_L: P_Index--;break;
		case K_1_S: P_Index--;break;
		case K_3_S: duty_buf[P_Index]--;break;
		case K_3_L: duty_buf[P_Index]--;break;
	}
	if(duty_buf[0]>1)duty_buf[0]=1;
	if(P_Index==255)P_Index=2;
	P_Index %= 3;
	if(duty_buf[P_Index] == 255) duty_buf[P_Index] = 9;
	if(duty_buf[P_Index] ==  10) duty_buf[P_Index] = 0;
	
	if(Key_Value != K_NO)
	{
		Copybuf2dis(duty_buf, display, P_Index);
		OLED_ShowString(16, 2, display);
		duty = duty_buf[0]*100 + duty_buf[1]*10+ duty_buf[2];
		if(duty >100) duty = 100;
		_return=1;
	}

}
