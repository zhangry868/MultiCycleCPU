module MUX8_1_32(Sel,S0,S1,S2,S3,S4,S5,S6,S7,out);

input [2:0] Sel;
input [31:0] S0,S1,S2,S3,S4,S5,S6,S7;
output [31:0]out;

assign out = (Sel[2])? (Sel[1]?(Sel[0]?S7:S6) : (Sel[0]?S5:S4))  :  (Sel[1]?(Sel[0]?S3:S2) : (Sel[0]?S1:S0));

endmodule

module ExNumber(
input [15:0] IR,//Imm,Offset
input Ex_top,
input [2:0] ALU_SrcB,
input [31:0] Rt_out,
output [31:0] B_in
);

wire [31:0]Ex_offset,Imm_ex,addroffset_ex;
assign Ex_offset = {((Ex_top == 1)?{16{IR[15]}}:16'b0),IR[15:0]};//2,Imm
assign Imm_ex = {IR,16'b0};//4,Lui
assign addroffset_ex = {Ex_offset[29:0],2'b00};
MUX8_1_32 mux8_1_32(ALU_SrcB,Rt_out,32'h4,Ex_offset,addroffset_ex,Imm_ex,32'b0,32'b0,32'b0,B_in);

endmodule