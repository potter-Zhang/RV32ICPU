`include "Defines.v"

module Mux_4(
	input [1:0] control,
	input [`DATA_WIDTH - 1:0] data1,
	input [`DATA_WIDTH - 1:0] data2,
	input [`DATA_WIDTH - 1:0] data3,
	input [`DATA_WIDTH - 1:0] data4,
	output [`DATA_WIDTH - 1:0] out
);

assign out = 	control[0] ? (control[1] ? data4 : data2) : (control[1] ? data3 : data1);
		

endmodule
