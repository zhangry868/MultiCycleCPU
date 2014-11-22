library verilog;
use verilog.vl_types.all;
entity AddrReg is
    port(
        AddrReg_in      : in     vl_logic_vector(31 downto 0);
        AddrReg_write_en: in     vl_logic;
        Clk             : in     vl_logic;
        AddrReg_out     : out    vl_logic_vector(31 downto 0)
    );
end AddrReg;
