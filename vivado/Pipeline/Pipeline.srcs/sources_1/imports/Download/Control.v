`define R_TYPE_OP 7'b0110011
`define	LI_TYPE_OP 7'b0000011
`define RI_TYPE_OP 7'b0010011
`define SB_TYPE_OP 7'b1100011
`define S_TYPE_OP 7'b0100011
`define JI_TYPE_OP 7'b1100111
`define UJ_TYPE_OP 7'b1101111
`define AU_TYPE_OP 7'b0010111
`define LU_TYPE_OP 7'b0110111

`define Func_beq 3'b000
`define Func_bne 3'b001
`define Func_blt 3'b100
`define Func_bge 3'b101
`define Func_bltu 3'b110
`define Func_bgeu 3'b111

`define SB_BEQ 5'b10011
`define SB_BNE 5'b10001
`define SB_BLT 5'b11111
`define SB_BGE 5'b11101
`define SB_BLTU 5'b10111
`define SB_BGEU 5'b10101
`define SB_JAL_OR_JALR 5'b00001
`define SB_NOP 5'b00000

`define WB_ALU 2'b00
`define WB_MEM 2'b10
`define WB_PC  2'b01

`define PC_4 2'b00
`define PC_IMM 2'b01
`define PC_REG 2'b10

module Control(
	input [6:0] instruction,
	input [2:0] funct,
	//input Clear,
	// 4(0/1): unconditional or conditional 3: unsigned or signed 2: zero or less 1: no or yes 0: not branch or branch
	output reg [4:0]Branch,		
	output reg MemRead,
	// 1(0/1): AlutoReg or Memtoreg 0: AlutoReg or PCtoReg
	output reg MemtoReg,
	output reg RegSrc,	// 0 normal 1 nextPC
	output reg BaseSrc,	// 0 imm 1 reg
	output reg[1:0]ALUOp,
	output reg MemWrite,
	output reg ALUSrc,
	output reg RegWrite,
	output reg [2:0]MemOp,
	// 1(0/1): PC+4 or PC+offset 0: PC+imm or reg+imm
	output reg LoadSrc,	// 0 result 1 imm
	output reg PCSelect	// 0 nextPC 1 targetPC
	//output reg PCSrc	// 0 nromal 1 jump
);

always@ (instruction, funct)
begin
	case(instruction)
	`RI_TYPE_OP:
	begin
		Branch <= `SB_NOP;
		MemRead <= 1'b0;
		ALUSrc <= 1'b1;
		MemtoReg <= 1'b0;
		RegSrc <= 1'b0;
		BaseSrc <= 1'b0;
		ALUOp <= 2'b11;
		MemWrite <= 1'b0;
		RegWrite <= 1'b1;
		MemOp <= 3'b000;
		LoadSrc <= 1'b0;
		PCSelect <= 1'b0;
		//PCSrc <= 1'b0;
	end
	`R_TYPE_OP:
	begin
		Branch <= `SB_NOP;
		MemRead <= 1'b0;
		ALUSrc <= 1'b0;
		MemtoReg <= 1'b0;
		BaseSrc <= 1'b0;
		RegSrc <= 1'b0;
		ALUOp <= 2'b10;
		MemWrite <= 1'b0;
		RegWrite <= 1'b1;
		MemOp <= 3'b000;
		LoadSrc <= 1'b0;
		PCSelect <= 1'b0;
		//PCSrc <= 1'b0;
	end
	`LI_TYPE_OP:
	begin 
		Branch <= `SB_NOP;
		MemRead <= 1'b1;
		ALUSrc <= 1'b1;
		MemtoReg <= 1'b1;
		RegSrc <= 1'b0;
		BaseSrc <= 1'b0;
		ALUOp <= 2'b00;
		MemWrite <= 1'b0;
		RegWrite <= 1'b1;
		MemOp <= funct;
		LoadSrc <= 1'b0;
		PCSelect <= 1'b0;
		//PCSrc <= 1'b0;
	end
	`S_TYPE_OP:
	begin 
		Branch <= `SB_NOP;
		MemRead <= 1'b0;
		ALUSrc <= 1'b1;
		MemtoReg <= 1'b1;
		RegSrc <= 1'b0;
		BaseSrc <= 1'b0;
		ALUOp <= 2'b00;
		MemWrite <= 1'b1;
		RegWrite <= 1'b0;
		MemOp <= funct;
		LoadSrc <= 1'b0;
		PCSelect <= 1'b0;
		//PCSrc <= 1'b0;	
	end
	`SB_TYPE_OP:
	begin 
		ALUSrc <= 1'b0;
		RegWrite <= 1'b0;
		MemRead <= 1'b0;
		MemWrite <= 1'b0;
		ALUOp <= 2'b01;
		BaseSrc <= 1'b0;
		RegSrc <= 1'b0;
		LoadSrc <= 1'b0;
		PCSelect <= 1'b0;
		case (funct)
			`Func_beq: Branch <= `SB_BEQ;
			`Func_bne: Branch <= `SB_BNE;
			`Func_blt: Branch <= `SB_BLT;
			`Func_bge: Branch <= `SB_BGE;
			`Func_bltu: Branch <= `SB_BLTU;
			`Func_bgeu: Branch <= `SB_BGEU;
		endcase
	end
	// jalr
	`JI_TYPE_OP:
	begin
		ALUSrc <= 1'b1;
		RegWrite <= 1'b1;
		MemRead <= 1'b0;
		MemWrite <= 1'b0;
		// new aluop
		ALUOp <= 2'b00;
		//PCSrc <= 1'b1;
		MemtoReg <= 1'b0;
		RegSrc <= 1'b1;
		BaseSrc <= 1'b1;
		Branch <= `SB_JAL_OR_JALR;
		LoadSrc <= 1'b0;
		PCSelect <= 1'b0;
	end
	`UJ_TYPE_OP:
	begin
		ALUSrc <= 1'b1;
		RegWrite <= 1'b1;
		MemRead <= 1'b0;
		MemWrite <= 1'b0;
		ALUOp <= 2'b00;
		//PCSrc <= 1'b1;
		MemtoReg <= 1'b0;
		BaseSrc <= 1'b0;
		RegSrc <= 1'b1;
		Branch <= `SB_JAL_OR_JALR;
		LoadSrc <= 1'b0;
		PCSelect <= 1'b0;
	end
	`AU_TYPE_OP:
	begin
		Branch <= `SB_NOP;
		MemRead <= 1'b0;
		ALUSrc <= 1'b0;
		MemtoReg <= 1'b0;
		RegSrc <= 1'b1;
		BaseSrc <= 1'b0;
		ALUOp <= 2'b00;
		MemWrite <= 1'b0;
		RegWrite <= 1'b1;
		MemOp <= 3'b000;
		LoadSrc <= 1'b0;
		PCSelect <= 1'b1;
	end
	`LU_TYPE_OP:
	begin
		Branch <= `SB_NOP;
		MemRead <= 1'b0;
		ALUSrc <= 1'b0;
		MemtoReg <= 1'b0;
		RegSrc <= 1'b0;
		BaseSrc <= 1'b0;
		ALUOp <= 2'b00;
		MemWrite <= 1'b0;
		RegWrite <= 1'b1;
		MemOp <= 3'b000;
		LoadSrc <= 1'b1;
		PCSelect <= 1'b0;
	end
	default:
	begin
		Branch <= `SB_NOP;
		MemRead <= 1'b0;
		ALUSrc <= 1'b0;
		MemtoReg <= 1'b0;
		RegSrc <= 1'b0;
		BaseSrc <= 1'b0;
		ALUOp <= 2'b00;
		MemWrite <= 1'b0;
		RegWrite <= 1'b0;
		MemOp <= 3'b000;
		LoadSrc <= 1'b0;
		PCSelect <= 1'b0;
	end
	endcase
end



endmodule