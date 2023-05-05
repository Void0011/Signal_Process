library verilog;
use verilog.vl_types.all;
entity dds_rom is
    port(
        aclr            : in     vl_logic;
        address         : in     vl_logic_vector(5 downto 0);
        clock           : in     vl_logic;
        q               : out    vl_logic_vector(11 downto 0)
    );
end dds_rom;
