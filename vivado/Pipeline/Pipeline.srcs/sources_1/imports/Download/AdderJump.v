`define PC_WIDTH 32

module AdderJump(
	input [`PC_WIDTH - 1:0] PC,
	input [`PC_WIDTH - 1:0] offset,
	output [`PC_WIDTH - 1:0] target
);

assign target = PC + offset;

endmodule
