module  top(
    clk,
    rst,
    initial_en,

    datain_re,//初试化数据输入端口
    datain_im,

    read_addr,//等计算完毕之后，如果要取出数据，该数据地址位
    dataout_re,
    dataout_im,
    fft_finish
   
    );

    input 							clk;
	input							rst;
	input 							initial_en;//初始化使能信号

	input 		signed	[23:0]		datain_re;//初试化RAM数据的虚实部
	input 		signed	[23:0]		datain_im;
    input               [2:0]       read_addr;

    output 		signed	[23:0]		dataout_re;//读出RAM数据的虚实部
	output 		signed	[23:0]		dataout_im;
    output                          fft_finish;

    wire                            initial_flag_r;
    wire                            wd_finish_r;
    wire                            en_multi_r;
    wire                            butterfly_finish_flag_r;
    wire                            wr_en_r,rd_en_r;
    wire                [2:0]       wr_add1_r,wr_add2_r,rd_add1_r,rd_add2_r;

    wire signed         [15:0]      factor_re_r,factor_im_r;
    wire signed         [23:0]      datain_re1_r,datain_im1_r,datain_re2_r,datain_im2_r;
    wire signed         [23:0]      dataout_re1_r,dataout_im1_r,dataout_re2_r,dataout_im2_r;
    ram_contral 
        #(
            .N(8),
            .L_max(3)
        )
        ctrl(
            .clk(clk),
            .rst(rst),
            .initial_flag(initial_flag_r),
            
            .wr_en(wr_en_r),
            .wr_add1(wr_add1_r),
            .wr_add2(wr_add2_r),

            .rd_en(rd_en_r),
            .rd_add1(rd_add1_r),
            .rd_add2(rd_add2_r),
            
            .factor_re(factor_re_r),
            .factor_im(factor_im_r),
            .en_multi(en_multi_r),
            .wd_finish(wd_finish_r),
            .fft_finish(fft_finish)
        );

    A_RAM   ram1(
		    .clk(clk),
            .rst(rst),
		    .initial_en(initial_en),
		    .datain_re(datain_re),
		    .datain_im(datain_im),

		    .wr_en(wr_en_r),
            .wd_finish(wd_finish_r),
            .wr_add1(wr_add1_r),
            .wr_add2(wr_add2_r),

		    .datain_re1(datain_re1_r),
		    .datain_im1(datain_im1_r),
		    .datain_re2(datain_re2_r),
		    .datain_im2(datain_im2_r),

		    .rd_en(rd_en_r),
            .rd_add1(rd_add1_r),
            .rd_add2(rd_add2_r),

		    .dataout_re1(dataout_re1_r),
		    .dataout_im1(dataout_im1_r),
		    .dataout_re2(dataout_re2_r),
		    .dataout_im2(dataout_im2_r),
		    .initial_flag(initial_flag_r),
            .read_addr(read_addr),
		    .dataout_re(dataout_re),
		    .dataout_im(dataout_im)
	);

    butterfly butterfly1(
            .clk(clk),
            .rst(rst),
            .en(en_multi_r),
            
            .a_re(dataout_re1_r),//a与b序号相差2^L-1，也就是在地址相差2^(L-1).b_add = a_add + 2^(L-1);
            .a_im(dataout_im1_r),
            
            .b_re(dataout_re2_r),
            .b_im(dataout_im2_r),
            
            .c_re(factor_re_r),
            .c_im(factor_im_r),
            
            .outa_re(datain_re1_r),
            .outa_im(datain_im1_r),
            
            .outb_re(datain_re2_r),
            .outb_im(datain_im2_r)
	);    




endmodule