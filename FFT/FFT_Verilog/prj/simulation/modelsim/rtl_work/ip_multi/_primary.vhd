library verilog;
use verilog.vl_types.all;
entity ip_multi is
    port(
        aclr            : in     vl_logic;
        clken           : in     vl_logic;
        clock           : in     vl_logic;
        dataa           : in     vl_logic_vector(23 downto 0);
        datab           : in     vl_logic_vector(15 downto 0);
        result          : out    vl_logic_vector(39 downto 0)
    );
end ip_multi;
