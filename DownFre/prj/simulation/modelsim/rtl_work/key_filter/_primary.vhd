library verilog;
use verilog.vl_types.all;
entity key_filter is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        key_in          : in     vl_logic;
        key_flag        : out    vl_logic
    );
end key_filter;
