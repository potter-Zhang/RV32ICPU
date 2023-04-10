`define DATA_WIDTH 32
`define OP_WIDTH 32
`define PC_WIDTH 32
`define DM_WORD 3'b100
`define REG_ADDR_WIDTH 5
module Pipeline(
	input clk,
	input rst,
	input [14:0]sw
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

wire PCWrite;
wire IFIDWrite;
wire Clear;

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
wire [`DATA_WIDTH - 1:0]pcout_regReadData2_BaseSrc;
// wire nextPC_targetPC_PCSrc; => pcin
wire [`DATA_WIDTH - 1:0]regWriteData_memReadData_MemtoReg;
// wire rmm_nextPC_RegSrc; => regWriteData
wire [`DATA_WIDTH - 1:0]result_imm_LoadSrc;
wire [`DATA_WIDTH - 1:0]nextPC_targetPC_PCSelect;

// Forward Unit Signal
wire [1:0] ForwardA;
wire [1:0] ForwardB;
wire ForwardC;

// IF/ID
wire [`PC_WIDTH - 1:0] ifidreg_pcout;
wire [`OP_WIDTH - 1:0] ifidreg_instruction;
wire [`PC_WIDTH - 1:0] ifidreg_nextPC;

//ID
wire [`DATA_WIDTH - 1:0] signalout;
wire [1:0] BForwardA;
wire [1:0] BForwardB;
wire [`DATA_WIDTH - 1:0] compare1;
wire [`DATA_WIDTH - 1:0] compare2;
wire cmpZero;
wire cmpLess;

// ID/EX
wire [4:0]idexreg_Branch;
wire idexreg_MemRead;
wire idexreg_MemtoReg;
wire [1:0]idexreg_ALUOp;
wire idexreg_MemWrite;
wire idexreg_ALUSrc;
wire idexreg_RegWrite;
wire [2:0]idexreg_MemOp;
wire idexreg_BaseSrc;
wire idexreg_RegSrc;
wire idexreg_LoadSrc;
wire idexreg_PCSelect;
wire [`DATA_WIDTH - 1:0] idexreg_regReadData1;
wire [`DATA_WIDTH - 1:0] idexreg_regReadData2;
wire [`DATA_WIDTH - 1:0] idexreg_imm;
wire [`PC_WIDTH - 1:0] idexreg_nextPC;
wire [`PC_WIDTH - 1:0] idexreg_targetPC;
wire [3:0] idexreg_funct;
wire [4:0] idexreg_writeRegister;
wire [4:0] idexreg_readRegister1;
wire [4:0] idexreg_readRegister2;

// EX
wire [`DATA_WIDTH - 1:0]A;
wire [`DATA_WIDTH - 1:0]B;
wire [`DATA_WIDTH - 1:0]C;

// EX/MEM
//wire [`PC_WIDTH - 1:0] exmemreg_targetPC;
wire [4:0] exmemreg_Branch;
wire exmemreg_MemtoReg;
wire [2:0] exmemreg_MemOp;
wire [`DATA_WIDTH - 1:0]exmemreg_regReadData2;
wire [`DATA_WIDTH - 1:0]exmemreg_result;
wire [`REG_ADDR_WIDTH - 1:0]exmemreg_writeRegister;
wire exmemreg_RegWrite;
wire exmemreg_MemWrite;
wire [4:0] exmemreg_readRegister2;
wire exmemreg_MemRead;
wire [1:0] exmemreg_LessZero;
wire [`DATA_WIDTH - 1:0] exmemreg_regWriteData;

