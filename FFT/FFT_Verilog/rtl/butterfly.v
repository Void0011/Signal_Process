/*FFT蝶形运算模块
a_re + j a_im		outa_re + j outa_im 
	    	   \    /						
    			\  /
			     \/
			     /\
  c_re + j c_im /  \
			   /    \
b_re + j b_im	    outb_re + j outb_im

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
		outb_im
	);
	
	input 						clk;
	input 						rst;
	input 						en;

	
	/*蝶形算子两个输入a、b*/
	input signed 	[23:0]		a_re,a_im;
	input signed 	[23:0]		b_re,b_im;
	
	/*旋转因子，扩大了2^13倍*/
	input signed 	[15:0]		c_re,c_im;
	
	/*蝶形算子两个输出outa、outb*/
	output signed 	[23:0]		outa_re,outa_im;
	output signed 	[23:0]		outb_re,outb_im;

	
	
	/*使能寄存信号*/
	reg 			[3:0]		en_r;

	/*乘法器输出连接信号*/
	wire signed		[39:0]		b_re_c_re,b_re_c_im,b_im_c_im,b_im_c_re;
	
	/*输入a扩大位宽之后的信号*/
	reg	 signed		[39:0]		a_re_mid,a_im_mid;

	/*a扩大位宽后，寄存一拍信号*/
	reg	 signed		[39:0]		a_re_mid_n1,a_im_mid_n1;
	
	/*
	a_re_addend = b_re_c_re - b_im_c_im
	a_im_addend = b_im_c_re + b_re_c_im
	*/
	reg  signed		[39:0]		a_re_addend,a_im_addend;//   
	reg	 signed		[39:0]		outa_re_mid,outa_im_mid,outb_re_mid,outb_im_mid;
	
	/*对使能信号en进行延迟一拍*/
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
	
	/*固定a_re,a_im的位宽为40，便于之后的运算。使用assign可以吗？*/
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
			a_re_mid <= 'd0;
			a_im_mid <= 'd0;
		end
	end
	
	/*
	数据a_re_mid,a_im_mid寄存一拍，与a_re_addend、a_im_addend运算结果保持时钟同步。是否画蛇添足？
	并没有额外加入寄存器，因为如果不延迟一拍，可能第一个数据计算结果是对的，但是从第二个开始就错误了。
	无法完成流水线工作。
	
	*/
	always @(posedge clk or negedge rst)begin
		if(!rst)begin
			a_re_addend <= 'd0;
			a_im_addend <= 'd0;

			a_re_mid_n1 <= 'd0;
			a_im_mid_n1	<= 'd0;
		end
		else if(en_r[0])begin
			/*怎么防止加减导致位溢出？*/
			a_re_addend <= b_re_c_re - b_im_c_im;
			a_im_addend <= b_im_c_re + b_re_c_im;
			
			a_re_mid_n1 <= a_re_mid;
			a_im_mid_n1 <= a_im_mid;		
		end
		else begin
			a_re_addend <= 'd0;
			a_im_addend <= 'd0;

			a_re_mid_n1 <= 'd0;
			a_im_mid_n1	<= 'd0;
		end
	end
	
	/*完成的同步值a_re_mid_n1、a_re_mid_n1与a_re_addend、a_im_addend，进行40位的运算*/
	always @(posedge clk or negedge rst)begin
		if(!rst)begin
			outa_re_mid	<= 'd0;
			outa_im_mid <= 'd0;
			outb_re_mid <= 'd0;
			outb_im_mid <= 'd0;
			
		end
		/*a_re_mid_n1、a_im_mid_n1、a_re_addend、a_im_addend信号计算完毕时，相对en已延迟一个cycle。使用en_r[1]*/
		else if(en_r[1])begin			
			outa_re_mid <= a_re_mid_n1 + a_re_addend;
			outa_im_mid <= a_im_mid_n1 + a_im_addend;
			outb_re_mid <= a_re_mid_n1 - a_re_addend;
			outb_im_mid <= a_im_mid_n1 - a_im_addend;

		end
		else begin
			outa_re_mid	<= 'd0;
			outa_im_mid <= 'd0;
			outb_re_mid <= 'd0;
			outb_im_mid <= 'd0;

		end
	end

	/*蝶形运算后的outa,取最高位[39]作为符号位，并移除扩大移位产生的13个0*/
	assign outa_re = {outa_re_mid[39],outa_re_mid[35:13]};
	assign outa_im = {outa_im_mid[39],outa_im_mid[35:13]};
	
	/*蝶形运算后的outb*/
	assign outb_re = {outb_re_mid[39],outb_re_mid[35:13]};
	assign outb_im = {outb_im_mid[39],outb_im_mid[35:13]};

endmodule 

