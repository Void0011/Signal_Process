module ShuM (
    clk,
    rst,
    //freq_data,
    
    sel,
    seg_led
);

    input           clk;
    input           rst;
    //input   [11:0]  freq_data;//由于该数据每一个cycle变化一次，变化速度太快了，数码管不可能完整读出该数据的。
    /*
    比如第一个数码管显示的是数据1的第0位，第二个数码管很可能显示的就是数据2的第1位，而不是数据1的第1位。
    这是因为数码管显示之间存在间歇
    */

    output  reg [3:0]   sel;
    output  reg [7:0]   seg_led;

    reg     [1:0]   count;
    reg     [17:0]  cunt;

    always @(posedge clk or negedge rst) begin
        if(!rst)begin
            count       <= 'd0;
            cunt        <= 'd0;
        end
        else if(cunt == 'd25_0000)begin
            
            if(count == 'd3)begin
                count       <= 'd0;
            end
            else begin
                count       <= count+1;
            end
            cunt        <= 'd0;
        end 
        else begin
            cunt       <= cunt + 'd1;
        end 
    end

    always @(*) begin
        case(count)
            2'd0:begin
                sel     <= 'b1110;
                seg_led <= 'b1100_0000;//hgfe_dcba
            end
            2'd1:begin
                sel     <= 'b1101;
                seg_led <= 'b1111_1001;//hgfe_dcba
            end
            2'd2:begin
                sel     <= 'b1011;
                seg_led <= 'b1010_0100;//hgfe_dcba
            end
            2'd3:begin
                sel     <= 'b0111;
                seg_led <= 'b1011_0000;//hgfe_dcba
            end
            default: begin
                sel     <= 'b1111;
                seg_led <= 'b1100_0000;//hgfe_dcba
            end


        endcase
    end

    
endmodule