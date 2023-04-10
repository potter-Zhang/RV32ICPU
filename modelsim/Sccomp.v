//`include "Defines.v"
`define DATA_WIDTH 32
`define OP_WIDTH 32
`define DM_WORD 3'b100
module Sccomp(
	input clk,
	input rst,
	//output [`DATA_WIDTH - 1:0]pcin,
	//output jump,
	//output [`DATA_WIDTH - 1:0] reg1,
	//output [`DATA_WIDTH - 1:0] reg2,
	output [`DATA_WIDTH - 1:0] aluout,
	output [`DATA_WIDTH - 1:0] A,
	output [`DATA_WIDTH - 1:0] B
);

// input and output of PC
wire [`DATA_WIDTH - 1:0] pcin;
wire [`DATA_WIDTH - 1:0] pcout;

// instruction from IM
wire [`OP_WIDTH - 1:0] instruction;

// control signal
wire [4:0]Branch;
wire MemWrite;
wire MemRead;
wire PCSrc;
wire BaseSrc;
wire MemtoReg;
wire RegSrc;
wire ALUSrc;
wire RegWrite;
wire [2:0] MemOp;
wire LoadSrc;
wire PCSelect;

wire [1:0]ALUOp;
wire [3:0]ALUCon;

// output of alu
wire Zero;
wire Less;
wire [`DATA_WIDTH - 1:0]result;

// output and input of regFile
wire [`DATA_WIDTH - 1:0]regReadData1;
wire [`DATA_WIDTH - 1:0]regReadData2;
wire [`DATA_WIDTH - 1:0]regWriteData;

// output of DM
wire [`DATA_WIDTH - 1:0] memReadData;

// immediate
wire [`DATA_WIDTH - 1:0]imm;

// PC+4 and PC+offset
wire[`DATA_WIDTH - 1:0] nextPC;
wire[`DATA_WIDTH - 1:0] targetPC;

// output of mux
wire [`DATA_WIDTH - 1:0]imm_regReadData2_ALUSrc;
wire [`DATA_WIDTH - 1:0]pcin_regReadData2_BaseSrc;
// wire nextPC_targetPC_PCSrc; => pcin
wire [`DATA_WIDTH - 1:0]ril_memReadData_MemtoReg;
// wire rmm_nextPC_RegSrc; => regWriteData
wire [`DATA_WIDTH - 1:0]result_imm_LoadSrc;
wire [`DATA_WIDTH - 1:0]nextPC_targetPC_PCSelect;

// PC
PC pc(.clk(clk), .rst(rst), .en(1'b1), .pcin(pcin), .pcout(pcout));

// IM
InstructionMemory im(.address(pcout), .instruction(instruction));

// CTRL
Control ctrl(.instruction(instruction[6:0]), .funct(instruction[14:12]), .Branch(Branch), .MemRead(MemRead), .MemtoReg(MemtoReg), .ALUOp(ALUOp),
	.MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .MemOp(MemOp), .BaseSrc(BaseSrc), .RegSrc(RegSrc),
		.LoadSrc(LoadSrc), .PCSelect(PCSelect));

// ALUCTRL
AluControl aluctrl(.ALUOp(ALUOp), .funct({instruction[30], instruction[14:12]}), .ALUCon(ALUCon));

// BCTRL
BranchControl bctrl(.Branch(Branch), .LessZero({Less, Zero}), .out(PCSrc));

// RF
RegisterFile rf(.clk(clk), .RegWrite(RegWrite), .ReadRegister1(instruction[19:15]), .ReadRegister2(instruction[24:20]), 
	.WriteRegister(instruction[11:7]), .WriteData(regWriteData), .ReadData1(regReadData1), .ReadData2(regReadData2));

// ALU
ALU alu(.A(regReadData1), .B(imm_regReadData2_ALUSrc), .ALUOp(ALUCon), .result(result), .Zero(Zero), .Less(Less));

// DM
DataMemory dm(.clk(clk), .address(result), .writeData(regReadData2), .memRead(MemRead), .memWrite(MemWrite), 
	.readData(memReadData), .MemOp(MemOp));

// IG
ImmGen ig(.instruction(instruction), .immediate(imm));

//A4
Adder4 adder4(.PC(pcout), .nextPC(nextPC));

//AJ
AdderJump adderjump(.PC(pcin_regReadData2_BaseSrc), .offset(imm), .target(targetPC));

// select from imm and regReadData2, control by ALUSrc
Mux mux1(.data1(regReadData2), .data2(imm), .control(ALUSrc), .out(imm_regReadData2_ALUSrc));

// select from pcout and regReadData2, control by BaseSrc
Mux mux2(.data1(pcout), .data2(regReadData1), .control(BaseSrc), .out(pcin_regReadData2_BaseSrc));

// select from nextPC and targetPC, control by PCSrc
Mux mux3(.data1(nextPC), .data2(targetPC), .control(PCSrc), .out(pcin));

// select from nextPC and targetPC, control by MemtoReg
Mux mux4(.data1(result_imm_LoadSrc), .data2(memReadData), .control(MemtoReg), .out(ril_memReadData_MemtoReg));

// select from rmm and nextPC, control by RegSrc
Mux mux5(.data1(ril_memReadData_MemtoReg), .data2(nextPC_targetPC_PCSelect), .control(RegSrc), .out(regWriteData));

// select from result and imm, control by LoadSrc
Mux mux6(.data1(result), .data2(imm), .control(LoadSrc), .out(result_imm_LoadSrc));

// select from nextPC and targetPC, control by PCSelect
Mux mux7(.data1(nextPC), .data2(targetPC), .control(PCSelect), .out(nextPC_targetPC_PCSelect));

// select from 
assign aluout = result;
assign A = regReadData1;
assign B = imm_regReadData2_ALUSrc;


endmodule

