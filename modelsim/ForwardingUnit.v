


module ForwardingUnit(
	input [4:0]exmemreg_writeRegister,
	input [4:0]memwbreg_writeRegister,
	input [4:0]idexreg_readRegister1,
	input [4:0]idexreg_readRegister2,
	input [4:0]exmemreg_readRegister2,
	input exmemreg_MemWrite,
	input memwbreg_MemRead,
	input exmemreg_RegWrite,
	input memwbreg_RegWrite,
	
	output reg[1:0] ForwardA,
	output reg[1:0] ForwardB,	
	output reg ForwardC
);

always@(*)
begin
	// EX
	if (exmemreg_RegWrite && exmemreg_writeRegister != 0 && exmemreg_writeRegister == idexreg_readRegister1)
		ForwardA <= 2'b10;
	else if (memwbreg_RegWrite && memwbreg_writeRegister != 0 && memwbreg_writeRegister == idexreg_readRegister1)
		ForwardA <= 2'b01;
	else 
		ForwardA <= 2'b00;
	if (exmemreg_RegWrite && exmemreg_writeRegister != 0 && exmemreg_writeRegister == idexreg_readRegister2)
		ForwardB <= 2'b10;
	else if (memwbreg_RegWrite && memwbreg_writeRegister != 0 && memwbreg_writeRegister == idexreg_readRegister2)
		ForwardB <= 2'b01;
	else 
		ForwardB <= 2'b00;

	// for (load then store)
	if (exmemreg_MemWrite && memwbreg_MemRead && memwbreg_writeRegister == exmemreg_readRegister2)
		ForwardC <= 1'b1;
	else 
		ForwardC <= 1'b0;
	
end



endmodule
