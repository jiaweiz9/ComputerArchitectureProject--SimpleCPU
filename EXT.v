module Extend(orImm, EXTOp, exImm);
       input [15:0] orImm;
       input EXTOp;
       output[31:0] exImm;
	
	assign exImm = (EXTOp == 1'b1)? {{16{orImm[15]}},orImm[15:0]}: 32'd0;
endmodule
