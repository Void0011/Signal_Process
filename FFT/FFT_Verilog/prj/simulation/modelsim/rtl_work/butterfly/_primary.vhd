library verilog;
use verilog.vl_types.all;
entity butterfly is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        en              : in     vl_logic;
        a_re            : in     vl_logic_vector(23 downto 0);
        a_im            : in     vl_logic_vector(23 downto 0);
        b_re            : in     vl_logic_vector(23 downto 0);
        b_im            : in     vl_logic_vector(23 downto 0);
        c_re            : in     vl_logic_vector(15 downto 0);
        c_im            : in     vl_logic_vector(15 downto 0);
        outa_re         : out    vl_logic_vector(23 downto 0);
        outa_im         : out    vl_logic_vector(23 downto 0);
        outb_re         : out    vl_logic_vector(23 downto 0);
        outb_im         : out    vl_logic_vector(23 downto 0);
        butterfly_finish_flag: out    vl_logic
    );
end butterfly;
