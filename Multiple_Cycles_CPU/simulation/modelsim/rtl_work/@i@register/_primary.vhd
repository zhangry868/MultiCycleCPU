library verilog;
use verilog.vl_types.all;
entity IRegister is
    port(
        IR_in           : in     vl_logic_vector(31 downto 0);
        IR_out          : out    vl_logic_vector(31 downto 0);
        Clk             : in     vl_logic;
        IR_write_en     : in     vl_logic
    );
end IRegister;
