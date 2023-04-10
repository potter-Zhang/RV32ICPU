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

always@(*)
begin
	if ((ifidreg_opcode == 7'b1100011 || ifidreg_opcode == 7'b1100111) && ((idexreg_RegWrite && ~idexreg_MemRead) && (idexreg_writeRegister == ifidreg_readRegister1 || 
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


endmodule
