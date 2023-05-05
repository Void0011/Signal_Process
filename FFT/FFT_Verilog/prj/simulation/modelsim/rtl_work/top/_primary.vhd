library verilog;
use verilog.vl_types.all;
entity top is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        initial_en      : in     vl_logic;
        datain_re       : in     vl_logic_vector(23 downto 0);
        datain_im       : in     vl_logic_vector(23 downto 0);
        read_addr       : in     vl_logic_vector(2 downto 0);
        dataout_re      : out    vl_logic_vector(23 downto 0);
        dataout_im      : out    vl_logic_vector(23 downto 0);
        flag_fftfinish  : out    vl_logic
    );
end top;
