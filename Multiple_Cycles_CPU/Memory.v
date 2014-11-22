/*module Memory(
input [3:0] Mem_byte_wr_in,
input [31:0] Mem_data_in,Mem_addr_in,
input CLK,
output [31:0] Mem_data_out
);

reg [3:0]Mem_byte_wr_reg;
reg [31:0]Mem_data_reg,Mem_addr_reg;
reg [31:0] Mem_data [2**31 - 1];


always@(posedge CLK)
begin
	Mem_byte_wr_reg <= Mem_byte_wr_in;
	Mem_data_reg <= Mem_data_in;
	Mem_addr_reg <= Mem_addr_in;
end

wire [31:0] Mem_data_reg_out;
wire [31:0] Mem_addr_reg_out;
wire [3:0] Mem_byte_wr_reg_out;

assign Mem_byte_wr_reg_out = Mem_byte_wr_reg;
assign Mem_data_reg_out = Mem_data_reg;
assign Mem_addr_reg_out = Mem_addr_reg;

always@(Mem_data_reg_out or Mem_addr_reg_out or Mem_byte_wr_reg_out)
begin
	if(Mem_byte_wr_reg_out[0])//高电平有效
		Mem_data[Mem_addr_reg_out][7:0] <= Mem_data_reg_out[7:0];
	if(Mem_byte_wr_reg_out[1])
		Mem_data[Mem_addr_reg_out][15:8] <= Mem_data_reg_out[15:8];
	if(Mem_byte_wr_reg_out[2])
		Mem_data[Mem_addr_reg_out][23:16] <= Mem_data_reg_out[23:16];
	if(Mem_byte_wr_reg_out[3])
		Mem_data[Mem_addr_reg_out][31:24] <= Mem_data_reg_out[31:24];
end
endmodule
*/

module Memory 
#(parameter DATA_WIDTH = 32, parameter ADDR_WIDTH = 32)
(
	input [(DATA_WIDTH-1):0] data,
	input [(ADDR_WIDTH-1):0] addr,
	input [3:0] we, 
	input clk,
	output [(DATA_WIDTH-1):0] q
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**(ADDR_WIDTH - 22) - 1:0];

	// Variable to hold the registered read address
	reg [ADDR_WIDTH-1:0] addr_reg;

	always @ (negedge clk)
	begin
	case(we)
	 4'b0001: ram[addr[9:2]][7:0] <= data[7:0];
	 4'b0010: ram[addr[9:2]][15:8] <= data[15:8];
	 4'b0011: ram[addr[9:2]][15:0] <= data[15:0];
	 4'b0100: ram[addr[9:2]][23:16] <= data[23:16];
	 4'b0101: begin ram[addr[9:2]][23:16] <= data[23:16]; ram[addr[9:2]][7:0] <= data[7:0];end
	 4'b0110: ram[addr[9:2]][23:8] <= data[23:8];
	 4'b0111: ram[addr[9:2]][23:0] <= data[23:0];
	 4'b1000: ram[addr[9:2]][31:24] <= data[31:24];
	 4'b1001: begin ram[addr[9:2]][31:24] <= data[31:24]; ram[addr[9:2]][7:0] <= data[7:0];end
	 4'b1010: begin ram[addr[9:2]][31:24] <= data[31:24]; ram[addr[9:2]][15:8] <= data[15:8];end
	 4'b1011: begin ram[addr[9:2]][31:24] <= data[31:24]; ram[addr[9:2]][15:0] <= data[15:0];end
	 4'b1100: ram[addr[9:2]][31:16] <= data[31:16];
	 4'b1101: begin ram[addr[9:2]][31:16] <= data[31:16]; ram[addr[9:2]][7:0] <= data[7:0];end
	 4'b1110: ram[addr[9:2]][31:8] <= data[31:8];
	 4'b1111: ram[addr[9:2]] <= data; 
	 default:;
	 endcase
	 end
initial
begin
/*
ram[0] = 32'b000000_00010_00011_00011_00000_100000;
ram[1] = 32'b000000_00010_00011_00011_00000_100000;//2# + 3# ->3#
ram[2] = 32'b000000_00010_00001_00010_00000_100010;//2# - 1#
ram[3] = {16'b000001_00010_00010,16'hfffd};//begz 2# > 0
ram[4] = {16'b000001_00011_00011,16'hffff};//begz 3# > 0
*/
//1# 1
//2# 2
//Add Sub

//--------------------------------------------Test1-------------------------------------------

ram[0] = 32'b000000_01001_01010_00011_00000_100000;//3# 3 
ram[1] = 32'b000000_01001_01100_00100_00000_100010;//9# - 12#
ram[2] = 32'b000000_11111_00100_00101_00000_100010;//31# - 4# ->5# Overflow
ram[3] = 32'b000000_00101_00001_00011_00000_100000;//5# + 1# ->5#
//5# 6

