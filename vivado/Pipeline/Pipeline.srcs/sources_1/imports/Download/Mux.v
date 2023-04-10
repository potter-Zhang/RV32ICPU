`define DATA_WIDTH 32

module Mux(
	input control,
	input [`DATA_WIDTH - 1:0] data1,
	input [`DATA_WIDTH - 1:0] data2,
	output [`DATA_WIDTH - 1:0] out
);

assign out = (control == 1'b1) ? data2 : data1;

endmodule
