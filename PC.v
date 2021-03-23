module PC(input [31:0]npc, output [31:0]pc)
	always @(*) pc = npc;
endmodule
