module MUX8_1_Single(Sel,S0,S1,S2,S3,S4,S5,S6,S7,out);

input [2:0] Sel;
input S0,S1,S2,S3,S4,S5,S6,S7;
output out;

assign out = (Sel[2])? (Sel[1]?(Sel[0]?S7:S6) : (Sel[0]?S5:S4))  :  (Sel[1]?(Sel[0]?S3:S2) : (Sel[0]?S1:S0));

endmodule

module MUX4_1_IControl(Sel,S0,S1,S2,S3,out);

input [1:0] Sel;
input [31:0] S0,S1,S2,S3;
output [31:0]out;

assign out = (Sel[1]?(Sel[0]?S3:S2) : (Sel[0]?S1:S0));

endmodule

module Instru_Control(
input less,Zero,PC_write_cond,PC_write,
input [2:0] condition,
input [1:0] PC_source,
input [25:0] IR,
input [31:28] PC_out,
input [31:0] ALUShift_out,AddrReg_out,Rs_out,
output [31:0] PC_in,
output PC_write_en
);

wire [31:0] Target_address;
assign Target_address = {PC_out[31:28],IR[25:0],2'b00};
MUX4_1_IControl mux4_1_8(PC_source,ALUShift_out,AddrReg_out,Target_address,32'h0,PC_in);
wire condition_out;
MUX8_1_Single MUX_Con(condition,1'b0,Zero,!Zero,!less,!(less^Zero),less^Zero,less,1'b1,condition_out);

assign PC_write_en = (condition_out & PC_write_cond)| PC_write;

endmodule