library verilog;
use verilog.vl_types.all;
entity ram_contral is
    generic(
        N               : integer := 512;
        L_max           : integer := 9
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        initial_flag    : in     vl_logic;
        wr_en           : out    vl_logic;
        wr_add1         : out    vl_logic_vector;
        wr_add2         : out    vl_logic_vector;
        rd_en           : out    vl_logic;
        rd_add1         : out    vl_logic_vector;
        rd_add2         : out    vl_logic_vector;
        factor_re       : out    vl_logic_vector(15 downto 0);
        factor_im       : out    vl_logic_vector(15 downto 0);
        en_multi        : out    vl_logic;
        wd_finish       : out    vl_logic;
        fft_finish      : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of N : constant is 1;
    attribute mti_svvh_generic_type of L_max : constant is 1;
end ram_contral;
