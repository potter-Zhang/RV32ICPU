`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/29 15:45:06
// Design Name: 
// Module Name: Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define OP_NUM 6'b000001
`define PC 6'b000010
`define IR 6'b000011
`define WRITE_ADDR 6'b000100
`define WRITE_DATA 6'b000101
`define READ_DATA 6'b000110
`define READ_ADDR 6'b000111
`define CPU_DATA 6'b000000
`define LW 32'hFFFF0004
`define SW 32'hFFFF000C


module Top(
    input clk, 
    input rstn,
    input [15:0] sw_i,
    output [7:0] disp_an_o, disp_seg_o  
    );
reg[31:0] clkdiv;
wire Clk_CPU;
reg[31:0] display_data;
wire[9:0] sw= 9'b000001100;
reg [31:0]result;
initial begin
clkdiv <= 0;
end
always @ (posedge clk) 
     clkdiv <= clkdiv + 1'b1; 
     
     
assign Clk_CPU = (sw_i[15]) ? clkdiv[25] : clkdiv[1];

always@(negedge Clk_CPU)
begin
    if (cpu.dm.address == 32'hffff000c && cpu.dm.memWrite) begin
        result <= cpu.dm.writeData;  
   end
    else 
        result <= result;
end


always@ (*) begin
    if (sw_i[5] == 1'b1)
        display_data <= cpu.rf.registers[sw_i[4:0]];
    else if (sw_i[4] == 1'b1 || sw_i[3] == 1'b1)
        display_data <= -1;
    else
    case(sw_i[5:0])
        `OP_NUM: display_data <= (cpu.pcout >> 2);
        `PC: display_data <= cpu.pcout;
        `IR: display_data <= cpu.instruction;
        `WRITE_ADDR: display_data <= cpu.dm.addr;
        `WRITE_DATA: display_data <= cpu.dm.writeData;
        `READ_DATA: display_data <= cpu.dm.readData;
        `READ_ADDR: display_data <= cpu.dm.address;  
        `CPU_DATA: display_data <= result;//{cpu.dm.memory[sw + 3 ], cpu.dm.memory[sw  + 2], cpu.dm.memory[sw + 1], cpu.dm.memory[sw ]};
    endcase 
end
    Pipeline cpu(.clk(Clk_CPU), .rst(rstn), .sw(sw_i[14:0]));
    seg7x16 seg(.clk(clk), .rstn(rstn), .i_data(display_data), .disp_mode(1'b0), .o_seg(disp_seg_o), .o_sel(disp_an_o));
endmodule
