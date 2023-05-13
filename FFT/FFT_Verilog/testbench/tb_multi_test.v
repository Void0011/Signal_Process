`timescale 1ns/1ns

`define clk_period 20

module tb_multi_test;

    reg 						clk;
	reg 						rst;
	reg 						en;

	
	/*蝶形算子两个输入*/
	reg signed 	[23:0]		b_im;
	
	/*旋转因子，扩大了2^13*/
	reg signed 	[15:0]		c_re;
	
	/*蝶形算子两个输出*/
    wire signed 	[39:0]	b_im_c_re;

    
    multi_test m_test(
                clk,
                rst,
                en,
                b_im,
                c_re,

                b_im_c_re
);

    initial clk = 1;
    always #(`clk_period/2) clk = ~clk;

    initial begin
        rst = 0;
        en  = 0;
        b_im = 'h8ffff7;
        c_re = 'd2;
        #(`clk_period*2);
        rst = 1;

        #(`clk_period*4);
        #(`clk_period/2);

        en  = 1;
        #(`clk_period*4);
        rst = 0;
        #(`clk_period*4);
        rst = 1;
        #(`clk_period*4);
        $stop;
    end

endmodule