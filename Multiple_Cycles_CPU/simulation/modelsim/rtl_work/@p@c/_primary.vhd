library verilog;
use verilog.vl_types.all;
entity PC is
    port(
        PC_in           : in     vl_logic_vector(31 downto 0);
        PC_out          : out    vl_logic_vector(31 downto 0);
        Clk             : in     vl_logic;
        PC_write_en     : in     vl_logic
    );
end PC;
