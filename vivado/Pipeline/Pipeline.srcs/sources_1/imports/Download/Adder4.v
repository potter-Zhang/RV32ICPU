`define PC_WIDTH 32

module Adder4(
	input [`PC_WIDTH - 1:0] PC,
	output [`PC_WIDTH - 1:0] nextPC
);

assign nextPC = PC + 3'b100;

endmodule
