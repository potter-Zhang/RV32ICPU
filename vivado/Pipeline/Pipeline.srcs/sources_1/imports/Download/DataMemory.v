`include "Defines.v"

module DataMemory(
	input clk,
	input rst,
	//input [14:0]sw,
	input [`ADDR_WIDTH - 1:0] address,
	input [`DATA_WIDTH - 1:0] writeData,
	input memRead,
	input memWrite,
	input [2:0] MemOp,
	output [`DATA_WIDTH - 1:0] readData
);


// memory
parameter byte = `BYTE - 1, width = `WIDTH - 1;
//reg [31:0] datain;
//reg [byte:0] memory[511:0];
reg [`DATA_WIDTH - 1:0] outData;
wire [`DATA_WIDTH - 1:0] memOutData;
wire [16:0] addr;
assign addr = address[16:0]; 
wire [3:0] op;

//assign op = (MemOp << 1) | 2'b01;

/*
always @(*)
begin
    if (memRead) begin
		case(MemOp)
			`DM_BYTE: begin outData <= {{(`DATA_WIDTH - `BYTE){memory[addr][`BYTE - 1]}}, memory[addr]}; end
			`DM_BYTE_UNSIGNED: begin outData <= {{(`DATA_WIDTH - `BYTE){1'b0}}, memory[addr]}; end
			`DM_HALF: begin outData <= {{(`DATA_WIDTH - `HALF){memory[addr + 1][`BYTE - 1]}}, memory[addr + 1], memory[addr]}; end
			`DM_HALF_UNSIGNED: begin outData <= {{(`DATA_WIDTH - `HALF){1'b0}}, memory[addr + 1], memory[addr]}; end
			`DM_WORD: begin outData <= {memory[addr + 3], memory[addr + 2], memory[addr + 1], memory[addr]}; end
		endcase	
	end
end

always@(negedge clk or negedge rst)
begin
    if (!rst) begin
	   {memory[7], memory[6], memory[5], memory[4]} <= {17'h00000, sw};	
	end   
	else if (memWrite)
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

//memory mem(.a(addr), .we(memWrite), .spo(outData), .clk(clk),
*/

always@(*) 
begin
     //datain <= !rst ? {17'h00000, sw} : writeData;
    if (memRead) begin
		case(MemOp)
			`DM_BYTE: begin outData <= {{(`DATA_WIDTH - `BYTE){outData[7]}}, memOutData[7:0]}; end
			`DM_BYTE_UNSIGNED: begin outData <= {{(`DATA_WIDTH - `BYTE){1'b0}}, memOutData[7:0]}; end
			`DM_HALF: begin outData <= {{(`DATA_WIDTH - `HALF){outData[15]}}, memOutData[15:0]}; end
			`DM_HALF_UNSIGNED: begin outData <= {{(`DATA_WIDTH - `HALF){1'b0}}, memOutData[15:0]}; end
			`DM_WORD: begin outData <= memOutData; end
		endcase	
		//$display("memoutdata = %h, outdata = %h\n", memOutData, memData);
	end
end
assign op = (memWrite | !rst) ? ( 
    !rst ? 4'b1111 : 
    (MemOp == `DM_BYTE) ? 4'b0001 : 
    (MemOp == `DM_HALF) ? 4'b0011 : 
    (MemOp == `DM_WORD) ? 4'b1111 :
    4'b0000) : 4'b0000;
/*
always@(posedge clk, negedge rst, posedge memRead)
begin
    if (!rst)
    begin
        datain <= {17'h00000, sw};	
        op <= 4'b1111;
    end
    else if (memWrite)
    begin
       
		case(MemOp)
			`DM_BYTE: op <= 4'b0001;
			//`DM_BYTE_UNSIGNED: memory[addr] <= writeData[`BYTE - 1:0];
			`DM_HALF: op <= 4'b0011;
			//`DM_HALF_UNSIGNED: {memory[addr + 1], memory[addr]} <= writeData[`HALF - 1:0];
			`DM_WORD: op <= 4'b1111;
			//`DM_WORD_UNSIGNED: {memory[addr + 3], memory[addr + 2], memory[addr + 1], memory[addr]} <= writeData[`WORD - 1:0];
		endcase
	end
	else if (memRead)
	   op <= 2'b00;
	else 
	   op <= 2'b00;
end
*/

assign readData = outData;

blk_mem memory(.addra(addr), .clka(clk), .dina(writeData), .douta(memOutData), .ena(memWrite | memRead), .wea(op));
endmodule
