`define R_TYPE_OP 7'b0110011
`define	LI_TYPE_OP 7'b0000011
`define RI_TYPE_OP 7'b0010011
`define SB_TYPE_OP 7'b1100011
`define S_TYPE_OP 7'b0100011
`define JI_TYPE_OP 7'b1100111
`define UJ_TYPE_OP 7'b1101111
`define AU_TYPE_OP 7'b0010111
`define LU_TYPE_OP 7'b0110111


module HazardDetectionUnit(
	input idexreg_MemRead,
	input [4:0]idexreg_writeRegister,
	input [4:0]ifidreg_readRegister1,
	input [4:0]ifidreg_readRegister2,
	input [6:0]ifidreg_opcode,
	input exmemreg_MemRead,
	input [4:0]exmemreg_writeRegister,
	input idexreg_RegWrite,
	
	output reg PCWrite,
	output reg IFIDWrite,
	output reg Clear
);

wire branch_or_jalr;
wire idex_op;
wire alu_op;
wire mem_op;
wire load_op;
assign branch_or_jalr = ifidreg_opcode == `SB_TYPE_OP || ifidreg_opcode == `JI_TYPE_OP;
assign idex_op = idexreg_writeRegister == ifidreg_readRegister1 || idexreg_writeRegister == ifidreg_readRegister2;
assign alu_op = idexreg_RegWrite && idex_op;
assign mem_op = exmemreg_MemRead && (exmemreg_writeRegister == ifidreg_readRegister1 || exmemreg_writeRegister == ifidreg_readRegister2);
assign load_op = idexreg_MemRead && ifidreg_opcode != `S_TYPE_OP && idex_op;

/*
always@(*)
begin
	if ((ifidreg_opcode == `SB_TYPE_OP || ifidreg_opcode == `JI_TYPE_OP) && ((idexreg_RegWrite && ~idexreg_MemRead) && (idexreg_writeRegister == ifidreg_readRegister1 || 
	idexreg_writeRegister == ifidreg_readRegister2)))
	begin
		PCWrite <= 1'b0;
		IFIDWrite <= 1'b0;
		Clear <= 1'b1;
		$display("alu Hazard detected!");
	end
	else if ((ifidreg_opcode == 7'b1100011 || ifidreg_opcode == 7'b1100111) && 
	((idexreg_MemRead && (idexreg_writeRegister == ifidreg_readRegister1 || idexreg_writeRegister == ifidreg_readRegister2)) || 
	(exmemreg_MemRead && (exmemreg_writeRegister == ifidreg_readRegister1 || exmemreg_writeRegister == ifidreg_readRegister2))))
	begin
		PCWrite <= 1'b0;
		IFIDWrite <= 1'b0;
		Clear <= 1'b1;
		$display("mem Hazard detected!");
	end
	else if (idexreg_MemRead && ifidreg_opcode != 7'b0100011 &&
	(idexreg_writeRegister == ifidreg_readRegister1 || idexreg_writeRegister == ifidreg_readRegister2))
	begin 
		PCWrite <= 1'b0;
		IFIDWrite <= 1'b0;
		Clear <= 1'b1;
		$display("Hazard detected!");
	end
	else 
	begin
		PCWrite <= 1'b1;
		IFIDWrite <= 1'b1;
		Clear <= 1'b0;
	end
end
*/
always@(*)
begin
    if ((branch_or_jalr && (alu_op || mem_op)) || load_op)
    begin
        PCWrite <= 1'b0;
		IFIDWrite <= 1'b0;
		Clear <= 1'b1;
		$display("Hazard detected!");
    end
	else 
	begin
		PCWrite <= 1'b1;
		IFIDWrite <= 1'b1;
		Clear <= 1'b0;
	end
end
	   


endmodule
