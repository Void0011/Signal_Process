library verilog;
use verilog.vl_types.all;
entity key is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        key0            : in     vl_logic;
        key1            : in     vl_logic;
        key2            : in     vl_logic;
        key3            : in     vl_logic;
        key_choose      : out    vl_logic_vector(3 downto 0)
    );
end key;
