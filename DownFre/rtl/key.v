module key(
    clk,
    rst,
    key0,
    key1,
    key2,
    key3,

    key_choose
);

    input clk;
    input rst;
    input key0,key1,key2,key3;

    output  reg [3:0] key_choose;

    wire [3:0] key_flag_r;
    key_filter key_f0(
                        .clk(clk),
                        .rst(rst),
                        .key_in(key0),

                        .key_flag(key_flag_r[0])
                    );
    key_filter key_f1(
                        .clk(clk),
                        .rst(rst),
                        .key_in(key1),

                        .key_flag(key_flag_r[1])
                    );
    key_filter key_f2(
                        .clk(clk),
                        .rst(rst),
                        .key_in(key2),

                        .key_flag(key_flag_r[2])
                    );
    key_filter key_f3(
                        .clk(clk),
                        .rst(rst),
                        .key_in(key3),

                        .key_flag(key_flag_r[3])
                    );
   
   always@(posedge clk or negedge rst) begin
        if(!rst)begin
            key_choose <= 'b0000;
        end

        else begin
            case(key_flag_r)
                4'b0000:begin
                    key_choose <= key_choose;
                end
                4'b0001:begin
                    key_choose <= 4'b0001;
                end
                4'b0010:begin
                    key_choose <= 4'b0010;
                end
                4'b0100:begin
                    key_choose <= 4'b0100;
                end
                4'b1000:begin
                    key_choose <= 4'b1000;
                end
                default:begin
                    key_choose <= key_choose;
                end
            endcase
        end
   end


endmodule