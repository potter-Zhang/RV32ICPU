`define REG_ADDR_WIDTH 5
module BranchForwardingUnit(
	input [`REG_ADDR_WIDTH - 1:0] memwbreg_writeRegister,
	input [`REG_ADDR_WIDTH - 1:0] exmemreg_writeRegister,
	input memwbreg_RegWrite,
	input exmemreg_RegWrite,
	input [`REG_ADDR_WIDTH - 1:0] ifidreg_readRegister1,
	input [`REG_ADDR_WIDTH - 1:0] ifidreg_readRegister2,
	output reg[1:0] BForwardA,
	output reg[1:0] BForwardB

);

/*
always@(*)
begin
	if (idexreg_RegWrite && idexreg_writeRegister != 0 && idexreg_writeRegister == ifidreg_readRegister1)
		BForwardA <= 2'b10;
	else if (exmemreg_RegWrite && exmemreg_writeRegister != 0 && exmemreg_writeRegister == ifidreg_readRegister1)
		BForwardA <= 2'b01;
	else 
		BForwardA <= 2'b00;
	if (idexreg_RegWrite && idexreg_writeRegister != 0 && idexreg_writeRegister == ifidreg_readRegister2)
		BForwardB <= 2'b10;
	else if (exmemreg_RegWrite && exmemreg_writeRegister != 0 && exmemreg_writeRegister == ifidreg_readRegister2)
		BForwardB <= 2'b01;
	else 
		BForwardB <= 2'b00;
	
end
*/

always@(*)
begin
	if (exmemreg_RegWrite && exmemreg_writeRegister != 0 && exmemreg_writeRegister == ifidreg_readRegister1)
		BForwardA <= 2'b10;
	else if (memwbreg_RegWrite && exmemreg_writeRegister != 0 && memwbreg_writeRegister == ifidreg_readRegister1)
		BForwardA <= 2'b01;
	else 
		BForwardA <= 2'b00;
	if (exmemreg_RegWrite && exmemreg_writeRegister != 0 && exmemreg_writeRegister == ifidreg_readRegister2)
		BForwardB <= 2'b10;
	else if (memwbreg_RegWrite && memwbreg_writeRegister != 0 && memwbreg_writeRegister == ifidreg_readRegister2)
		BForwardB <= 2'b01;
	else 
		BForwardB <= 2'b00;
	
end




endmodule
