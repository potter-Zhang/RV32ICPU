`define ALUOp_add 4'b0000
`define ALUOp_sub 4'b0001
`define ALUOp_xor 4'b0010
`define ALUOp_or 4'b0011
`define ALUOp_and 4'b0100
`define ALUOp_sll 4'b0101
`define ALUOp_srl 4'b0110
`define ALUOp_sra 4'b0111
`define ALUOp_signed 4'b1100
`define ALUOp_slt 4'b1101
`define ALUOp_sltu 4'b1011

`define Func_add_or_sub 3'b000
`define Func_add 4'b0000
`define Func_sub 4'b1000
`define Func_sll 3'b001
`define Func_slt 3'b010
`define Func_sltu 3'b011
`define Func_xor 3'b100
`define Func_srl_or_sra 3'b101
`define Func_srl 4'b0101
`define Func_sra 4'b1101
`define Func_or 3'b110
`define Func_and 3'b111


module AluControl(
	input [1:0] ALUOp,
	input [3:0] funct,
	output reg [3:0] ALUCon
);

always@(ALUOp, funct)
begin
	if (ALUOp == 2'b00)	// for load and store
	begin
		ALUCon <= `ALUOp_add;
	end
	else if (ALUOp == 2'b01)	// for branch
	begin
		if (funct[1:0] == 2'b00 || funct[1:0] == 2'b01)
			ALUCon <= `ALUOp_signed;
		else
			ALUCon <= `ALUOp_sub;
	end
	else if (ALUOp == 2'b10 || ALUOp == 2'b11)	// for R type and R_I type
	begin
		case(funct[2:0])
			`Func_add_or_sub: 
				if (funct[3] == 1'b0 || ALUOp[0] == 1) ALUCon <= `ALUOp_add; 
				else ALUCon <= `ALUOp_sub;
			`Func_sll: ALUCon <= `ALUOp_sll;
			`Func_slt: ALUCon <= `ALUOp_slt;
			`Func_sltu: ALUCon <= `ALUOp_sltu;
			`Func_xor: ALUCon <= `ALUOp_xor;
			`Func_srl_or_sra: 
				if (funct[3] == 1'b0) ALUCon <= `ALUOp_srl;
				else ALUCon <= `ALUOp_sra;
			`Func_or: ALUCon <= `ALUOp_or;
			`Func_and: ALUCon <= `ALUOp_and;	
		endcase
	end
	else 
		ALUCon <= `ALUOp_add;

end



endmodule
