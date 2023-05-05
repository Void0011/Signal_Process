module ram_contral
#(
    parameter N     = 8,
    parameter L_max = 3
)
(
    clk,
    rst,
    initial_flag,
    butterfly_finish_flag,
    
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

    input                       clk;
    input                       rst;
    input                       initial_flag;
    input                       butterfly_finish_flag;

    output reg                  wr_en;
    output reg          [2:0]   wr_add1;
    output reg          [2:0]   wr_add2;

    output reg                  rd_en;
    output reg          [2:0]   rd_add1;
    output reg          [2:0]   rd_add2;

    output reg  signed  [15:0]  factor_re,factor_im;
    output reg                  en_multi;
    output reg                  flag_fftfinish;

    localparam                  state_rd = 1'b0,
                                state_wr = 1'b1;
    reg                         state;

    integer                     L,J,K;

    reg signed          [31:0] factor_rom[255:0];
    initial begin
        $readmemh("F:/Lab_Work/1_Learning/4_Signal_Processing_Code/FFT/factor.txt",factor_rom);//注意使用反斜杠,起始地址为0
    end
   
always @(posedge clk or negedge rst) begin
    if(!rst)begin
        wr_en                   <= 'b0;
        wr_add1                 <= 'd0;
        wr_add2                 <= 'd0;

        rd_en                   <= 'b0;
        rd_add1                 <= 'd0;
        rd_add2                 <= 'd0;

        state                   <= state_rd;//第一次算法肯定是要读出数据
        en_multi                <= 'b0;
        flag_fftfinish          <= 1'b0;
    end

    /*
        写成循环，太浪费时钟了。。。

		第一层大循环肯定是对不同L级蝶形运算遍历，若固定L级蝶形运算；
		第二层循环为旋转因子的遍历，以J为序号进行顺序遍历，J=0：2^(L-1)-1。进而得到不同J下的旋转因子。旋转因子同样也采取地址取出。
		第三层循环为a地址的遍历(固定一个地址即可，b_add = a_add + 2 ^(L-1))，遍历初始值为J+1
        L=1:m
            J=0:2^(L-1)-1
                factor_re <= rom[(2^(L_max-L))*J]
                    k=J:2^L:N
                        rd_add1 = k;
                        rd_add2 = k+2^(L-1);
	*/
    else if(initial_flag)begin
        
        for(L=1;      L<=L_max;       L=L+1)
        begin
            for(J=0;   J<=(({15'd0,1'b1}<<(L-1))-1);   J=J+1)
            begin
                factor_re   <= factor_rom[(({7'd0,1'b1}<<(L_max-L))*J)][31:16];
                factor_im   <= factor_rom[(({7'd0,1'b1}<<(L_max-L))*J)][15:0];

                for(K=J;    K<N;     K=K+({15'd0,1'b1}<<L))
                begin
                    /*判断FFT计算是否结束*/
                    if((L==L_max)&&(K==N-1))begin
                        flag_fftfinish          <= 1'b1;//一次FFT已经结束
                    end
                    else begin
                        flag_fftfinish          <= flag_fftfinish;
                    end

                    case(state)

                        state_rd:
                            begin
                                /*给出一个周期的rd_en后拉低?还是等待计算完毕之后再拉低*/
                                rd_en           <= 1;
                                wr_en           <= 0;
                                en_multi        <= 'b1;//读出的时候，乘法器使能
                                rd_add1         <= K;
                                rd_add2         <= K+({2'd0,1'b1}<<(L-1));
                                if(butterfly_finish_flag)begin
                                    state       <= state_wr;
                                end
                                else begin
                                    state       <= state_rd;
                                end
                            end
                        state_wr:
                            begin
                                rd_en           <= 0;
                                wr_en           <= 1;
                                en_multi        <= 'b0;
                                wr_add1         <= K;
                                wr_add2         <= K+({2'd0,1'b1}<<(L-1));
                                state           <= state_rd;//下一个时钟周期进入读周期
                            end
                        default:
                            begin
                                rd_en           <= 0;
                                wr_en           <= 0;
                                en_multi        <= 'b0;
                                rd_add1         <= 'd0;
                                rd_add2         <= 'd0;
                                wr_add1         <= 'd0;
                                wr_add2         <= 'd0;
                               
                            end
                    endcase
                    
                end
            end
        end  
    end

    else begin
        wr_en                   <= 'b0;
        wr_add1                 <= 'd0;
        wr_add2                 <= 'd0;

        rd_en                   <= 'b0;
        rd_add1                 <= 'd0;
        rd_add2                 <= 'd0;

        state                   <= state_rd;
        en_multi                <= 'b0;
        flag_fftfinish          <= flag_fftfinish;
    end    
end




endmodule