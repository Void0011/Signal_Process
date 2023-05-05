library verilog;
use verilog.vl_types.all;
entity DDS is
    generic(
        ftw             : integer := 128849018
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        key_in          : in     vl_logic_vector(3 downto 0);
        freq_out        : out    vl_logic_vector(11 downto 0);
        ipout_vaild     : out    vl_logic;
        dac_clk         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ftw : constant is 1;
end DDS;
