`timescale 1ns/1ns

`define clk_period 20



module dds_tb;

    reg clk;
    reg rst;
    reg [3:0]key_in;

    wire [11:0] freq_out;
    wire ipout_vaild;
    wire dac_clk;
    


    DDS DDS1(
        .clk(clk),
        .rst(rst),
        .key_in(key_in),

        .freq_out(freq_out),
        .ipout_vaild(ipout_vaild),
        .dac_clk(dac_clk)
    );

    initial clk = 1;

    always #(`clk_period/2) clk = ~clk;

    initial begin
        rst = 0;

        #(`clk_period*2);
        rst = 1;
        #(`clk_period*2);
        key_in = 4'b1111;
        #(`clk_period*2);
        key_in = 4'b1110;
        #(`clk_period*800_010);
        key_in = 4'b1111;

        #(`clk_period*200);
        key_in = 4'b1101;
        #(`clk_period*800_010);
        key_in = 4'b1111;

        #(`clk_period*200);
        key_in = 4'b1011;
        #(`clk_period*800_010);
        key_in = 4'b1111;

        #(`clk_period*200);
        key_in = 4'b0111;
        #(`clk_period*800_010);
        key_in = 4'b1111;
        
        #(`clk_period*6400);

        $stop;
    end

    integer fout_file;
    initial begin
        fout_file=$fopen("F:/Lab_Work/Learning/DownFre/matlab/dds/fout.txt");    //打开所创建的文件
	
        if(fout_file == 0)begin 
            $display ("can not open the file!");    //创建文件失败，显示can not open the file!
            $stop;
       end
    end

    always@(posedge clk or negedge rst)begin
        if(rst)begin
            $fdisplay(fout_file,"%d",freq_out);
        end
     

    end	


endmodule
