module A_RAM
#(
    parameter N     = 512,
    parameter L_max = 9
)
(
		clk,
		rst,
		initial_en,
		datain_re,
		datain_im,

		wr_en,
		wd_finish,
		wr_add1,
		wr_add2,
		
		datain_re1,
		datain_im1,
		datain_re2,
		datain_im2,

		rd_en,
		rd_add1,
		rd_add2,
		
		dataout_re1,
		dataout_im1,
		dataout_re2,
		dataout_im2,

		initial_flag,

		read_addr,
		dataout_re,
		dataout_im
	);

	input 							clk;
	input							rst;
	
	/*RAM初始化使能信号，也就是数据传输进来的标志*/
	input 							initial_en;

	/*初试化写入RAM数据的实、虚部*/
	input 		signed	[23:0]		datain_re,datain_im;

	/*RAM写使能信号，当蝶形算子计算一次后，将结果写入RAM对应地址*/
	input 							wr_en;

	/*RAM写完成信号，由RAM_Ctrl控制*/
	input							wd_finish;

	/*写地址:outa对应的地址位wr_add1;outb对应的地址位wr_add2*/
	input 				[L_max-1:0] wr_add1,wr_add2;

	/*outa对应的虚实部*/
	input 		signed	[23:0]		datain_re1,datain_im1;

	/*outa对应的虚实部*/
	input 		signed	[23:0]		datain_re2,datain_im2;

	/*RAM读使能信号。当蝶形算子计算一次完成后，立马发出读使能信号，读出两位数据*/
	input 							rd_en;
	input 				[L_max-1:0] rd_add1;//读地址信号1，要读出的a对应的地址位
	input 				[L_max-1:0] rd_add2;//读地址信号2，要读出的b对应的地址位
	input 				[L_max-1:0]	read_addr;//读地址信号，等待一次FFT计算完毕后，若要取出数据，要读出的地址位

	output 	reg	signed	[23:0]		dataout_re1;//读出数据a的虚实部
	output 	reg	signed	[23:0]		dataout_im1;
	output 	reg	signed	[23:0]		dataout_re2;//读出数据b的虚实部
	output 	reg	signed	[23:0]		dataout_im2;

	output 	reg	signed	[23:0]		dataout_re;//FFT结束后，要读出数据的虚、实部
	output 	reg	signed	[23:0]		dataout_im;

	output	reg  					initial_flag;//初始化完成标志

	
	
	
	/*数据存储数组,高24位存储实部，低24位存储虚部*/
    reg 				[47:0]		A_origin[N-1:0];

	/*存储进RAM中的数据index*/
	reg 				[L_max:0]	A_index;

	

	integer 						i;//循环RAM使用的整数
	
	/*初试化RAM状态机参数*/
	reg 				[2:0] 		initial_state;
	localparam 						wait_wirte_ok	= 3'b000,
									wait_initial 	= 3'b001,
									convert			= 3'b010,
									convert_finish	= 3'b100;

	/*初试化A_index状态机参数*/
	reg					[1:0]		A_index_add;
	localparam 						A_wait_initial	= 2'b01,
									index_add	 	= 2'b10;
	/*延迟一拍initial_en，提供给A_index判断开始。目的是为保持A_index与输入数据一致*/
	reg								initial_en_r;

	wire				[L_max:0]	A_index_convert;
	/*clk_rd*/
	wire							clk_rd			= ~clk;

	/*进行A_index的累加，并且A_index自增同步于clk时钟*/
	always @(posedge clk or negedge rst)begin
		if(!rst)begin
			initial_en_r			<= 'd0;
		end
		else begin
			initial_en_r			<= initial_en;
		end		
	end

	always @(posedge clk or negedge rst)begin
		if(!rst)begin
			A_index 			    <= 'd0;
			A_index_add				<= A_wait_initial;
		end
		else begin
			case(A_index_add)
				A_wait_initial:begin
					if(initial_en_r)begin
						A_index_add				<= index_add;
					end
					else begin
						A_index_add				<= A_wait_initial;
					end
				end

				A_index_add:begin
					if(A_index == N)begin
						A_index 			    <= 'd0;
						A_index_add				<= A_wait_initial;
					end
					else begin
						A_index 				<= A_index + 1'd1;
						A_index_add				<= index_add;
					end
				end
			endcase
		end
	end

	/*A_index码元倒置序号*/
	assign A_index_convert 		= {A_index[0],A_index[1],A_index[2],A_index[3],A_index[4],A_index[5],A_index[6],A_index[7],A_index[8]};

	/*初试化A_RAM，数据输入与clk保持同步。数据写入A_RAM中的操作与clk_rd保持同步。*/
	always @(posedge clk_rd or negedge rst)begin
		if(!rst)begin
			for(i=0;i<N;i=i+1)begin
				A_origin[i] 	 	<= 'd0;
			end		
			initial_flag			<= 'b0;
			initial_state			<= wait_initial;
		end
		
		else begin
			i =0;
			case(initial_state)
				wait_wirte_ok:begin
					/*等待上一次FFT计算后的数据写入RAM完成后，再进行初试化*/
					if(wd_finish)begin
						initial_state				<= wait_initial;
					end
					else begin
						initial_state				<= wait_wirte_ok;
					end
				end
				wait_initial:begin
					/*等待初试化使能打开，初试化使能与clk同步，且初试化使能后一个cycle，开始传输数据*/
					if(initial_en == 1'b1)begin
						initial_state				<= convert;
					end

					else begin
						initial_state 		        <= wait_initial;
					end
				end

				convert:begin
					if(A_index == N)begin
							initial_state 		    <= convert_finish;
							initial_flag 	        <= 1'b1;
						end
					else begin
							A_origin[A_index_convert][47:24] 	<= datain_re;
							A_origin[A_index_convert][23: 0] 	<= datain_im;
							initial_state 		    <= convert;
					end
				end

				convert_finish:begin
					initial_flag					<= 1'b0;
					initial_state 		        	<= wait_wirte_ok;
				end
			endcase

			/*防止多驱动A_origin，在这里向RAM写入数据*/
			if(wr_en)begin
				A_origin[wr_add1][47:24]			<=	datain_re1;
				A_origin[wr_add1][23:0]				<=	datain_im1;
				A_origin[wr_add2][47:24]			<=	datain_re2;
				A_origin[wr_add2][23:0]				<=	datain_im2; 
			end

		end
	end

	/*按照clk_rd来读出数据A、B*/
	always @(posedge clk_rd or negedge rst) begin
		if(!rst)begin
			dataout_re1		<= 'd0;
			dataout_im1		<= 'd0;
			dataout_re2		<= 'd0;
			dataout_im2		<= 'd0;
			dataout_re		<= 'd0;
			dataout_im		<= 'd0;
			
		end

		else if(rd_en)begin
			dataout_re1		<= A_origin[rd_add1][47:24];
			dataout_im1 	<= A_origin[rd_add1][23:0];
			dataout_re2		<= A_origin[rd_add2][47:24];
			dataout_im2 	<= A_origin[rd_add2][23:0];
			dataout_re		<= A_origin[read_addr][47:24];
			dataout_im	 	<= A_origin[read_addr][23:0];
		end

		else begin
			dataout_re1		<= 'd0;
			dataout_im1		<= 'd0;
			dataout_re2		<= 'd0;
			dataout_im2		<= 'd0;
		end			
	end

	
	
	
endmodule 