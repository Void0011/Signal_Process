#ifndef __DAC902_H
#define __DAC902_H	 
#include "sys.h"

#define DAC902_CLK PAout(4)
#define DAC902_PowerON() PCout(12)=0;
#define DAC902_PowerOFF() PCout(12)=1;


void DAC902_IO_Init(void);
void DAC902_Init(void);
void DAC902WriteData(u16 dat);


#endif

