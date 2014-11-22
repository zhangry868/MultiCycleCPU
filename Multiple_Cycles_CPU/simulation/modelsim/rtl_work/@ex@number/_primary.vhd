library verilog;
use verilog.vl_types.all;
entity ExNumber is
    port(
        IR              : in     vl_logic_vector(15 downto 0);
        Ex_top          : in     vl_logic;
        ALU_SrcB        : in     vl_logic_vector(2 downto 0);
        Rt_out          : in     vl_logic_vector(31 downto 0);
        B_in            : out    vl_logic_vector(31 downto 0)
    );
end ExNumber;
