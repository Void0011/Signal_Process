`define FTW 32'h7AE_147A

module DDS (
    clk,
    rst,
    key_in,

    freq_out,
    ipout_vaild,
    dac_clk
);

    input               clk;
    input               rst;
    input       [3:0]   key_in;

    output  reg [11:0]  freq_out;
    output              ipout_vaild;

    output              dac_clk;    

    reg         [31:0]  sum;
    parameter           ftw = `FTW;//频率控制字，Fout=FTW*Fclk/2^N.N 为相位累加器的位宽
    wire        [11:0]  freq_out_ip_r;
    wire        [11:0]  freq_out_ip;
    wire        [11:0]  freq_out_rom;
    assign dac_clk = clk;

    wire         [3:0]   key_choose;

    key key0(
            .clk(clk),
            .rst(rst),
            .key0(key_in[0]),
            .key1(key_in[1]),
            .key2(key_in[2]),
            .key3(key_in[3]),

            .key_choose(key_choose)
        );

    dds_rom rom1(   
                    .aclr(!rst),
                    .address(sum[31:26]),
                    .clock(clk),
                    .q(freq_out_rom)
                    );
    NCO_NEW ip1(
                    .phi_inc_i(`FTW+1'b1),
                    .clk(clk),
                    .reset_n(rst),
                    .clken(1'b1),
                    .fsin_o(freq_out_ip_r),
                    .out_valid(ipout_vaild)
                    );
    //ip核输出的是有符号数
    assign freq_out_ip=(freq_out_ip_r[11] == 1'b0)?((freq_out_ip_r)+11'd2047):
                                                    (11'd2047-{1'b0,(~freq_out_ip_r[10:0]+1'b1)});

    always@(posedge clk or negedge rst)begin
        if(!rst)begin
            sum      <= 32'd0;
        end

        else begin
            sum      <= sum + ftw;
        end

    end

    /*
    按下正点原子V1开发板上的
        key0,freq会输出采用ROM查找表生成的波形；
        key1,freq会输出NCO核生成的波形；
        key2,freq会输出DAC满量程时的值；
        key3,freq会输出DAC空量程时的值；
        不按任何按键，会输出中间值。
    */
     always@(posedge clk or negedge rst)begin
        if(!rst)begin
            freq_out    <= 'd0;
        end

        else begin
            case(key_choose)
                4'b0001:begin
                    freq_out    <= freq_out_rom;
                end
                4'b0010:begin
                    freq_out    <= freq_out_ip;
                end
                4'b0100:begin
                    freq_out    <= 12'd4095;//观测满量程
                end
                4'b1000:begin
                    freq_out    <= 12'd0;//观测空值
                end
                default:begin
                    freq_out    <= 12'b0100_0000_0000;//观测中间值
                end
            endcase
        end
     end

    
    
endmodule

