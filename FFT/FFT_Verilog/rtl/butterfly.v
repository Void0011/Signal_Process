/*FFT蝶形运算模块
a_re + j a_im		outa_re - j outa_im ->
	    	   \    /						outa_re = 
    			\  /
			     \/
			     /\
  c_re + j c_im /  \
			   /    \
b_re + j b_im	    outb_re - j outb_im

*/


module butterfly(
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
	
	input 						clk;
	input 						rst;
	input 						en;

	
	/*蝶形算子两个输入*/
	input signed 	[23:0]		a_re,a_im;
	input signed 	[23:0]		b_re,b_im;
	
	/*旋转因子，扩大了2^13*/
	input signed 	[15:0]		c_re,c_im;
	
	/*蝶形算子两个输出*/
	output signed 	[23:0]		outa_re,outa_im;
	output signed 	[23:0]		outb_re,outb_im;

	/*当完成一次蝶形算子时发出标志信号*/
	output reg 					butterfly_finish_flag;
	
	reg 			[3:0]		en_r;
	wire signed		[39:0]		b_re_c_re,b_re_c_im,b_im_c_im,b_im_c_re;
	reg	 signed		[39:0]		a_re_mid,a_im_mid;
	reg	 signed		[39:0]		a_re_mid_n1,a_im_mid_n1;//多打一拍
	
	reg  signed		[39:0]		a_re_addend,a_im_addend;//b_re*c_re - b_im*c_im    b_im*c_re+b_re*c_im
	reg	 signed		[39:0]		outa_re_mid,outa_im_mid,outb_re_mid,outb_im_mid;
	
	/*对使能信号进行延迟一拍*/
	always @(posedge clk or negedge rst)begin
		if(!rst)begin
			en_r <= 'd0;
		end
		else begin
			en_r <= {en_r[2:0],en};
		end
	
	end
	
	/*b实部与旋转因子实部相乘*/
	ip_multi mult0(
		.aclr(!rst),
		.clken(en),
		.clock(clk),
		.dataa(b_re),
		.datab(c_re),
		.result(b_re_c_re)
	);
	
	/*b实部与旋转因子虚部相乘*/
	ip_multi mult1(
		.aclr(!rst),
		.clken(en),
		.clock(clk),
		.dataa(b_re),
		.datab(c_im),
		.result(b_re_c_im)
	);
	
	/*b虚部与旋转因子虚部相乘*/
	ip_multi mult2(
		.aclr(!rst),
		.clken(en),
		.clock(clk),
		.dataa(b_im),
		.datab(c_im),
		.result(b_im_c_im)
	);
	/*b虚部与旋转因子实部相乘*/
	ip_multi mult3(
		.aclr(!rst),
		.clken(en),
		.clock(clk),
		.dataa(b_im),
		.datab(c_re),
		.result(b_im_c_re)
	);
	
	/*固定a_re,a_im的位宽为40，便于之后的运算*/
	always @(posedge clk or negedge rst)begin
		if(!rst)begin
			a_re_mid <= 'd0;
			a_im_mid <= 'd0;
		end
		
		else if(en)begin
			a_re_mid <= {{4{a_re[23]}},a_re[22:0],13'b0};
			a_im_mid <= {{4{a_im[23]}},a_im[22:0],13'b0};
		end
		
		else begin
			a_re_mid <= a_re_mid;
			a_im_mid <= a_im_mid;
		end
	end
	
	/*完成数据a_re,a_im的寄存一拍，并且完成a_re、a_im所要加减的数值运算*/
	always @(posedge clk or negedge rst)begin
		if(!rst)begin
			a_re_addend <= 'd0;
			a_im_addend <= 'd0;
			a_re_mid_n1 <= 'd0;
			a_im_mid_n1	<= 'd0;
		end
		else if(en)begin
			a_re_mid_n1 <= a_re_mid;
			a_im_mid_n1 <= a_im_mid;//延迟打一拍的作用不会影响下面的计算吗？？？
			a_re_addend <= b_re_c_re - b_im_c_im;//之所以在这里完成减法和加法，是防止位溢出
			a_im_addend <= b_im_c_re + b_re_c_im;
		end
		else begin
			a_re_addend <= a_re_addend;
			a_im_addend <= a_im_addend;
			a_re_mid_n1 <= a_re_mid_n1;
			a_im_mid_n1	<= a_im_mid_n1;
		end
	end
	
	/*完成所要输出的a_re、b_re计算，但是注意这里是40位的运算*/
	always @(posedge clk or negedge rst)begin
		if(!rst)begin
			outa_re_mid	<= 'd0;
			outa_im_mid <= 'd0;
			outb_re_mid <= 'd0;
			outb_im_mid <= 'd0;
			butterfly_finish_flag <= 1'b0;
		end
		else if(en_r[1])begin			//使能信号依据延迟一拍的信号，等待a_re_mid_n1、a_im_mid_n1、a_re_addend、a_im_addend信号计算完毕
			outa_re_mid <= a_re_mid_n1 + a_re_addend;
			outa_im_mid <= a_im_mid_n1 + a_im_addend;
			outb_re_mid <= a_re_mid_n1 - a_re_addend;
			outb_im_mid <= a_im_mid_n1 - a_im_addend;

			butterfly_finish_flag <= 1'b1;

		end
		else begin
			outa_re_mid	<= outa_re_mid;
			outa_im_mid <= outa_im_mid;
			outb_re_mid <= outb_re_mid;
			outb_im_mid <= outb_im_mid;

			butterfly_finish_flag <= 1'b0;
		end
	end

	/*蝶形运算后的outa*/
	assign outa_re = {outa_re_mid[39],outa_re_mid[35:13]};//取最高位[39]作为符号位，并移除移位的13个0
	assign outa_im = {outa_im_mid[39],outa_im_mid[35:13]};
	
	/*蝶形运算后的outb*/
	assign outb_re = {outb_re_mid[39],outb_re_mid[35:13]};
	assign outb_im = {outb_im_mid[39],outb_im_mid[35:13]};

endmodule 

