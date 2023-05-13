module ram_contral
#(
    parameter N     = 8,
    parameter L_max = 3
)
(
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
    wd_finish,
    fft_finish
);

    input                       clk;
    input                       rst;

    /*RAM初试化完毕标志，可以进行数据的运算*/
    input                       initial_flag;
    
   
    /*当butterfly结束后，向RAM中写入的数据流时序*/
    output reg                  wr_en;
    output reg          [2:0]   wr_add1;
    output reg          [2:0]   wr_add2;

    /*控制RAM向butterfly中输入的数据流时序*/
    output reg                  rd_en;
    output reg          [2:0]   rd_add1;
    output reg          [2:0]   rd_add2;

    /*
    当RAM中收到读地址后的一个cycle，会输出A、B值。
    此时蝶形算子也应随之延迟一个读时钟cylce
    */
    output reg  signed  [15:0]  factor_re,factor_im;
    output reg                  en_multi;

    /*当一次完整的FFT结束后,并且RAM全部写入完毕后发出该指令*/
    output reg                  wd_finish;
    output                      fft_finish;

    localparam                  wait_RAM_initial    = 3'b001,
                                read_addr           = 3'b010,
                                read_finish          = 3'b100
                                ;
    reg                 [2:0]   state;

    /*旋转因子中间值*/
    reg  signed  [15:0]  factor_re_r,factor_im_r;

    /*FFT蝶形运算级数*/
    reg                 [3:0]      L;
    /*FFT蝶形算子Index*/
    reg                 [9:0]      J;
    /*FFT蝶形运算两输入地址Index*/
    reg                 [9:0]      K;

    /*用来给K赋初值判断使用*/
    reg                 [1:0]      SameJ_cnt;

    /*用来延迟wr_en、wr_add1、wr_add2、rdaddr_finish*/
    reg                  rd_en_r1,rd_en_r2;
    reg          [2:0]   rd_add1_r1,rd_add1_r2;
    reg          [2:0]   rd_add2_r1,rd_add2_r2;
    reg                  read_addr_finish,read_addr_finish_r1,read_addr_finish_r2;

    /*控制读使能的延迟数寄存器*/
    reg          [1:0]  rd_delay_cnt;

    wire                 fft_finish = wd_finish;

    reg signed          [31:0] factor_rom[255:0];
    /*注意使用反斜杠,起始地址为0*/
    initial begin
        $readmemh("F:/Lab_Work/1_Learning/4_Signal_Processing_Code/Signal_Process/FFT/factor.txt",factor_rom);
    end
    /*
    计算最后一级L_Max中K所取到的Max：K_Max;
    计算L级中每J层的最大K值：J_K_Max
    */
    wire         [9:0]  N_Sub       =   N-1;
    wire         [9:0]  K_Max_Sub   =   {9'd0,1'b1}<<L-1;
    wire         [9:0]  K_Max       =   N_Sub -  K_Max_Sub;

    wire         [9:0]  J_K_Max_Sub =   {9'd0,1'b1}<<L;
    wire         [9:0]  J_K_Max_Add =   N - J_K_Max_Sub;
    wire         [9:0]  J_K_Max     =   J_K_Max_Add + J;

    wire                clk_rd      =   ~clk;

    /*计算旋转因子的Index*/
    wire         [9:0] factor_index = J << (L_max - L);  

