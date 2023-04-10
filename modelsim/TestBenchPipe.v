`timescale 1ns/1ns
module TestBenchPipe;

reg clk;
reg rst;
wire [31:0] A;
wire [31:0] B;
wire [31:0] aluout;
wire [31:0]pc;
wire jump;
reg [31:0] instr[99:0];
reg [31:0] mem[99:0];
integer i, j;


initial 
begin
	$readmemh("D:/Harry/Download/sim_tb.txt", instr);
	//scp.im.memory[1] = instr[0][15:8];
	for (i = 0; i < 99; i = i + 1)
		{{ppl.im.memory[i * 4 + 3]}, {ppl.im.memory[i * 4 + 2]}, {ppl.im.memory[i * 4 + 1]}, 
			{ppl.im.memory[i * 4]}} = instr[i];
	
	rst = 1'b0;
	
	for (i = 0; i < 32; i = i + 1)
		ppl.rf.registers[i] <= i;
	//scp.im.memory[1] <= 32'hffffffff;
	
	$readmemh("D:/Harry/Download/mem_tb.txt", mem);
	for (i = 0; i < 99; i = i + 1)
		{{ppl.dm.memory[i * 4 + 3]}, {ppl.dm.memory[i * 4 + 2]}, {ppl.dm.memory[i * 4 + 1]}, 
			{ppl.dm.memory[i * 4]}} = mem[i];
	
	rst <= 1'b1;
	clk <= 1'b0;
	j <= 0;
	#5;
	rst <= 1'b0;
	
	//clk = 1'b0;
	
end

always begin
#20 clk = ~clk;
$display("clk: %d\n", j);
for (i = 0; i <= 8; i = i + 1)
	$display("reg %d = %h ", i, $signed(ppl.rf.registers[i]));
$display("reg %d = %h ", 30, $signed(ppl.rf.registers[30]));
$display("reg %d = %h ", 31, $signed(ppl.rf.registers[31]));

for (i = 0; i < 30; i = i + 4)
begin
$display("mem = %h", {ppl.dm.memory[i + 3],ppl.dm.memory[i + 2],ppl.dm.memory[i + 1],ppl.dm.memory[i]});
end


j = j + 1;
end

Pipeline ppl(.clk(clk), .rst(rst), .aluA(A), .aluB(B),/*.reg1(reg1), .reg2(reg2), */.aluout(aluout) /*,.pcin(pc), .jump(jump)*/);
	
endmodule
