
module A_RAM(
		clk,
		rst,
		initial_en,
		datain_re,
		datain_im,

		wr_en,
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
	input 							initial_en;//初始化使能信号
	input 		signed	[23:0]		datain_re;//初试化写入RAM数据的虚、实部
	input 		signed	[23:0]		datain_im;

	input 							wr_en;//写使能信号，当蝶形算子计算完成时，将结果写入RAM对应位置。
	input 				[2:0]		wr_add1;//写地址信号1,a对应的地址位
	input 				[2:0]		wr_add2;//写地址信号2,b对应的地址位
	input 		signed	[23:0]		datain_re1;//写入a数据的虚实部
	input 		signed	[23:0]		datain_im1;
	input 		signed	[23:0]		datain_re2;//写入b数据的虚实部
	input 		signed	[23:0]		datain_im2;

	input 							rd_en;//读使能信号。当蝶形算子计算一次完成并且结果已经写入RAM时，此时发出读使能信号，读出两位数据
	input 				[2:0]		rd_add1;//读地址信号1，要读出的a对应的地址位
	input 				[2:0]		rd_add2;//读地址信号2，要读出的b对应的地址位
	input 				[2:0]		read_addr;//读地址信号，等待一次FFT计算完毕后，若要取出数据，要读出的地址位

	output 	reg	signed	[23:0]		dataout_re1;//读出数据a的虚实部
	output 	reg	signed	[23:0]		dataout_im1;
	output 	reg	signed	[23:0]		dataout_re2;//读出数据b的虚实部
	output 	reg	signed	[23:0]		dataout_im2;

	output 	reg	signed	[23:0]		dataout_re;//FFT结束后，要读出数据的虚、实部
	output 	reg	signed	[23:0]		dataout_im;

	output	reg  					initial_flag;//初始化完成标志
	

	reg 				[11:0]		cnt;

	reg 				[47:0]		A_origin[7:0];//A_origin为初始化所储存的数组，高24位存储实部，低24位存储虚部

	reg 				[47:0]		A_convert[7:0];//A_convert为码元倒置后的数组，高24位存储实部，低24位存储虚部
	integer 						i;//循环RAM使用的整数



	
	integer 						cnt_convert;
	
	reg 				[2:0] 		initial_state;
	localparam 						origin_store 	= 3'b001,
			   						convert_store 	= 3'b010,
									convert_finish	= 3'b100;
	

	/*初始化RAM放入所要求的数据;当检测到初试化使能信号有效时，开始进行初始化，包括完成码元倒置等操作初试化完成后进行码元读取与写入*/
	always @(posedge clk or negedge rst)begin
		if(!rst)begin
			cnt				<= 'd0;
			for(i=0;i<8;i=i+1)begin
				A_origin[i] 	 	<= 'd0;
				A_convert[i] 	 	<= 'd0;
			end

			
			initial_state 	<= origin_store;
			cnt_convert		<= 'd0;

			dataout_re1		<= 'd0;
			dataout_im1		<= 'd0;
			dataout_re2		<= 'd0;
			dataout_im2		<= 'd0;
			initial_flag	<= 'b0;
		end
		
		else begin
			i 				= 0;
			case (initial_state)

					/*存入原始数据*/
				origin_store:
					begin
						/*等待初始化使能initial_en的到来。并且其需要保持'数据深度'周期之后,方可将数据完全写入到数组A中*/
						if(initial_en == 1'b1)begin
							if(cnt == 'd8)begin
								cnt 			<= 'd0;
								initial_state 	<= convert_store;
							end
							
							else begin
								cnt 					<= cnt + 1'd1;
								A_origin[cnt][47:24] 	<= datain_re;
								A_origin[cnt][23: 0] 	<= datain_im;
								initial_state 			<= origin_store;
							end
						end
						else begin
							initial_state 		<= origin_store;
						end
					end
					/*对存储的数据进行倒序*/
				convert_store:
					begin
					
						for(cnt_convert = 3'd0;cnt_convert < 8; cnt_convert = cnt_convert+3'd1)begin
							A_convert[cnt_convert]	<= A_origin[{cnt_convert[0],cnt_convert[1],cnt_convert[2]}];
							if(cnt_convert == 'd7)begin
								initial_state 		<= convert_finish;
								initial_flag		<= 'b1;
							end
							else begin
								initial_state 		<= convert_store;
							end	
						end
				
						
					end
					/*倒序完成之后便可以进行数据的读出、写入*/
				convert_finish:
					begin
						/*读使能信号有效时，写使能信号无效。代表开始一次蝶形运算操作，读出对应的数据，注意与蝶形算子的时序逻辑*/
						if(rd_en)begin
							dataout_re1					<= A_convert[rd_add1][47:24];
							dataout_im1 				<= A_convert[rd_add1][23:0];
							dataout_re2					<= A_convert[rd_add2][47:24];
							dataout_im2 				<= A_convert[rd_add2][23:0];
							dataout_re					<= A_convert[read_addr][47:24];
							dataout_im	 				<= A_convert[read_addr][23:0];
						end
						
						/*写使能信号有效时，读使能信号无效。代表一次蝶形运算的结束，此时乘法器的计算结果要保持上一组的结果*/
						else if(wr_en) begin
							A_convert[wr_add1][47:24]	<=	datain_re1;
							A_convert[wr_add1][23:0]	<=	datain_im1;
							A_convert[wr_add2][47:24]	<=	datain_re2;
							A_convert[wr_add2][23:0]	<=	datain_im2; 
						end

						/*读写使能均无效的时候，此时表明在蝶形运算周期内，此时保持传递给蝶形算子的数值不变，并保证不会对A进行回写操作*/
						else begin
							dataout_re1					<= dataout_re1;
							dataout_im1					<= dataout_im1;
							dataout_re2					<= dataout_re2;
							dataout_im2					<= dataout_im2;
							A_convert[wr_add1][47:24]	<= A_convert[wr_add1][47:24];
							A_convert[wr_add1][23:0]	<= A_convert[wr_add1][23:0];
							A_convert[wr_add2][47:24]	<= A_convert[wr_add2][47:24];
							A_convert[wr_add2][23:0]	<= A_convert[wr_add2][23:0];
						end
					end
				default:
					begin
						for(i=0;i<8;i=i+1)begin
							A_origin[i] 	 	<= 'd0;
						end
						dataout_re1				<= 'd0;
						dataout_im1				<= 'd0;
						dataout_re2				<= 'd0;
						dataout_im2				<= 'd0;
						initial_state 			<= origin_store;
						cnt_convert				<= 'd0;
						initial_flag			<= 'b0;
					end
			endcase
		end
		

	end   
	
	
endmodule 