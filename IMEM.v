module IMEM(address, instruction, Naddress);
   input [31:0] address;
   output [31:0] instruction;
   output [31:0] Naddress;

   reg [31:0] IROM[31:0];

   assign instruction = IROM[address[6:2]];
   assign Naddress = address + 4;
endmodule
