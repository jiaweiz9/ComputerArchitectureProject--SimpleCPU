//mux2
module mux2 #(parameter WIDTH = 8)(d0, d1, s, y);
	input [WIDTH-1:0] d0, d1;
	input s;
	output [WIDTH-1:0] y;

	assign y = ( s == 1'b1 )? d1:d0;
endmodule
