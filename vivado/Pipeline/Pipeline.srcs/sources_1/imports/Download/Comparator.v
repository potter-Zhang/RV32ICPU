`include "Defines.v"

module Comparator(
	input [`DATA_WIDTH - 1:0] data1,
	input [`DATA_WIDTH - 1:0] data2,
	input sign,
	output Zero,
	output Less

);

assign Zero = data1 == data2;
assign Less = sign ? $signed(data1) < $signed(data2) : data1 < data2;
endmodule
