library verilog;
use verilog.vl_types.all;
entity NCO_NEW is
    port(
        clk             : in     vl_logic;
        clken           : in     vl_logic;
        phi_inc_i       : in     vl_logic_vector(31 downto 0);
        fsin_o          : out    vl_logic_vector(11 downto 0);
        out_valid       : out    vl_logic;
        reset_n         : in     vl_logic
    );
end NCO_NEW;
