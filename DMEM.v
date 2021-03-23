module DMEM(clk, address, WriteData, MemWrite, MemRead, ReadData);
   input clk;
   input [31:0] address;
   input [31:0] WriteData;
   input MemWrite;
   input MemRead;
   output [31:0] ReadData;

   reg [31:0] DROM [31:0];

     always@(posedge clk)
	if(MemWrite)begin
	assign DROM[address[6:2]] = WriteData;
	end

	if(MemRead)begin
	assign ReadData = DROM[address[6:2]];
	end
     end
endmodule
