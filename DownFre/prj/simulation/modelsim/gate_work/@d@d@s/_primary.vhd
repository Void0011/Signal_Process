library verilog;
use verilog.vl_types.all;
entity DDS is
    port(
        altera_reserved_tms: in     vl_logic;
        altera_reserved_tck: in     vl_logic;
        altera_reserved_tdi: in     vl_logic;
        altera_reserved_tdo: out    vl_logic;
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        freq_out        : out    vl_logic_vector(11 downto 0);
        dac_clk         : out    vl_logic
    );
end DDS;
