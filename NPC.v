`include "decode.v"

module PC(NPC, PC);
  input [31:0] NPC;
  output reg [31:0] PC;
  
  always @(*) begin 
    PC = NPC;
  end
  
endmodule


module NPC(PC, NPCop, IMM, readAddress, NPC);
  input [31:0] PC;
  input [1:0]  NPCop; 
  input [25:0] IMM;
  input [31:0] readAddress;
  output reg [31:0] NPC; 
  
  wire [31:0] PCPLUS4;
  
  assign PCPLUS4 = PC + 4;
  always @(*) begin    
    case (NPCop)
      `NPC_PLUS4:  NPC = PCPLUS4;
      `NPC_BRANCH: NPC = PCPLUS4 + {{14{IMM[15]}},IMM[15:0],2'b00};
      `NPC_JUMP:   NPC = {PCPLUS4[31:28],IMM[25:0],2'b00};
      `NPC_JR:     NPC = readAddress;
      default:     NPC = PCPLUS4;
    endcase
  end
endmodule
