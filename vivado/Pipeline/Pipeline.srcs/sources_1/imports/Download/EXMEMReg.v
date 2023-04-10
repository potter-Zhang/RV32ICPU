`include "Defines.v"


module EXMEMReg(
	input clk,
	input rst, 
	input [`REG_ADDR_WIDTH - 1:0] I_writeRegister,
	input [`DATA_WIDTH - 1:0]I_regWriteData,
	
	input [`DATA_WIDTH - 1:0] I_result,
	input [1:0] I_LessZero,
	//input [`PC_WIDTH - 1:0] I_targetPC,
	input [4:0]I_Branch,		
	input I_MemRead,
	input I_MemtoReg,
	input I_RegWrite,	
	input I_MemWrite,
	//input I_RegWrite,
	input [2:0]I_MemOp,
	input [`DATA_WIDTH - 1:0] I_regReadData2,
	input [`REG_ADDR_WIDTH - 1:0] I_readRegister2,
	
	output [`DATA_WIDTH - 1:0] O_regReadData2,
	//output [`DATA_WIDTH - 1:0] O_imm,
	output [`DATA_WIDTH - 1:0] O_result,
	output [1:0] O_LessZero,
	//output [`PC_WIDTH - 1:0] O_targetPC,
	output [`REG_ADDR_WIDTH - 1:0] O_writeRegister,
	output [4:0]O_Branch,		
	output O_MemRead,
	output O_MemtoReg,
	//output O_RegWrite,	
	output O_MemWrite,
	output O_RegWrite,
	output [2:0]O_MemOp,
	output [`DATA_WIDTH - 1:0]O_regWriteData,
	output [`REG_ADDR_WIDTH - 1:0] O_readRegister2
	
);

reg [`DATA_WIDTH - 1:0] regReadData2;
//reg [`DATA_WIDTH - 1:0] imm;
reg [`REG_ADDR_WIDTH - 1:0] writeRegister;
reg [4:0] Branch;	
reg MemRead;
reg MemtoReg;
reg RegSrc;
reg MemWrite;
reg RegWrite;
reg [2:0]MemOp;
reg [`DATA_WIDTH - 1:0] result;
reg [1:0] LessZero;
//reg [`PC_WIDTH - 1:0] targetPC;
reg [`DATA_WIDTH - 1:0]regWriteData;
reg [`REG_ADDR_WIDTH - 1:0]readRegister2;


always@(negedge clk, negedge rst)
begin
	if (!rst)
	begin
	regReadData2 <= 0;
	writeRegister <= 0;
	Branch <= 0;
	MemRead <= 0;
	MemtoReg <= 0;
	//RegSrc <= I_RegSrc;
	MemWrite <= 0;
	RegWrite <= 0;
	MemOp <= 0;
	//targetPC <= 0;
	regWriteData <= 0;
	LessZero <= 0;
	result <= 0;
	readRegister2 <= 0;
	end
	else 
	begin	
	regReadData2 <= I_regReadData2;
	writeRegister <= I_writeRegister;
	Branch <= I_Branch;
	MemRead <= I_MemRead;
	MemtoReg <= I_MemtoReg;
	//RegSrc <= I_RegSrc;
	MemWrite <= I_MemWrite;
	RegWrite <= I_RegWrite;
	MemOp <= I_MemOp;
	//targetPC <= I_targetPC;
	regWriteData <= I_regWriteData;
	LessZero <= I_LessZero;
	result <= I_result;
	readRegister2 <= I_readRegister2;
	//nextPC_targetPC_PCSelect <= I_nextPC_targetPC_PCSelect;
	end
	
end

assign O_regReadData2 = regReadData2;
assign O_writeRegister = writeRegister;
assign O_Branch = Branch;
assign O_MemRead = MemRead;
assign O_MemtoReg = MemtoReg;
//assign O_RegSrc = RegSrc;
assign O_MemWrite = MemWrite;
assign O_RegWrite = RegWrite;
assign O_MemOp = MemOp;
//assign O_targetPC = targetPC;
assign O_regWriteData = regWriteData;
assign O_LessZero = LessZero;
assign O_result = result;
assign O_readRegister2 = readRegister2;
endmodule

