module RF(input clk, input rst, input RFWr, input jal,
          input  [4:0] ReadR1,ReadR2,WriteR,
          input  [31:0] WD
          output [31:0] ReadD1, ReadD2,
          );
  reg [31:0] rf [31:0];  
  integer i;
  
  always @(posedge clk, posedge rst) 
    if(rst) begin
      for(i=1; i<32; i=i+1)
      rf[i] <= 0;
      end
    else
      if(RFWr) begin
	if(jal) rf[31] <= WD;
	else                 
        rf[WriteR] <= WD;
        $display("r[%2d] = 0x%8X,", Writer, WD);
      end
      
    assign ReadD1 = rf[ReadR1];
    assign ReadD2 = rf[ReadR2];

  end
  
endmodule
