`timescale 1ns/1ns

`define clk_period 20
module tb_butterfly ();

    reg 						clk;
	reg 						rst;
	reg 						en;

	
	/*蝶形算子两个输入a、b*/
	reg signed 	[23:0]		a_re,a_im;
	reg signed 	[23:0]		b_re,b_im;
	
	/*旋转因子，扩大了2^13倍*/
	reg signed 	[15:0]		c_re,c_im;
	
	/*蝶形算子两个输出outa、outb*/
	wire signed 	[23:0]		outa_re,outa_im;
	wire signed 	[23:0]		outb_re,outb_im;

	/*完成一次蝶形算子时发出结束标志信号*/
	wire     					butterfly_finish_flag;

    butterfly b1(
		clk,
		rst,
		en,
				
		a_re,//a与b序号相差2^L-1，也就是在地址相差2^(L-1).b_add = a_add + 2^(L-1);
		a_im,
		
		b_re,
		b_im,
		
		c_re,
		c_im,
		
		outa_re,
		outa_im,
		
		outb_re,
		outb_im,

		butterfly_finish_flag
	);

    initial clk = 1;
    always #(`clk_period/2) clk = ~clk;

    initial begin
        rst = 0;
        en  = 0;
        a_re = 1;
		a_im = 2;
		
		b_re = 3;
		b_im = 4;
		
		c_re = 16'd;
		c_im = 16'd40960;
        #(`clk_period*2);
        rst = 1;

        #(`clk_period*4);
        #(`clk_period/2);
        en  = 1;

        #(`clk_period*1);
        a_re = 6;
		a_im = 7;
		
		b_re = 8;
		b_im = 9;
		
		c_re =  {1'b0,15'd10 << 13};
		c_im =  {1'b0,15'd11 << 13};

        #(`clk_period*1);
        a_re = 12;
		a_im = 13;
		
		b_re = 14;
		b_im = 15;
		
		c_re = 16;
		c_im = 17;

        #(`clk_period*4);
        rst = 1;
        #(`clk_period*4);
        en = 0;
        #(`clk_period*4);
        en = 1;
        #(`clk_period*4);
        $stop;
    end
    
endmodule