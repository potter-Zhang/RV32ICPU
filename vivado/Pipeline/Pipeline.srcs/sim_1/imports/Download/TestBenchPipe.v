`timescale 1ns/1ns
`define LW 32'hFFFF0004
`define SW 32'hFFFF000C
module TestBenchPipe;

reg clk;
reg rst;
wire [31:0] A;
wire [31:0] B;
wire [31:0] aluout;
wire [31:0]pc = ppl.pc.pcout;

//reg [31:0] instr[99:0];
//reg [31:0] mem[99:0];
integer i, j;
reg[9:0] lw;
reg[14:0] sw; 
reg [31:0]display;


initial 
begin
	//$readmemh("D:/Harry/Download/sim_tb.txt", instr);
	//scp.im.memory[1] = instr[0][15:8];
	//for (i = 0; i < 99; i = i + 1)
		//{{ppl.im.memory[i * 4 + 3]}, {ppl.im.memory[i * 4 + 2]}, {ppl.im.memory[i * 4 + 1]}, 
			//{ppl.im.memory[i * 4]}} = instr[i];
	sw = 15'b00111_00000_00000;
	rst = 1'b1;
	clk = 1'b0;
	#5
	clk = 1'b1;
	rst = 1'b0;
	#5
	clk = 1'b0;
	#5
	clk = 1'b1;
	for (i = 0; i < 32; i = i + 1)
		ppl.rf.registers[i] <= i;
//    for (i = 0; i < 512; i = i + 1)
//        ppl.dm.memory[i] = 0;

    lw = 9'b000000100;
    //{ppl.dm.memory[lw+3], ppl.dm.memory[lw+2], ppl.dm.memory[lw+ 1], ppl.dm.memory[lw]} = 32'h01_02_03_04;
    //sw = 9'b000001100;
   // cpu.sw_i_addr = `LW;
    
    
    //$display("mem = %h", {ppl.dm.memory[lw+3], ppl.dm.memory[lw+2], ppl.dm.memory[lw + 1], ppl.dm.memory[lw]});
    //$display("mem = %h", {ppl.dm.memory[lw - 1], ppl.dm.memory[lw - 2], ppl.dm.memory[lw - 3], ppl.dm.memory[lw - 4]});
	//scp.im.memory[1] <= 32'hffffffff;
	
	//$readmemh("D:/Harry/Download/mem_tb.txt", mem);
	//for (i = 0; i < 99; i = i + 1)
	//	{{ppl.dm.memory[i * 4 + 3]}, {ppl.dm.memory[i * 4 + 2]}, {ppl.dm.memory[i * 4 + 1]}, 
	//		{ppl.dm.memory[i * 4]}} = mem[i];
	#5
	
	clk = 1'b0;
	j <= 0;
	#5;
	clk = 1'b1;
//	#5
	clk = 1'b0;
    #5
    clk = 1'b1;
    #5
    clk = 1'b0;
    #5
	rst = 1'b1;
	
	//clk = 1'b0;
	
end

always@(negedge clk)
begin
    if (ppl.dm.address == 32'hffff000c && ppl.dm.memWrite)
        display <= ppl.dm.writeData;
    else 
        display <= display;
     $display("write %h = %h\n", ppl.dm.address, ppl.dm.writeData);
end


always begin
#20 clk = ~clk;
$display("clk: %d\n", j);

for (i = 0; i <= 8; i = i + 1)
	$display("reg %d = %h ", i, $signed(ppl.rf.registers[i]));
	$display("reg %d = %h ", 15, $signed(ppl.rf.registers[15]));
$display("reg %d = %h ", 30, $signed(ppl.rf.registers[30]));
$display("reg %d = %h ", 31, $signed(ppl.rf.registers[31]));
$display("memoutdata = %h, outdata = %h", ppl.dm.memOutData, ppl.dm.outData);
$display("display = %h\n", display);
//for (i = 0; i < 30; i = i + 4)
//begin
//$display("mem = %h", {ppl.dm.memory[i + 3],ppl.dm.memory[i + 2],ppl.dm.memory[i + 1],ppl.dm.memory[i]});
//end
//$display("mem = %h", {ppl.dm.memory[lw + 3],ppl.dm.memory[lw + 2],ppl.dm.memory[lw + 1], ppl.dm.memory[lw]});


j = j + 1;
end

Pipeline ppl(.clk(clk), .rst(rst), .sw(sw));//, //.aluA(A), .aluB(B),/*.reg1(reg1), .reg2(reg2), */.aluout(aluout) /*,.pcin(pc), .jump(jump)*/);
	
endmodule
