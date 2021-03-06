library verilog;
use verilog.vl_types.all;
entity Multiple_Cycles_CPU is
    port(
        Clk             : in     vl_logic;
        PC_in           : out    vl_logic_vector(31 downto 0);
        PC_out          : out    vl_logic_vector(31 downto 0);
        Mem_addr_in     : out    vl_logic_vector(31 downto 0);
        Mem_data_out    : out    vl_logic_vector(31 downto 0);
        IR_out          : out    vl_logic_vector(31 downto 0);
        AddrReg_out     : out    vl_logic_vector(31 downto 0);
        Mem_data_shift  : out    vl_logic_vector(31 downto 0);
        Reg_data_shift  : out    vl_logic_vector(31 downto 0);
        Shift_out       : out    vl_logic_vector(31 downto 0);
        A_in            : out    vl_logic_vector(31 downto 0);
        B_in            : out    vl_logic_vector(31 downto 0);
        ALU_out         : out    vl_logic_vector(31 downto 0);
        ALUShift_out    : out    vl_logic_vector(31 downto 0);
        Rs_out          : out    vl_logic_vector(31 downto 0);
        Rt_out          : out    vl_logic_vector(31 downto 0);
        Rd_in           : out    vl_logic_vector(31 downto 0);
        Rt_addr         : out    vl_logic_vector(4 downto 0);
        Rd_addr         : out    vl_logic_vector(4 downto 0);
        Rs_addr         : out    vl_logic_vector(4 downto 0);
        condition       : out    vl_logic_vector(2 downto 0);
        ALU_SrcB        : out    vl_logic_vector(2 downto 0);
        ALU_op          : out    vl_logic_vector(3 downto 0);
        Rd_write_byte_en: out    vl_logic_vector(3 downto 0);
        Mem_byte_write  : out    vl_logic_vector(3 downto 0);
        RegDst          : out    vl_logic_vector(1 downto 0);
        MemtoReg        : out    vl_logic_vector(1 downto 0);
        PC_source       : out    vl_logic_vector(1 downto 0);
        Shift_op        : out    vl_logic_vector(1 downto 0);
        ALU_SrcA        : out    vl_logic;
        Ex_top          : out    vl_logic;
        Shift_amountSrc : out    vl_logic;
        ALUShift_Sel    : out    vl_logic;
        PC_write_cond   : out    vl_logic;
        PC_write_en     : out    vl_logic;
        IorD            : out    vl_logic;
        IR_write_en     : out    vl_logic;
        Addreg_write_en : out    vl_logic;
        Zero            : out    vl_logic;
        Less            : out    vl_logic;
        Overflow        : out    vl_logic;
        state           : out    vl_logic_vector(3 downto 0);
        RegDt0          : out    vl_logic
    );
end Multiple_Cycles_CPU;