// MEM/WB
wire memwbreg_MemtoReg;
wire memwbreg_RegWrite;
wire [4:0]memwbreg_writeRegister;
wire [`DATA_WIDTH - 1:0]memwbreg_result;
wire memwbreg_MemRead;
wire [`DATA_WIDTH - 1:0]memwbreg_regWriteData;
wire [`DATA_WIDTH - 1:0]memwbreg_memReadData;


// IF phase
// PC
PC pc(.clk(clk), .rst(rst), .en(PCWrite), .pcin(pcin), .pcout(pcout));

// IM
InstructionMemory im(.address(pcout), .instruction(instruction));

//A4
Adder4 adder4(.PC(pcout), .nextPC(nextPC));

// IF/ID Register
IFIDReg ifidreg(.clk(clk), .rst(rst), .IFIDFlush(PCSrc), .IFIDWrite(IFIDWrite), .I_pcout(pcout), .I_instruction(instruction), .I_nextPC(nextPC),
	.O_pcout(ifidreg_pcout), .O_instruction(ifidreg_instruction), .O_nextPC(ifidreg_nextPC));


//ID phase
// CTRL
Control ctrl(.instruction(ifidreg_instruction[6:0]), .funct(ifidreg_instruction[14:12]), .Branch(Branch), .MemRead(MemRead), .MemtoReg(MemtoReg), .ALUOp(ALUOp),
	.MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .MemOp(MemOp), .BaseSrc(BaseSrc), .RegSrc(RegSrc),
		.LoadSrc(LoadSrc), .PCSelect(PCSelect));

Mux mux9(.data1({{(30){1'b0}}, RegWrite, MemWrite}), .data2(32'h00000000), .control(Clear), .out(signalout));

// RF
RegisterFile rf(.clk(clk), .RegWrite(memwbreg_RegWrite/*RegWrite*/), .ReadRegister1(ifidreg_instruction[19:15]), .ReadRegister2(ifidreg_instruction[24:20]), 
	.WriteRegister(memwbreg_writeRegister/*ifidreg_instruction[11:7]*/), .WriteData(regWriteData_memReadData_MemtoReg), .ReadData1(regReadData1), .ReadData2(regReadData2));

// IG
ImmGen ig(.instruction(ifidreg_instruction), .immediate(imm));

// BFU
BranchForwardingUnit bfu(.exmemreg_writeRegister(exmemreg_writeRegister), .memwbreg_writeRegister(memwbreg_writeRegister),
	.memwbreg_RegWrite(memwbreg_RegWrite), .exmemreg_RegWrite(exmemreg_RegWrite), .ifidreg_readRegister1(ifidreg_instruction[19:15]),
	.ifidreg_readRegister2(ifidreg_instruction[24:20]), .BForwardA(BForwardA), .BForwardB(BForwardB));

// Mux_4
Mux_4 mux43(.data1(regReadData1), .data2(regWriteData_memReadData_MemtoReg), .data3(exmemreg_regWriteData), .data4(0),
	.control(BForwardA), .out(compare1));
Mux_4 mux44(.data1(regReadData2), .data2(regWriteData_memReadData_MemtoReg), .data3(exmemreg_regWriteData), .data4(0),
	.control(BForwardB), .out(compare2));
// CMP
Comparator cmp(.data1(compare1), .data2(compare2), .sign(Branch[3]), .Zero(cmpZero), .Less(cmpLess));

// BCTRL
BranchControl bctrl(.Branch(Branch), .LessZero({cmpLess, cmpZero}), .out(PCSrc));

//AJ
AdderJump adderjump(.PC(pcout_regReadData2_BaseSrc/*pcin_regReadData2_BaseSrc*/), .offset(imm/*idexreg_imm*/), .target(targetPC));

// select from pcout and regReadData2, control by BaseSrc
Mux mux2(.data1(ifidreg_pcout), .data2(compare1), .control(BaseSrc), .out(pcout_regReadData2_BaseSrc));

// select from nextPC and targetPC, control by PCSrc
Mux mux3(.data1(nextPC), .data2(targetPC), .control(PCSrc), .out(pcin));


// ID/EX Register

IDEXReg idexreg(.clk(clk), .rst(rst), .I_targetPC(targetPC/*ifidreg_pcout*/), .I_regReadData1(regReadData1), .I_regReadData2(regReadData2), .I_imm(imm),
	.I_funct({ifidreg_instruction[30], ifidreg_instruction[14:12]}), .I_writeRegister(ifidreg_instruction[11:7]),
	.I_Branch(Branch), .I_MemRead(MemRead), .I_MemtoReg(MemtoReg), .I_RegSrc(RegSrc), .I_BaseSrc(BaseSrc),
	.I_ALUOp(ALUOp), .I_MemWrite(signalout[0]),  .I_RegWrite(signalout[1]), .I_MemOp(MemOp), .I_readRegister2(ifidreg_instruction[24:20]),
	.I_ALUSrc(ALUSrc), .I_LoadSrc(LoadSrc), .I_PCSelect(PCSelect), .I_nextPC(ifidreg_nextPC), .I_readRegister1(ifidreg_instruction[19:15]),
	.O_targetPC(idexreg_targetPC), .O_regReadData1(idexreg_regReadData1), .O_regReadData2(idexreg_regReadData2), .O_imm(idexreg_imm),
	.O_funct(idexreg_funct), .O_writeRegister(idexreg_writeRegister),
	.O_Branch(idexreg_Branch), .O_MemRead(idexreg_MemRead), .O_MemtoReg(idexreg_MemtoReg), .O_RegSrc(idexreg_RegSrc), .O_BaseSrc(idexreg_BaseSrc),
	.O_ALUOp(idexreg_ALUOp), .O_MemWrite(idexreg_MemWrite),  .O_RegWrite(idexreg_RegWrite), .O_MemOp(idexreg_MemOp), 
	.O_ALUSrc(idexreg_ALUSrc), .O_LoadSrc(idexreg_LoadSrc), .O_PCSelect(idexreg_PCSelect), .O_nextPC(idexreg_nextPC),
	.O_readRegister1(idexreg_readRegister1), .O_readRegister2(idexreg_readRegister2));

// EX phase
// ALU
ALU alu(.A(A), .B(imm_regReadData2_ALUSrc), .ALUOp(ALUCon), .result(result), .Zero(Zero), .Less(Less));

// ALUCTRL
AluControl aluctrl(.ALUOp(idexreg_ALUOp), .funct(idexreg_funct), .ALUCon(ALUCon));

// select from imm and regReadData2, control by ALUSrc
Mux mux1(.data1(B), .data2(idexreg_imm), .control(idexreg_ALUSrc), .out(imm_regReadData2_ALUSrc));

// select from rmm and nextPC, control by RegSrc
Mux mux5(.data1(result_imm_LoadSrc), .data2(nextPC_targetPC_PCSelect), .control(idexreg_RegSrc), .out(regWriteData));

// select from result and imm, control by LoadSrc
Mux mux6(.data1(result), .data2(idexreg_imm), .control(idexreg_LoadSrc), .out(result_imm_LoadSrc));

// select from nextPC and targetPC, control by PCSelect
Mux mux7(.data1(idexreg_nextPC), .data2(idexreg_targetPC), .control(idexreg_PCSelect), .out(nextPC_targetPC_PCSelect));

// forward unit
ForwardingUnit fu(.exmemreg_writeRegister(exmemreg_writeRegister), .memwbreg_writeRegister(memwbreg_writeRegister),
	.idexreg_readRegister1(idexreg_readRegister1), .idexreg_readRegister2(idexreg_readRegister2), 
	.exmemreg_RegWrite(exmemreg_RegWrite), .memwbreg_RegWrite(memwbreg_RegWrite), .exmemreg_MemWrite(exmemreg_MemWrite),
	.memwbreg_MemRead(memwbreg_MemRead), .exmemreg_readRegister2(exmemreg_readRegister2),
	.ForwardA(ForwardA), .ForwardB(ForwardB), .ForwardC(ForwardC));


Mux_4 mux_41(.data1(idexreg_regReadData1), .data2(regWriteData_memReadData_MemtoReg), .data3(exmemreg_regWriteData), 
	.data4(0), .control(ForwardA), .out(A));
Mux_4 mux_42(.data1(idexreg_regReadData2), .data2(regWriteData_memReadData_MemtoReg), .data3(exmemreg_regWriteData), 
	.data4(0), .control(ForwardB), .out(B));

// EX/MEM Regsiter
EXMEMReg exmemreg(.clk(clk), .rst(rst), .I_writeRegister(idexreg_writeRegister), .I_regWriteData(regWriteData), .I_result(result), .I_LessZero({Less, Zero}),
	/*.I_targetPC(targetPC),*/ .I_Branch(idexreg_Branch), .I_MemRead(idexreg_MemRead), .I_MemtoReg(idexreg_MemtoReg),
	.I_MemWrite(idexreg_MemWrite), .I_RegWrite(idexreg_RegWrite), .I_MemOp(idexreg_MemOp), .I_regReadData2(B/**/), .I_readRegister2(idexreg_readRegister2),
	.O_writeRegister(exmemreg_writeRegister), .O_regWriteData(exmemreg_regWriteData), .O_result(exmemreg_result),
	.O_LessZero(exmemreg_LessZero), /*.O_targetPC(exmemreg_targetPC),*/ .O_Branch(exmemreg_Branch), .O_MemRead(exmemreg_MemRead),
	.O_MemtoReg(exmemreg_MemtoReg), .O_MemWrite(exmemreg_MemWrite), .O_RegWrite(exmemreg_RegWrite), .O_MemOp(exmemreg_MemOp),
	.O_regReadData2(exmemreg_regReadData2), .O_readRegister2(exmemreg_readRegister2));

// MEM phase
// DM
DataMemory dm(.clk(clk), .rst(rst),  .address(!rst ? 17'h10004 : exmemreg_result), /*.sw(sw),*/  .writeData(!rst ? {{(17){1'b0}}, sw} : C/**/), .memRead(exmemreg_MemRead), .memWrite(exmemreg_MemWrite | !rst), 
	.readData(memReadData), .MemOp(exmemreg_MemOp));

Mux mux8(.data1(exmemreg_regReadData2), .data2(memwbreg_memReadData), .control(ForwardC), .out(C));
// MEMWBReg

MEMWBReg memwbreg(.clk(clk), .rst(rst), .I_memReadData(memReadData), .I_MemtoReg(exmemreg_MemtoReg), .I_result(exmemreg_result),
	 .I_regWriteData(exmemreg_regWriteData), .I_RegWrite(exmemreg_RegWrite), .I_writeRegister(exmemreg_writeRegister),
	.I_MemRead(exmemreg_MemRead),
	.O_memReadData(memwbreg_memReadData), .O_MemtoReg(memwbreg_MemtoReg), .O_RegWrite(memwbreg_RegWrite),
	.O_result(memwbreg_result), .O_regWriteData(memwbreg_regWriteData), 
	.O_MemRead(memwbreg_MemRead), .O_writeRegister(memwbreg_writeRegister));
	

// WB phase
// select from nextPC and targetPC, control by MemtoReg
Mux mux4(.data1(memwbreg_regWriteData), .data2(memwbreg_memReadData), .control(memwbreg_MemtoReg), .out(regWriteData_memReadData_MemtoReg));


// Hazard
HazardDetectionUnit hdu(.idexreg_MemRead(idexreg_MemRead), .idexreg_RegWrite(idexreg_RegWrite), .idexreg_writeRegister(idexreg_writeRegister), .exmemreg_MemRead(exmemreg_MemRead), .exmemreg_writeRegister(exmemreg_writeRegister),
		.ifidreg_readRegister1(ifidreg_instruction[19:15]), .ifidreg_opcode(ifidreg_instruction[6:0]), .ifidreg_readRegister2(ifidreg_instruction[24:20]),
		.PCWrite(PCWrite), .IFIDWrite(IFIDWrite), .Clear(Clear));

endmodule