always @(posedge clk or negedge rst) begin
    if(!rst)begin
        rd_en                   <= 'b0;
        rd_add1                 <= 'd0;
        rd_add2                 <= 'd0;

        state                   <= wait_RAM_initial;
        L                       <= 'd0;
        J                       <= 'd0;
        K                       <= 'd0;

        SameJ_cnt               <= 'd0;
        read_addr_finish        <= 1'b0;

        factor_re_r             <= 'd0;
        factor_im_r             <= 'd0;
        rd_delay_cnt            <= 'd0;
    end

    /*
        第一层大循环肯定是对不同L级蝶形运算遍历，若固定L级蝶形运算；
		第二层循环为旋转因子的遍历，J值确定，旋转因子确定。
        以J为序号进行顺序遍历，J=0：2^(L-1)-1。进而得到不同J下的旋转因子。旋转因子同样也采取地址取出。
		第三层循环为a地址的遍历(固定一个地址即可，b_add = a_add + 2 ^(L-1))，遍历初始值为J+1
        循环的最后一个J值中最后一个K值为N-1-2^(L-1)
        L=1:m
            J=0:2^(L-1)-1
                factor_re_r <= rom[(2^(L_max-L))*J]
                factor_re_m <= rom[(2^(L_max-L))*J]
                    k=J:2^L:N
                        rd_add1 = k;
                        rd_add2 = k+2^(L-1);
	*/
    else begin
        case(state)
            wait_RAM_initial:
                begin
                    if(initial_flag)begin
                        state   <= read_addr;
                    end
                    else begin
                        rd_en                   <= 'b0;
                        rd_add1                 <= 'd0;
                        rd_add2                 <= 'd0;
                        

                        state                   <= wait_RAM_initial;
                        L                       <= 1;
                        J                       <= 0;
                        K                       <= 0;

                        SameJ_cnt               <= 'd0;
                        read_addr_finish        <= 1'b0;
                        rd_delay_cnt            <= 'd0;
                    end
                end
            read_addr:
                begin
                    /*Finish read_addr*/
                    if((L == L_max) && (K == K_Max))begin
                        /*
                        在这里的rd_en、rd_add1、2之所以不是0，
                        是为防止在完成最后一级最后一个蝶形算子时，
                        地址直接丢失，无法输出最后一个地址。
                        旋转因子同理。
                        */
                        rd_en                   <= 'b1;
                        rd_add1                 <= K;
                        rd_add2                 <= K+({9'd0,1'b1}<<(L-1));
                        factor_re_r             <= factor_rom[factor_index][31:16];
                        factor_im_r             <= factor_rom[factor_index][15:0];
                        
                        state                   <= read_finish;

                        L                       <= 0;
                        J                       <= 0;
                        K                       <= 0;

                        read_addr_finish          <= 1'b0;
                    end

                    else begin
                        /*在第L级，如果J自增到2^(L-1)-1，且K也到了最后一个值时，切换到L+1级*/
                        if( ( J == ({9'd0,1'b1}<<(L-1)-1) ) &&
                            ((K == K_Max))
                            )begin
                                /*归零J、K*/
                                    rd_add1         <= K;
                                    rd_add2         <= K+({9'd0,1'b1}<<(L-1));
                                 /*
                                在这里的rd_add1、2之所以不是0，是为防止在完成切换到下一级时，
                                地址直接丢失，无法输出上一级最后一个地址。
                                这里的rd_en延迟，是为了保证RAM在写完L级，才能读L+1级
                                */

                                /*rd_en延迟3个Cycle之后，切换到下一级，此时rd_en不要给高，否则会超前一个Cycle.*/
                                if(rd_delay_cnt == 'd3)begin
                                    rd_en           <= 0;
                                    L               <= L+1;
                                    J               <= 0;
                                    K               <= 0;
                                    rd_delay_cnt    <= 'd0;                                   
                                end
                                /*保证每一级的最后一个地址可以成功读到*/
                                else if(rd_delay_cnt == 'd0) begin
                                    rd_en           <= 1;
                                    L               <= L;
                                    J               <= J;
                                    K               <= K;
                                    rd_delay_cnt    <= rd_delay_cnt+1;
                                end

                                else begin
                                    rd_en           <= 0;
                                    L               <= L;
                                    J               <= J;
                                    K               <= K;
                                    rd_delay_cnt    <= rd_delay_cnt+1;
                                end


                                
                        end


                        /*继续在第L级运算*/
                        else begin
                            
                            /*每级中共有J个不同的旋转因子*/
                            factor_re_r             <= factor_rom[factor_index][31:16];
                            factor_im_r             <= factor_rom[factor_index][15:0];
                            
                            /*J从0层开始，依据K值判断是否切换下一层*/
                            if(SameJ_cnt == 1)begin
                                SameJ_cnt       <= 'd1;
                                /*此时的K是从初值0开始，一直遍历完J层*/
                                rd_en           <= 1;
                                rd_add1         <= K;
                                rd_add2         <= K+({9'd0,1'b1}<<(L-1));


                                /*当检测到第J层的K自增值已为当前J层最大时，切换到J+1层*/
                                if(K ==  J_K_Max )begin
                                    K               <= J+1;
                                    J               <= J+1;
                                end
                                /*如果K值没有超过限制，保持在第J层*/
                                else begin
                                    K               <= K+({15'd0,1'b1}<<L);
                                    J               <= J;
                                end
                            end

                            /*在J=0层时，对K赋初值*/
                            else begin
                                J               <= 'd0;
                                K               <= 'd0;
                                SameJ_cnt       <= SameJ_cnt + 1;
                                rd_en           <= 'b0;
                            end                  
                        end
                    end
                end

            read_finish:
            begin
                state                   <= wait_RAM_initial;
                read_addr_finish        <= 1'b1;

                rd_en                   <= 'b0;
                rd_add1                 <= 'd0;
                rd_add2                 <= 'd0;

                factor_re_r             <= 'd0;
                factor_im_r             <= 'd0;
            end

            default:
            begin
                rd_en                   <= 'b0;
                rd_add1                 <= 'd0;
                rd_add2                 <= 'd0;

                state                   <= wait_RAM_initial;
                L                       <= 1;
                J                       <= 0;
                K                       <= 0;

                read_addr_finish          <= 1'b0;
            end
        endcase
    end

    
end

/*之所以延迟三拍clk cycle读信号，是因为其中要进行读写操作*/
/*延迟一拍读信号*/
always @(posedge clk or negedge rst) begin
    if(!rst)begin
        rd_en_r1                <= 'd0;
        rd_add1_r1              <= 'd0;
        rd_add2_r1              <= 'd0;
        read_addr_finish_r1       <= 'd0;
    end
    else begin
        rd_en_r1                <= rd_en;
        rd_add1_r1              <= rd_add1;
        rd_add2_r1              <= rd_add2;
        read_addr_finish_r1       <= read_addr_finish;
    end
end
/*延迟两拍读信号*/
always @(posedge clk or negedge rst) begin
    if(!rst)begin
        rd_en_r2                <= 'd0;
        rd_add1_r2              <= 'd0;
        rd_add2_r2              <= 'd0;
        read_addr_finish_r2       <= 'd0;
    end
    else begin
        rd_en_r2                <= rd_en_r1;
        rd_add1_r2              <= rd_add1_r1;
        rd_add2_r2              <= rd_add2_r1;
        read_addr_finish_r2       <= read_addr_finish_r1;
    end
end
/*延迟的第三拍读信号->写信号*/
always @(posedge clk or negedge rst) begin
    if(!rst)begin
        wr_en                   <= 'b0;
        wr_add1                 <= 'd0;
        wr_add2                 <= 'd0;
        wd_finish               <= 'd0;
    end
    else begin
        wr_en                   <= rd_en_r2;
        wr_add1                 <= rd_add1_r2;
        wr_add2                 <= rd_add2_r2;
        wd_finish               <= read_addr_finish_r2;
    end
end

/*按照clk_rd时钟输出旋转因子，为了是将B、C保持同步.蝶形算子en信号也要保持同步*/
always @(posedge clk_rd or negedge rst) begin
    if(!rst)begin
        factor_re               <= 'd0;
        factor_im               <= 'd0;
        en_multi                <= 'b0;
    end
    else begin
        factor_re               <= factor_re_r;
        factor_im               <= factor_im_r;
        en_multi                <= rd_en;
    end


end





endmodule