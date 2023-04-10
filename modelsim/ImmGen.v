`define OP_WIDTH 32
`define DATA_WIDTH 32

`define R_TYPE_OP 7'b0110011
`define	LI_TYPE_OP 7'b0000011
`define RI_TYPE_OP 7'b0010011
`define SB_TYPE_OP 7'b1100011
`define S_TYPE_OP 7'b0100011
`define JI_TYPE_OP 7'b1100111
`define UJ_TYPE_OP 7'b1101111
`define AU_TYPE_OP 7'b0010111
`define LU_TYPE_OP 7'b0110111

module ImmGen(
	input [`OP_WIDTH - 1:0] instruction,
	output reg [`DATA_WIDTH - 1:0] immediate
);

always@ (instruction)
begin
	if (instruction[6:0] == `LI_TYPE_OP || instruction[6:0] == `JI_TYPE_OP)
	begin
		immediate <= {{(20){instruction[31]}}, instruction[31:20]};
	end
	else if (instruction[6:0] == `RI_TYPE_OP)
	begin
		if (instruction[14:12] == 3'b101 && instruction[30] == 1'b1)	// srai
			immediate <= {{(20){instruction[31]}}, instruction[25:20]};
		else 
			immediate <= {{(20){instruction[31]}}, instruction[31:20]};
	end
	else if (instruction[6:0] == `S_TYPE_OP)
	begin
		immediate <= {{(20){instruction[31]}}, instruction[31:25], instruction[11:7]};
	end
	else if (instruction[6:0] == `SB_TYPE_OP)	// shift left 1
	begin
		immediate <= {{(19){instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
	end
	else if (instruction[6:0] == `AU_TYPE_OP || instruction[6:0] == `LU_TYPE_OP)
	begin
		immediate <= {instruction[31:12], {(12){1'b0}}};
	end
	else if (instruction[6:0] == `UJ_TYPE_OP)	// shift left 1
	begin
		immediate <= {{(11){instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
	end
	else 
	begin 
		immediate <= immediate;
	end
end

// write an independent sl1

endmodule

