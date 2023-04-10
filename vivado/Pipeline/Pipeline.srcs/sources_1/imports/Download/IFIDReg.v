`include "Defines.v"

module IFIDReg(
	input clk,
	input rst,
	input IFIDWrite,
	input IFIDFlush,
	input [`PC_WIDTH - 1:0] I_pcout,
	input [`OP_WIDTH - 1:0] I_instruction,
	input [`PC_WIDTH - 1:0] I_nextPC,
	output [`PC_WIDTH - 1:0] O_pcout,
	output [`OP_WIDTH - 1:0] O_instruction,
	output [`PC_WIDTH - 1:0] O_nextPC
);

reg [`PC_WIDTH - 1:0] pcout;
reg [`OP_WIDTH - 1:0] instruction;
reg [`PC_WIDTH - 1:0] nextPC;

always@(negedge clk, negedge rst)
begin
	if (!rst)
	begin
		pcout <= 0;
		instruction  <= 0;
		nextPC <= 0;
	end
	
	else if (IFIDWrite)
	begin
		pcout <= I_pcout;
		instruction <= IFIDFlush ? 0 : I_instruction;
		nextPC <= I_nextPC;
	end
	else 
	begin
		pcout <= pcout;
		instruction <= instruction;
		nextPC <= nextPC;
	end
end

assign O_pcout = pcout;
assign O_instruction = instruction;
assign O_nextPC = nextPC;

endmodule
