`include "Defines.v"

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


module ALU(
    	input [`DATA_WIDTH - 1:0] A,
    	input [`DATA_WIDTH - 1:0] B,
    	input [3:0] ALUOp,
    	output [`DATA_WIDTH - 1:0] result,
    	output Zero,
	output Less
);
   
reg [`DATA_WIDTH - 1:0] C;


always@(A, B, ALUOp)
begin
	case(ALUOp)
		`ALUOp_add: C <= A + B;
		`ALUOp_signed,
		`ALUOp_sub: C <= A - B; 
		`ALUOp_xor: C <= A ^ B;
		`ALUOp_or: C <= A | B;
		`ALUOp_and: C <= A & B;
		`ALUOp_sll: C <= A << B;
		`ALUOp_srl: C <= A >> B;
		`ALUOp_sra: C <= $signed(A) >>> B;	// declare its type to perform sra
		`ALUOp_slt: C <= $signed(A) < $signed(B);
		`ALUOp_sltu: C <= A < B;
		default: C <= C;
	endcase
end
    
assign result = C;
assign Zero = C == 0 ? 2'b1 : 2'b0;
assign Less = ALUOp[3:2] == 2'b11 ? ($signed(A) < $signed(B)) : (A < B);

endmodule