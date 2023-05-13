`timescale 1ns/1ns

//50Mhz时钟信号
`define clk_period 20

module tb_ram_contral;


    reg                       clk;
    reg                       rst;

    /*RAM初试化完毕标志，可以进行数据的运算*/
    reg                       initial_flag;
    
    
    /*当butterfly结束后，向RAM中写入的数据流时序*/
    wire                  wr_en;
    wire          [2:0]   wr_add1;
    wire          [2:0]   wr_add2;

    /*控制RAM向butterfly中输入的数据流时序*/
    wire                  rd_en;
    wire          [2:0]   rd_add1;
    wire          [2:0]   rd_add2;

    /*
    当RAM中收到读地址后的一个cycle，会输出A、B值。
    此时蝶形算子也应随之延迟一个读时钟cylce
    */
    wire  signed  [15:0]  factor_re,factor_im;
    wire                  en_multi;

    /*当一次完整的FFT结束后发出该指令*/
    wire                  flag_fftfinish;

    ram_contral
#(
    .N(8),
    .L_max(3)
)
r1(
    clk,
    rst,
    initial_flag,
        
    wr_en,
    wr_add1,
    wr_add2,

    rd_en,
    rd_add1,
    rd_add2,
    
    factor_re,
    factor_im,
    en_multi,
    flag_fftfinish
);

    initial clk = 1;

    always #(`clk_period/2) clk = ~clk;
    initial begin
        rst         =   0;
        initial_flag  =   0;
        #(`clk_period*20);
        rst         =   1;

        #(`clk_period/2);
        #(`clk_period*20);
        initial_flag  =   1;
        #(`clk_period);
        initial_flag  =   0;
        #(`clk_period*40);
        $stop;
    end

endmodule