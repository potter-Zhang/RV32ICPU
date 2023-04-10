`define ADDR_WIDTH 32
`define PC_WIDTH 32
module PC(
	input clk,
	input rst,
	input en,
	input [`ADDR_WIDTH - 1:0] pcin,
	output reg [`ADDR_WIDTH - 1:0]pcout
);

reg [`PC_WIDTH - 1:0] pc;


always@(posedge clk)
begin
	pcout <= pc;
end


always@(negedge clk, negedge rst)
begin
	if (!rst)
	begin
		pc <= `PC_WIDTH'h00000000;
	end
	else if (en)
	begin
		pc <= pcin;	
	end
	else 
		pc <= pc;
	
end

endmodule
