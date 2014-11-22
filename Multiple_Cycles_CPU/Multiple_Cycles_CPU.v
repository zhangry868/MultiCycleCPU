module MUX4_1_5bit(Sel,S0,S1,S2,S3,out);

input [1:0] Sel;
input [4:0] S0,S1,S2,S3;
output [4:0]out;

assign out = (Sel[1]?(Sel[0]?S3:S2) : (Sel[0]?S1:S0));

endmodule

module MUX4_1_32bit(Sel,S0,S1,S2,S3,out);

input [1:0] Sel;
input [31:0] S0,S1,S2,S3;
output [31:0]out;

assign out = (Sel[1]?(Sel[0]?S3:S2) : (Sel[0]?S1:S0));

endmodule

module Multiple_Cycles_CPU(
input Clk,
output [31:0] PC_in,PC_out,Mem_addr_in,Mem_data_out,IR_out,AddrReg_out,Mem_data_shift,Reg_data_shift,Shift_out,
output [31:0]A_in,B_in,ALU_out,ALUShift_out,Rs_out,Rt_out,Rd_in,
output [4:0] Rt_addr,Rd_addr,Rs_addr,
output [2:0] condition,ALU_SrcB,
output [3:0] ALU_op,Rd_write_byte_en,Mem_byte_write,
output [1:0] RegDst,MemtoReg,PC_source,Shift_op,
output ALU_SrcA,Ex_top,Shift_amountSrc,ALUShift_Sel,PC_write_cond,PC_write_en,IorD,IR_write_en,Addreg_write_en,
output Zero,Less,Overflow,PC_write,
output [3:0] state,
output RegDt0
);

PC pc(PC_in,PC_out,Clk,PC_write_en);

Instru_Control instruc_control(Less,Zero,PC_write_cond,PC_write,condition,PC_source,
IR_out[25:0],PC_out[31:28],ALUShift_out,AddrReg_out,Rs_out,PC_in,PC_write_en);

Controller controller(Clk,Overflow,IR_out,AddrReg_out[1:0],condition,ALU_SrcB,ALU_op,Rd_write_byte_en,Mem_byte_write,RegDst,MemtoReg,PC_source,Shift_op,
ALU_SrcA,Ex_top,Shift_amountSrc,ALUShift_Sel,PC_write_cond,PC_write,IorD,IR_write_en,Addreg_write_en,RegDt0,state);

assign Mem_addr_in = (IorD == 1'b1)?(AddrReg_out):(PC_out);

Memory memory(Reg_data_shift,Mem_addr_in,Mem_byte_write, Clk,Mem_data_out);

IRegister iregister(Mem_data_out,IR_out,Clk,IR_write_en);//Instructin Register

Register_ShiftOutput register_shiftOutput(Rt_out,Mem_addr_in[1:0],IR_out[31:26],Reg_data_shift);

Memory_ShiftOutput memory_shiftOutput(Mem_data_out,Mem_addr_in[1:0],IR_out[31:26],Mem_data_shift);

ExNumber exnumber(IR_out[15:0],Ex_top,ALU_SrcB,Rt_out,B_in);//位拓展模块

MUX4_1_5bit mux4_1_5bit_1(RegDst,IR_out[20:16],IR_out[15:11],5'b11111,5'b0,Rd_addr);
assign Rt_addr = (RegDt0 == 1'b1) ? 5'b0 : IR_out[20:16];
assign Rs_addr = IR_out[25:21]; 

MUX4_1_32bit mux4_1_32bit_1(MemtoReg,AddrReg_out,Mem_data_shift,ALU_out,32'b0,Rd_in);

MIPS_Register register(Rs_addr, Rt_addr, Rd_addr, Clk, Rd_write_byte_en, Rd_in, Rs_out, Rt_out); 

assign A_in = (ALU_SrcA == 1'b1)?Rs_out:PC_out;

ALU alu(A_in,B_in,ALU_op,Zero,Less,Overflow,ALU_out);

wire [4:0] Shift_amount;
assign Shift_amount = (Shift_amountSrc == 1'b1) ? Rs_out[4:0] : IR_out[10:6];

MIPS_Shifter barrel_shifter(Rt_out,Shift_amount,Shift_op,Shift_out);

assign ALUShift_out = (ALUShift_Sel == 1'b1)? Shift_out: ALU_out;

AddrReg addrReg(ALUShift_out, Addreg_write_en, Clk, AddrReg_out);

endmodule