`include "Defines.v"
module MEMWBReg(
	input clk,
	input rst,
	input [`DATA_WIDTH - 1:0] I_memReadData,
	input [`DATA_WIDTH - 1:0] I_result,
	input I_MemtoReg,
	input [`DATA_WIDTH - 1:0]I_regWriteData,
	input I_RegWrite,
	input [4:0]I_writeRegister,
	input I_MemRead,
	//input I_RegSrc,
	
	output [`DATA_WIDTH - 1:0] O_memReadData,
	output [`DATA_WIDTH - 1:0] O_result,
	output O_MemtoReg,
	output [`DATA_WIDTH - 1:0]O_regWriteData,
	output O_RegWrite,
	output [4:0]O_writeRegister,
	output O_MemRead
	//output O_RegSrc
);

reg [`DATA_WIDTH - 1:0] memReadData;
reg [`DATA_WIDTH - 1:0] result;
reg MemtoReg;
reg [`DATA_WIDTH - 1:0]regWriteData;
reg RegWrite;
reg [4:0]writeRegister;
//reg RegSrc;
reg MemRead;

always@(negedge clk, negedge rst)
begin
	if (!rst)
	begin
	memReadData <= 0;
	result <= 0;
	MemtoReg <= 0;
	regWriteData <= 0;
	RegWrite <= 0;
	writeRegister <= 0;
	MemRead <= 0;
	end
	else 
	begin
	memReadData <= I_memReadData;
	result <= I_result;
	MemtoReg <= I_MemtoReg;
	regWriteData <= I_regWriteData;
	RegWrite <= I_RegWrite;
	writeRegister <= I_writeRegister;
	MemRead <= I_MemRead;
	end
	
	
end

assign O_memReadData = memReadData;
assign O_result = result;
assign O_MemtoReg = MemtoReg;
assign O_regWriteData = regWriteData;
assign O_RegWrite = RegWrite;
assign O_writeRegister = writeRegister;
assign O_MemRead = MemRead;

endmodule
