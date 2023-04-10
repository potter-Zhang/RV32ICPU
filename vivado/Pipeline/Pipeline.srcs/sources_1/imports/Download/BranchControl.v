module BranchControl(
	input [4:0]Branch,
	input [1:0]LessZero,
	output out
);


assign out = Branch[0] == 1'b1 ? (~Branch[4] | ~(LessZero[Branch[2]] ^ Branch[1])) : 0;

endmodule