ram[4] = 32'b000000_00100_00001_00101_00000_100011;//subu 4# - 1# ->5# 5#ffffffe
ram[5] = 32'b000000_00010_00101_00101_00000_000111;//SRAV 5# >> (2#:2)
ram[6] = 32'b000000_00010_01001_00101_00010_000010;//ROTR 9# >> (Shamat)->5#
ram[7] = 32'b000000_01010_01001_00101_00000_101011;//sltu 10# - 9# -> 5#
//???????5# fffffff
ram[8] = {16'b001000_00101_00101,16'h789a};//addi 5# I ->5#
ram[9] = {16'b001000_11111_00101,16'h7abc};//addi 31# I ->5#  
ram[10] = {16'b001001_11111_00101,16'h7abc};//addiu 31# I ->5#  
ram[11] = {16'b001001_00101_00101,16'h789a};//addiu 5# I ->5#

ram[12] = {16'b001111_00000_00101,16'h789a};//lui lui I ->5#
ram[13] = {16'b001110_11111_00101,16'habcd};//xori xori I 31# -> 5#

ram[14] = 32'b011100_01011_00010_00101_00000_100001;//clo 11# ->5#
ram[15] = 32'b011100_01010_00010_00101_00000_100000;//clz 10# ->5#
ram[16] = {16'b001010_00101_00101,16'habcd};//slti  5# < I ->5#
ram[17] = 32'b011111_00000_01101_00110_10000_100000;//seb 8# -> 6#
ram[18] = {16'b101011_00000_01001,16'd512};//sw
ram[19] = {16'b101010_00000_11111,16'd256};//swl
ram[20] = {16'b100011_00000_00011,16'd512};//lw
ram[21] = {16'b100010_00000_00011,16'd513};//lwl
ram[22] = {16'b100010_00000_00011,16'd514};//lwl
ram[23] = {16'b100010_00000_00011,16'd515};//lwl
ram[24] = {16'b100110_00000_00011,16'd513};//lwr
ram[25] = {16'b100110_00000_00011,16'd514};//lwr
ram[26] = {16'b100110_00000_00011,16'd515};//lwr
ram[27] = 32'b000000_01001_00011_00011_00000_100000;//3# 3 
//ram[8'b10000000] = 32'h7fffffff;
ram[28] = {16'b101010_00000_11111,16'd513};//swl
ram[29] = {16'b101010_00000_11111,16'd514};//swl
ram[30] = {16'b101010_00000_11111,16'd515};//swl
ram[31] = {16'b101110_00000_11111,16'd513};//swr
ram[32] = {16'b101110_00000_11111,16'd514};//swr
ram[33] = {16'b101110_00000_11111,16'd515};//swr
ram[34] = {16'b000001_00001_10001,16'h0006};//begzal 1# > 0
//ram[19] = {16'b000001_00001_00001,16'h0010};//begz 1# > 0
ram[35] = {6'b000010,2'b0,24'h0};//J
ram[41] = {16'b000001_11110_00001,16'h0001};//begz 30# < 0

ram[42] = {6'b000010,2'b0,24'h0};//J


//-------------------------Test2--------------------------------------------------------------
/*
ram[0] = {16'b101011_00000_01001,16'd512};//sw
ram[1] = {16'b101010_00000_11111,16'd256};//swl
ram[2] = {16'b100011_00000_00011,16'd512};//lw
ram[3] = {16'b100010_00000_00011,16'd513};//lwl
ram[4] = {16'b100010_00000_00011,16'd514};//lwl
ram[5] = {16'b100010_00000_00011,16'd515};//lwl
ram[6] = {16'b100110_00000_00011,16'd513};//lwr
ram[7] = {16'b100110_00000_00011,16'd514};//lwr
ram[8] = {16'b100110_00000_00011,16'd515};//lwr
//ram[8'b10000000] = 32'h7fffffff;
ram[9] = {16'b101010_00000_11111,16'd513};//swl
ram[10] = {16'b101010_00000_11111,16'd514};//swl
ram[11] = {16'b101010_00000_11111,16'd515};//swl
ram[12] = {16'b101110_00000_11111,16'd513};//swr
ram[13] = {16'b101110_00000_11111,16'd514};//swr
ram[14] = {16'b101110_00000_11111,16'd515};//swr
*/

//----------------------------Test3----------------------------------------------------------
//ram[0] = {16'b000001_11111_00011,16'd1};//bgezal
//ram[1] = {16'b000001_11111_00001,16'hffff};//begz 3# > 0

//----------------------------Test4----------------------------------------------------------
/*ram[0] = 32'b000000_00010_00011_00011_00000_100000;//2# + 3# ->3#
ram[1] = 32'b000000_00010_00001_00010_00000_100010;//2# - 1#
ram[2] = {16'b000001_00010_00001,16'hfffd};//begz 2# > 0
ram[3] = {16'b000001_00011_00001,16'hffff};//begz 3# > 0
*/
end	
	
	
	// Continuous assignment implies read returns NEW data.
	// This is the natural behavior of the TriMatrix memory
	// blocks in Single Port mode.  
	assign q = ram[addr[9:2]];

endmodule


