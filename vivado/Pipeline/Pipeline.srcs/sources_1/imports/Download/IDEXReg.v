`include "Defines.v"

module IDEXReg(
	input clk,
	input rst,
	input [`PC_WIDTH - 1:0] I_targetPC,
	input [`DATA_WIDTH - 1:0] I_regReadData1,
	input [`DATA_WIDTH - 1:0] I_regReadData2,
	input [`DATA_WIDTH - 1:0] I_imm,
	input [3:0] I_funct,
	input [`REG_ADDR_WIDTH - 1:0] I_writeRegister,
	input [4:0]I_Branch,		
	input I_MemRead,
	input I_MemtoReg,
	input I_RegSrc,	
	input I_BaseSrc,	
	input [1:0]I_ALUOp,
	input I_MemWrite,
	input I_ALUSrc,
	input I_RegWrite,
	input [2:0]I_MemOp,
	input I_LoadSrc,	
	input I_PCSelect,	
	input [`PC_WIDTH - 1:0] I_nextPC,
	input [4:0] I_readRegister1,
	input [4:0] I_readRegister2,

	output [`PC_WIDTH - 1:0] O_targetPC,
	output [`DATA_WIDTH - 1:0] O_regReadData1,
	output [`DATA_WIDTH - 1:0] O_regReadData2,
	output [`DATA_WIDTH - 1:0] O_imm,
	output [3:0] O_funct,
	output [`REG_ADDR_WIDTH - 1:0] O_writeRegister,
	output [4:0]O_Branch,		
	output O_MemRead,
	output O_MemtoReg,
	output O_RegSrc,	
	output O_BaseSrc,	
	output [1:0]O_ALUOp,
	output O_MemWrite,
	output O_ALUSrc,
	output O_RegWrite,
	output [2:0]O_MemOp,
	output O_LoadSrc,	
	output O_PCSelect,
	output [`PC_WIDTH - 1:0] O_nextPC,
	output [4:0] O_readRegister1,
	output [4:0] O_readRegister2
);

reg [`PC_WIDTH - 1:0] targetPC;
reg [`PC_WIDTH - 1:0] nextPC;
reg [`DATA_WIDTH - 1:0] regReadData1;
reg [`DATA_WIDTH - 1:0] regReadData2;
reg [`DATA_WIDTH - 1:0] imm;
reg [3:0] funct;
reg [`REG_ADDR_WIDTH - 1:0] writeRegister;
reg [4:0] Branch;	
reg MemRead;
reg MemtoReg;
reg RegSrc;
reg BaseSrc;
reg [1:0]ALUOp;
reg MemWrite;
reg ALUSrc;
reg RegWrite;
reg [2:0]MemOp;
reg LoadSrc;
reg PCSelect;
reg [4:0]readRegister1;
reg [4:0]readRegister2;

always@(negedge clk, negedge rst)
begin
	if (!rst)
	begin
	targetPC <= 0;
	regReadData1 <= 0;
	regReadData2 <= 0;
	imm <= 0;
	funct <= 0;
	writeRegister <= 0;
	Branch <= 0;
	MemRead <= 0;
	MemtoReg <= 0;
	RegSrc <= 0;
	BaseSrc <= 0;
	ALUOp <= 0;
	MemWrite <= 0;
	ALUSrc <= 0;
	RegWrite <= 0;
	MemOp <= 0;
	LoadSrc <= 0;
	PCSelect <= 0;
	nextPC <= 0;
	readRegister1 <= 0;
	readRegister2 <= 0;
	end
	else 
	begin
	targetPC <= I_targetPC;
	regReadData1 <= I_regReadData1;
	regReadData2 <= I_regReadData2;
	imm <= I_imm;
	funct <= I_funct;
	writeRegister <= I_writeRegister;
	Branch <= I_Branch;
	MemRead <= I_MemRead;
	MemtoReg <= I_MemtoReg;
	RegSrc <= I_RegSrc;
	BaseSrc <= I_BaseSrc;
	ALUOp <= I_ALUOp;
	MemWrite <= I_MemWrite;
	ALUSrc <= I_ALUSrc;
	RegWrite <= I_RegWrite;
	MemOp <= I_MemOp;
	LoadSrc <= I_LoadSrc;
	PCSelect <= I_PCSelect;
	nextPC <= I_nextPC;
	readRegister1 <= I_readRegister1;
	readRegister2 <= I_readRegister2;
	end
end

assign O_targetPC = targetPC;
assign O_regReadData1 = regReadData1;
assign O_regReadData2 = regReadData2;
assign O_imm = imm;
assign O_funct = funct;
assign O_writeRegister = writeRegister;
assign O_Branch = Branch;
assign O_MemRead = MemRead;
assign O_MemtoReg = MemtoReg;
assign O_RegSrc = RegSrc;
assign O_BaseSrc = BaseSrc;
assign O_ALUOp = ALUOp;
assign O_MemWrite = MemWrite;
assign O_ALUSrc = ALUSrc;
assign O_RegWrite = RegWrite;
assign O_MemOp = MemOp;
assign O_LoadSrc = LoadSrc;
assign O_PCSelect = PCSelect;
assign O_nextPC = nextPC;
assign O_readRegister1 = readRegister1;
assign O_readRegister2 = readRegister2;

endmodule

