`include "Defines.v"

module RegisterFile(
	input clk,
	input RegWrite,
	input [4:0]ReadRegister1,
	input [4:0]ReadRegister2,
	input [4:0]WriteRegister,
	input [`DATA_WIDTH - 1:0]WriteData,
	output	[`DATA_WIDTH - 1:0]ReadData1,
	output [`DATA_WIDTH - 1:0]ReadData2
);

reg [`DATA_WIDTH - 1:0]registers[31:0];
reg [`DATA_WIDTH - 1:0]rd1;
reg [`DATA_WIDTH - 1:0]rd2;

//always @(negedge clk)
//begin
//	rd1 <= (ReadRegister1 != 0) ? registers[ReadRegister1] : 0;
//	rd2 <= (ReadRegister2 != 0) ? registers[ReadRegister2] : 0;
//end

always @(posedge clk)
begin
	if (RegWrite && WriteRegister != 0)
	begin
		registers[WriteRegister] <= WriteData;
	end
		
end

assign ReadData1 = (ReadRegister1 != 0) ? registers[ReadRegister1] : 0;
assign ReadData2 = (ReadRegister2 != 0) ? registers[ReadRegister2] : 0;


endmodule
	
