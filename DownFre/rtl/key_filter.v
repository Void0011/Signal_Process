`define interval_time 20'd800_000

module key_filter(
    clk,
    rst,
    key_in,

    key_flag
);
    input clk;
    input rst;
    input key_in;

    output reg key_flag;


    reg [19:0] cnt;
    reg [3:0]  state;
    reg key_r1,key_r2;
    reg pos_flag,neg_flag;

    reg [2:0] key_mid;
    always @(posedge clk or negedge rst) begin
        if(!rst)begin
            key_mid <= 'd0;
        end
        else begin
            key_mid ={key_mid[1:0],key_r2};
        end
    end
    
//消除亚稳态
    always @(posedge clk or negedge rst) begin
        if(!rst)begin
            key_r1      <= 'b0;
            key_r2      <= 'b0;
        end
        else begin 
            key_r1      <= key_in;
            key_r2      <= key_r1;
        end
    end
//检测边沿
    always @(posedge clk or negedge rst) begin
        if(!rst)begin
            pos_flag    <= 'b0;
            neg_flag    <= 'b0;
        end
        else if((key_mid[2])&&~(key_mid[1]))begin
            pos_flag    <= 'b0;
            neg_flag    <= 'b1;
        end
        else if((~key_mid[2])&&(key_mid[1]))begin
            pos_flag    <= 'b1;
            neg_flag    <= 'b0;
        end
        else begin
            pos_flag    <= 'b0;
            neg_flag    <= 'b0;
        end
    end

    always @(posedge clk or negedge rst) begin
        if(!rst)begin
            key_flag    <= 'b0;
            state       <= 'b0001;
            cnt         <= 'd0;
        end
        
        else begin
            case(state)
                //等待下降沿来临状态
                4'b0001:begin
                    cnt             <= 'd0;
                    key_flag        <= 1'b0;
                    if(neg_flag)begin
                        state       <= 4'b0010;
                    end
                    else begin
                        state       <= 4'b0001;
                    end
                end
                //在下降沿来临后，如果又检测到上升沿，返回上一状态。否则开始计数。
                4'b0010:begin
                    if(pos_flag)begin
                        key_flag    <= 1'b0;
                        state       <= 4'b0001;
                        cnt         <= 'd0;
                    end
                    else if(cnt == `interval_time)begin
                        key_flag    <= 1'b1;
                        state       <= 4'b0100;
                        cnt         <= 'd0;
                    end
                    else begin
                        key_flag    <= 1'b0;
                        state       <= 4'b0010;
                        cnt         <= cnt + 1'd1;
                    end 
                end
                //等待上升沿来临
                4'b0100:begin
                    key_flag        <= 1'b0;
                    cnt             <= 'd0;
                    if(pos_flag)begin
                        state       <= 4'b1000;
                    end
                    else begin
                        state       <= 4'b0100;
                    end
                end
                //上升沿来临后的滤波状态
                4'b1000:begin
                    if(neg_flag)begin
                        key_flag    <= 1'b0;
                        state       <= 4'b0100;
                        cnt         <= 'd0;
                    end
                    else if(cnt == `interval_time)begin
                        key_flag    <= 1'b1;
                        state       <= 4'b0001;
                        cnt         <= 'd0;
                    end
                    else begin
                        key_flag    <= 1'b0;
                        state       <= 4'b1000;
                        cnt         <= cnt + 1'd1;
                    end
                end

                default:begin
                        key_flag    <= 1'b0;
                        state       <= 4'b0001;
                        cnt         <= 'd0;
                end
            endcase

        end
    end

endmodule