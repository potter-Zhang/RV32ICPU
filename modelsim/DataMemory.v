`include "Defines.v"

module DataMemory(
	input clk,
	input [`ADDR_WIDTH - 1:0] address,
	input [`DATA_WIDTH - 1:0] writeData,
	input memRead,
	input memWrite,
	input [2:0] MemOp,
	output [`DATA_WIDTH - 1:0] readData
);

// memory
parameter byte = `BYTE - 1, width = `WIDTH - 1;

reg [byte:0] memory[1023:0];
reg [`DATA_WIDTH - 1:0] outData;
wire [9:0] addr;
assign addr = address[9:0]; 

always @(*)
begin
	if (memRead)
	begin
		case(MemOp)
			`DM_BYTE: begin outData <= {{(`DATA_WIDTH - `BYTE){memory[addr][`BYTE - 1]}}, memory[addr]}; end
			`DM_BYTE_UNSIGNED: begin outData <= {{(`DATA_WIDTH - `BYTE){1'b0}}, memory[addr]}; end
			`DM_HALF: begin outData <= {{(`DATA_WIDTH - `HALF){memory[addr + 1][`BYTE - 1]}}, memory[addr + 1], memory[addr]}; end
			`DM_HALF_UNSIGNED: begin outData <= {{(`DATA_WIDTH - `HALF){1'b0}}, memory[addr + 1], memory[addr]}; end
			`DM_WORD: begin outData <= {memory[addr + 3], memory[addr + 2], memory[addr + 1], memory[addr]}; end
		endcase	
	end
end

always@(negedge clk)
begin
	if (memWrite)
	begin
		case(MemOp)
			`DM_BYTE: memory[addr] <= writeData[`BYTE - 1:0];
			//`DM_BYTE_UNSIGNED: memory[addr] <= writeData[`BYTE - 1:0];
			`DM_HALF: {memory[addr + 1], memory[addr]} <= writeData[`HALF - 1:0];
			//`DM_HALF_UNSIGNED: {memory[addr + 1], memory[addr]} <= writeData[`HALF - 1:0];
			`DM_WORD: {memory[addr + 3], memory[addr + 2], memory[addr + 1], memory[addr]} <= writeData[`WORD - 1:0];
			//`DM_WORD_UNSIGNED: {memory[addr + 3], memory[addr + 2], memory[addr + 1], memory[addr]} <= writeData[`WORD - 1:0];
		endcase
	end
end

assign readData = outData;


endmodule
