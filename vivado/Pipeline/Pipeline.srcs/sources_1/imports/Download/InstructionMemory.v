`include "Defines.v"
`define ADDR_SPACE 1024
module InstructionMemory(
	input [`ADDR_WIDTH - 1:0] address,
	output [`OP_WIDTH - 1:0] instruction
);
wire [6:0] addr;
imem memory(.a(addr), .spo(instruction));
assign addr = address[8:2];
//reg [`BYTE - 1:0]memory[`ADDR_SPACE - 1:0];
//wire [9:0] addr;
//assign addr = address[6:0];
//assign instruction = {memory[addr + 3], memory[addr + 2], memory[addr + 1], memory[addr]};
endmodule
