library verilog;
use verilog.vl_types.all;
entity Instru_Control is
    port(
        less            : in     vl_logic;
        Zero            : in     vl_logic;
        PC_write_cond   : in     vl_logic;
        PC_write        : in     vl_logic;
        condition       : in     vl_logic_vector(2 downto 0);
        PC_source       : in     vl_logic_vector(1 downto 0);
        IR              : in     vl_logic_vector(25 downto 0);
        PC_out          : in     vl_logic_vector(31 downto 28);
        ALUShift_out    : in     vl_logic_vector(31 downto 0);
        AddrReg_out     : in     vl_logic_vector(31 downto 0);
        Rs_out          : in     vl_logic_vector(31 downto 0);
        PC_in           : out    vl_logic_vector(31 downto 0);
        PC_write_en     : out    vl_logic
    );
end Instru_Control;
