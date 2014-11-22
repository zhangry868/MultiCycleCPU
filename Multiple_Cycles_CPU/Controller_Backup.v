module Controller(
input Clk,Overflow,
input [31:0] IR,
output reg[2:0] condition,ALU_SrcB,
output reg[3:0] ALU_op,Rd_write_byte_en,Mem_byte_write,
output reg[1:0] RegDst,MemtoReg,PC_source,Shift_op,
output reg ALU_SrcA,Ex_top,Shift_amountSrc,ALUShift_Sel,PC_write_cond,PC_write,IorD,IR_write_en,Addreg_write_en,
output reg RegDt0,
output [3:0]state_out
);
	// Declare state register
	reg[3:0]state;//4bit,16kinds
	initial state = 4'd13;
	// Declare states
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7, S8 = 8, S9 = 9, S10 = 10, S11 = 11, S12 = 12, S13 = 13;
	assign state_out = state;
	// Determine the next state synchronously, based on the
	// current state and the input
	always @ (posedge Clk) begin
	case (state)
		S0:
			state <= S1;
		S1:
			state <= S2;
		S2:
			case(IR[31:26])
			6'b100010,6'b100011:state <= S3;//lw
			6'b101010,6'b101011:state <= S5;//sw
			6'b000000,6'b011111,6'b011100:state <= S6;//R
			6'b001000,6'b001001,6'b001110,6'b001010,6'b001111:state <= S8;//I
			6'b000001:
				case(IR[20:16])
					5'b00001:state <= S9;//Branch
					5'b10001:state <= S10;//Branch_process
					default:;
				endcase
			6'b000010:state <= S12;//J
			default:;
			endcase
		S3:
			state <= S4;
		S4:
			state <= S0;
		S5:
			state <= S0;
		S6:
			state <= S7;
		S7:
			state <= S0;
		S8:
			state <= S0;
		S9:
			state <= S0;
		S10:
			state <= S11;
		S11:
			state <= S0;
		S12:
			state <= S0;
		S13:
			state <= S0;
	endcase
	end

	// Determine the output based only on the current state
	// and the input (do not wait for a clock edge).
	always @ (state)
	begin
			case (state)
			S0:
			begin
				condition = 3'bzzz;ALU_SrcB = 3'bzzz;
				ALU_op = 4'bzzzz;Rd_write_byte_en = 4'b0000;Mem_byte_write = 4'b0000;
				RegDst = 2'bzz; MemtoReg = 2'bzz;PC_source = 2'bzz;IR_write_en = 1'b0;Addreg_write_en = 1'b0;
				ALU_SrcA = 1'bz;Ex_top = 1'bz;Shift_op = 2'bzz;Shift_amountSrc = 1'bz;ALUShift_Sel = 1'bz;PC_write_cond = 1'b0;PC_write = 1'b0;IorD = 1'b0; 
				RegDt0 = 1'b0;
			end	
			S1:
			begin
				condition = 3'bzzz;ALU_SrcB = 3'b001;
				ALU_op = 4'b0000;Rd_write_byte_en = 4'b0000;Mem_byte_write = 4'b0000;
				RegDst = 2'bzz; MemtoReg = 2'bzz;PC_source = 2'b00;IR_write_en = 1'b1;Addreg_write_en = 1'b0;
				ALU_SrcA = 1'b0;Ex_top = 1'bz;Shift_op = 2'bzz;Shift_amountSrc = 1'bz;ALUShift_Sel = 1'b0;PC_write_cond = 1'b0;PC_write = 1'b1;IorD = 1'b0; 
			end
			S2:
			begin
				case(IR[31:26])
				6'b001000:
				begin
					condition = 3'bzzz;ALU_SrcB = 3'b010;
					ALU_op = 4'b1110;Rd_write_byte_en = 4'b0000;Mem_byte_write = 4'b0000;
					RegDst = 2'bzz; MemtoReg = 2'bzz;PC_source = 2'bzz;IR_write_en = 1'b0;Addreg_write_en = 1'b1;
					ALU_SrcA = 1'b1;Ex_top = 1'b1;Shift_op = 2'bzz;Shift_amountSrc = 1'bz;ALUShift_Sel = 1'b0;PC_write_cond = 1'b0;PC_write = 1'b0;IorD = 1'b0; 
				end
				6'b001001:
				begin
					condition = 3'bzzz;ALU_SrcB = 3'b010;
					ALU_op = 4'b0000;Rd_write_byte_en = 4'b0000;Mem_byte_write = 4'b0000;
					RegDst = 2'bzz; MemtoReg = 2'bzz;PC_source = 2'bzz;IR_write_en = 1'b0;Addreg_write_en = 1'b1;
					ALU_SrcA = 1'b1;Ex_top = 1'b1;Shift_op = 2'bzz;Shift_amountSrc = 1'bz;ALUShift_Sel = 1'b0;PC_write_cond = 1'b0;PC_write = 1'b0;IorD = 1'b0; 
				end
				6'b001110:
				begin
					condition = 3'bzzz;ALU_SrcB = 3'b010;
					ALU_op = 4'b1001;Rd_write_byte_en = 4'b0000;Mem_byte_write = 4'b0000;
					RegDst = 2'bzz; MemtoReg = 2'bzz;PC_source = 2'bzz;IR_write_en = 1'b0;Addreg_write_en = 1'b1;
					ALU_SrcA = 1'b1;Ex_top = 1'b0;Shift_op = 2'bzz;Shift_amountSrc = 1'bz;ALUShift_Sel = 1'b0;PC_write_cond = 1'b0;PC_write = 1'b0;IorD = 1'b0; 
				end
				6'b001010:
				begin
					condition = 3'bzzz;ALU_SrcB = 3'b010;
					ALU_op = 4'b0101;Rd_write_byte_en = 4'b0000;Mem_byte_write = 4'b0000;
					RegDst = 2'bzz; MemtoReg = 2'bzz;PC_source = 2'bzz;IR_write_en = 1'b0;Addreg_write_en = 1'b1;
					ALU_SrcA = 1'b1;Ex_top = 1'b1;Shift_op = 2'bzz;Shift_amountSrc = 1'bz;ALUShift_Sel = 1'b0;PC_write_cond = 1'b0;PC_write = 1'b0;IorD = 1'b0; 
				end
				6'b001111:
				begin
					condition = 3'bzzz;ALU_SrcB = 3'b100;
					ALU_op = 4'b0000;Rd_write_byte_en = 4'b0000;Mem_byte_write = 4'b0000;
					RegDst = 2'bzz; MemtoReg = 2'bzz;PC_source = 2'bzz;IR_write_en = 1'b0;Addreg_write_en = 1'b1;
					ALU_SrcA = 1'b1;Ex_top = 1'bz;Shift_op = 2'bzz;Shift_amountSrc = 1'bz;ALUShift_Sel = 1'b0;PC_write_cond = 1'b0;PC_write = 1'b0;IorD = 1'b0; 
				end
				6'b000001://Branch
				begin
					condition = 3'bzzz;ALU_SrcB = 3'b011;
					ALU_op = 4'b0000;Rd_write_byte_en = 4'b0000;Mem_byte_write = 4'b0000;
					RegDst = 2'bzz; MemtoReg = 2'bzz;PC_source = 2'bzz;IR_write_en = 1'b0;Addreg_write_en = 1'b1;
					ALU_SrcA = 1'b0;Ex_top = 1'b1;Shift_op = 2'bzz;Shift_amountSrc = 1'bz;ALUShift_Sel = 1'b0;PC_write_cond = 1'b0;PC_write = 1'b0;IorD = 1'b0; 
					RegDt0 = 1'b1;
				end
				6'b101010,6'b101011://sw
				begin
					condition = 3'bzzz;ALU_SrcB = 3'b010;
					ALU_op = 4'b0000;Rd_write_byte_en = 4'b0000;Mem_byte_write = 4'b0000;
					RegDst = 2'bzz; MemtoReg = 2'bzz;PC_source = 2'bzz;IR_write_en = 1'b0;Addreg_write_en = 1'b1;
					ALU_SrcA = 1'b1;Ex_top = 1'b1;Shift_op = 2'bzz;Shift_amountSrc = 1'bz;ALUShift_Sel = 1'b0;PC_write_cond = 1'b0;PC_write = 1'b0;IorD = 1'b0; 
					RegDt0 = 1'b0;
				end
				default:
				begin
					condition = 3'bzzz;ALU_SrcB = 3'bzzz;
					ALU_op = 4'bzzzz;Rd_write_byte_en = 4'b0000;Mem_byte_write = 4'b0000;
					RegDst = 2'bzz; MemtoReg = 2'bzz;PC_source = 2'bzz;IR_write_en = 1'b0;Addreg_write_en = 1'b0;
					ALU_SrcA = 1'bz;Ex_top = 1'bz;Shift_op = 2'bzz;Shift_amountSrc = 1'bz;ALUShift_Sel = 1'bz;PC_write_cond = 1'b0;PC_write = 1'b0;IorD = 1'b0; 
				end
				endcase
			end		
			S3:
			begin
				condition = 3'bzzz;ALU_SrcB = 3'b010;
				ALU_op = 4'b0000;Rd_write_byte_en = 4'b0000;Mem_byte_write = 4'b0000;
				RegDst = 2'bzz; MemtoReg = 2'bzz;PC_source = 2'bzz;IR_write_en = 1'b0;Addreg_write_en = 1'b1;
				ALU_SrcA = 1'b1;Ex_top = 1'b1;Shift_op = 2'bzz;Shift_amountSrc = 1'bz;ALUShift_Sel = 1'b0;PC_write_cond = 1'b0;PC_write = 1'b0;IorD = 1'b1; 
			end	
			S4:
			begin
				condition = 3'bzzz;ALU_SrcB = 3'bzzz;
				ALU_op = 4'bzzzz;Rd_write_byte_en = 4'b1111;Mem_byte_write = 4'b0000;
				RegDst = 2'b01; MemtoReg = 2'b01;PC_source = 2'bzz;IR_write_en = 1'b0;Addreg_write_en = 1'b0;
				ALU_SrcA = 1'bz;Ex_top = 1'bz;Shift_op = 2'bzz;Shift_amountSrc = 1'bz;ALUShift_Sel = 1'bz;PC_write_cond = 1'b0;PC_write = 1'b0;IorD = 1'b1; 
			end	
			S5:
			begin
				condition = 3'bzzz;ALU_SrcB = 3'bzzz;
				ALU_op = 4'bzzzz;Rd_write_byte_en = 4'b0000;Mem_byte_write = 4'b1111;
				RegDst = 2'bzz; MemtoReg = 2'bzz;PC_source = 2'bzz;IR_write_en = 1'b0;Addreg_write_en = 1'b0;
				ALU_SrcA = 1'bz;Ex_top = 1'bz;Shift_op = 2'bzz;Shift_amountSrc = 1'bz;ALUShift_Sel = 1'bz;PC_write_cond = 1'b0;PC_write = 1'b0;IorD = 1'b1; 
			end	
			S6:
			begin
			case(IR[31:26])
			6'b000000:	
			begin
				condition = 3'bzzz;ALU_SrcB = 3'b000;
				Rd_write_byte_en = 4'b0000;Mem_byte_write = 4'b0000;
				RegDst = 2'bzz; MemtoReg = 2'bzz;PC_source = 2'bzz;IR_write_en = 1'b0;Addreg_write_en = 1'b1;
				ALU_SrcA = 1'b1;Ex_top = 1'bz;PC_write_cond = 1'b0;PC_write = 1'b0;IorD = 1'bz; 
				ALUShift_Sel = !IR[5];
				case(IR[5:0])
				6'b100000://Add
				begin
					ALU_op = 4'b1110;
					Shift_amountSrc = 1'bz;
					Shift_op = 2'bzz;
				end
				6'b100010://Sub
				begin
					ALU_op = 4'b1111;
					Shift_amountSrc = 1'bz;
					Shift_op = 2'bzz;
				end
				6'b100011://Subu
				begin
					ALU_op = 4'b0001;
					Shift_amountSrc = 1'bz;
					Shift_op = 2'bzz;
				end
				6'b101011://sltu
				begin
					ALU_op = 4'b0111;
					Shift_amountSrc = 1'bz;
					Shift_op = 2'bzz;
				end
				6'b000111://SRAV
				begin
					ALU_op = 4'bzzzz;
					Shift_amountSrc = 1'b1;
					Shift_op = 2'b10;
				end
				6'b000010://ROTR
				begin
					ALU_op = 4'bzzzz;
					Shift_amountSrc = 1'b0;
					Shift_op = 2'b11;
				end	
				default:
				begin
					ALU_op = 4'bzzzz;
					Shift_amountSrc = 1'bz;
					Shift_op = 2'bzz;
				end
				endcase
			end
			6'b011111://seb
			begin
				condition = 3'bzzz;ALU_SrcB = 3'b000;
				Rd_write_byte_en = 4'b0000;Mem_byte_write = 4'b0000;ALUShift_Sel = 1'b0;
				RegDst = 2'bzz; MemtoReg = 2'bzz;PC_source = 2'bzz;IR_write_en = 1'b0;Addreg_write_en = 1'b1;
				ALU_SrcA = 1'b1;Ex_top = 1'bz;PC_write_cond = 1'b0;PC_write = 1'b0;IorD = 1'bz; 	
				Shift_amountSrc = 1'bz;Shift_op = 2'bzz;ALU_op = 4'b1010;
			end
			6'b011100://clo,clz
			begin
				condition = 3'bzzz;ALU_SrcB = 3'b000;
				Rd_write_byte_en = 4'b0000;Mem_byte_write = 4'b0000;ALUShift_Sel = 1'b0;
				RegDst = 2'bzz; MemtoReg = 2'bzz;PC_source = 2'bzz;IR_write_en = 1'b0;Addreg_write_en = 1'b1;
				ALU_SrcA = 1'b1;Ex_top = 1'bz;PC_write_cond = 1'b0;PC_write = 1'b0;IorD = 1'bz; 	
				Shift_amountSrc = 1'bz;Shift_op = 2'bzz;ALU_op = {3'b001,IR[0]};
			end
			default:;
			endcase
			end	
			S7:
			begin
				/*condition <= 3'bzzz;ALU_SrcB = 3'bzzz;
				ALU_op = 4'bzzzz;Mem_byte_write = 4'b0000;
				PC_source = 2'bzz;IR_write_en = 1'b0;Addreg_write_en = 1'b0;
				ALU_SrcA = 1'bz;Ex_top = 1'bz;Shift_op = 2'bzz;Shift_amountSrc = 1'bz;ALUShift_Sel = 1'bz;PC_write_cond = 1'b0;PC_write = 1'b0;IorD = 1'bz; 
				*/
				RegDst = 2'b01; MemtoReg = 2'b00;Mem_byte_write = 4'b0000;Addreg_write_en = 1'b0;
				PC_write_cond = 1'b0;PC_write = 1'b0;
				case(IR[5:0])
				6'b100000,6'b100010://Add,//Sub
					Rd_write_byte_en = {4{!Overflow}};
				default:Rd_write_byte_en = 4'b1111;
				endcase
			end	
			S8:
			begin
				Mem_byte_write = 4'b0000;
				RegDst = 2'b00; MemtoReg = 2'b00;IR_write_en = 1'b0;Addreg_write_en = 1'b0;
				PC_write_cond = 1'b0;PC_write = 1'b0;
				case(IR[31:26])
				6'b001000://Addi
					Rd_write_byte_en = {4{!Overflow}};
				default:Rd_write_byte_en = 4'b1111;
				endcase
			end	
			S9:
			begin
				condition <= 3'b011;ALU_SrcB = 3'b000;
				ALU_op = 4'b0001;Rd_write_byte_en = 4'b0000;Mem_byte_write = 4'b0000;
				RegDst = 2'bzz; MemtoReg = 2'bzz;PC_source = 2'b01;IR_write_en = 1'b0;Addreg_write_en = 1'b0;
				ALU_SrcA = 1'b1;Ex_top = 1'bz;Shift_op = 2'bzz;Shift_amountSrc = 1'bz;ALUShift_Sel = 1'bz;PC_write_cond = 1'b1;PC_write = 1'b0;IorD = 1'bz; 
			end	
			S10:
			begin
				condition <= 3'bzzz;ALU_SrcB = 3'b001;
				ALU_op = 4'b0000;Rd_write_byte_en = 4'b1111;Mem_byte_write = 4'b0000;
				RegDst = 2'b10; MemtoReg = 2'b10;PC_source = 2'bzz;IR_write_en = 1'b0;Addreg_write_en = 1'b0;
				ALU_SrcA = 1'b0;Ex_top = 1'bz;Shift_op = 2'bzz;Shift_amountSrc = 1'bz;ALUShift_Sel = 1'b0;PC_write_cond = 1'b0;PC_write = 1'b0;IorD = 1'bz; 
			end	
			S11:
			begin
				condition <= 3'b011;ALU_SrcB = 3'b000;
				ALU_op = 4'b0001;Rd_write_byte_en = 4'b0000;Mem_byte_write = 4'b0000;
				RegDst = 2'bzz; MemtoReg = 2'bzz;PC_source = 2'b01;IR_write_en = 1'b0;Addreg_write_en = 1'b0;
				ALU_SrcA = 1'b1;Ex_top = 1'bz;Shift_op = 2'bzz;Shift_amountSrc = 1'bz;ALUShift_Sel = 1'bz;PC_write_cond = 1'b1;PC_write = 1'b0;IorD = 1'bz; 
			end	
			S12:
			begin
				condition <= 3'bzzz;ALU_SrcB = 3'bzzz;
				ALU_op = 4'bzzzz;Rd_write_byte_en = 4'b0000;Mem_byte_write = 4'b0000;
				RegDst = 2'bzz; MemtoReg = 2'bzz;PC_source = 2'b10;IR_write_en = 1'b0;Addreg_write_en = 1'b0;
				ALU_SrcA = 1'bz;Ex_top = 1'bz;Shift_op = 2'bzz;Shift_amountSrc = 1'bz;ALUShift_Sel = 1'bz;PC_write_cond = 1'b0;PC_write = 1'b1;IorD = 1'bz; 
			end
			S13:
			begin
				condition = 3'bzzz;ALU_SrcB = 3'bzzz;
				ALU_op = 4'bzzzz;Rd_write_byte_en = 4'b0000;Mem_byte_write = 4'b0000;
				RegDst = 2'bzz; MemtoReg = 2'bzz;PC_source = 2'bzz;IR_write_en = 1'b0;Addreg_write_en = 1'b0;
				ALU_SrcA = 1'bz;Ex_top = 1'bz;Shift_op = 2'bzz;Shift_amountSrc = 1'bz;ALUShift_Sel = 1'bz;PC_write_cond = 1'b0;PC_write = 1'b0;IorD = 1'b0; 
			end
			endcase
	end

endmodule
