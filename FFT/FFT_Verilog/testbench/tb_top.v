`timescale 1ns/1ns

//50Mhz时钟信号
`define clk_period 20


module tb_top;



    reg 							clk;
	reg							    rst;
	reg 							initial_en;//初始化使能信号

	reg 		signed	[23:0]		datain_re;//初试化RAM数据的虚实部
	reg 		signed	[23:0]		datain_im;
    reg                 [2:0]       read_addr;

    wire 		signed	[23:0]		dataout_re;//读出RAM数据的虚实部
	wire 		signed	[23:0]		dataout_im;
    wire                            flag_fftfinish;



    top t1(
            .clk(clk),
            .rst(rst),
            .initial_en(initial_en),

            .datain_re(datain_re),//初试化数据输入端口
            .datain_im(datain_im),

            .read_addr(read_addr),//等计算完毕之后，如果要取出数据，该数据地址位
            .dataout_re(dataout_re),
            .dataout_im(dataout_im),
            .flag_fftfinish(flag_fftfinish)
   
    );

    initial clk = 1;

    always #(`clk_period/2) clk = ~clk;

    initial begin
        rst         =   0;
        initial_en  =   0;
        datain_re   =   'd0;
        datain_im   =   'd0;
        read_addr   =   'd0;
        #(`clk_period*20);
        rst         =   1;

        #(`clk_period*20);
        initial_en  =   1;

        datain_re   =   'd1;
        datain_im   =   'd0;
        #(`clk_period);
        datain_re   =   'd4;
        datain_im   =   'd0;
        #(`clk_period);
        datain_re   =   'd5;
        datain_im   =   'd0;
        #(`clk_period);
        datain_re   =   'd6;
        datain_im   =   'd0;
        #(`clk_period);
        datain_re   =   'd7;
        datain_im   =   'd0;
        #(`clk_period);
        datain_re   =   'd8;
        datain_im   =   'd0;
        #(`clk_period);
        datain_re   =   'd9;
        datain_im   =   'd0;
        #(`clk_period);
        datain_re   =   'd10;
        datain_im   =   'd0;
        #(`clk_period*200);
        $stop;
        

    end 




endmodule