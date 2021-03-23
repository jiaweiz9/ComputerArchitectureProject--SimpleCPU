`include "decode.v"

module ctrl(Op, Funct, Zero, RegWrite, RegDst, WRSrc, MemWrite, MemRead, EXTOp, ALUOp, NPCOp, ALUSrc, jal, GPRSel, WDSel);
	input [5:0]Op;
	input [5:0]Funct;
	input Zero;    //branch

	output RegWrite;
	output RegDst;
	output WRSrc;
	output MemWrite;
	output MemRead;
	output EXTOp;
	output [2:0]ALUOp;
	output [1:0]NPCOp;
	output ALUSrc;
	output jal;

	output [1:0]GPRSel;
	output [1:0]WDSel;

	// R type
	wire rtype = ~|Op;   //op:000 000
	wire r_add = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]&~Funct[0];  //100 000
	wire r_addu= rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]& Funct[0];  //100 001
	
	wire r_sub = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]&~Funct[0];  //100 010
	wire r_subu= rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]& Funct[1];  //100 011
	
	wire r_and = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]&~Funct[1]&~Funct[0];  //100 100
	wire r_or  = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]&~Funct[1]& Funct[0];  //100 101
	wire r_nor = rtype& FuncE:/courses/computer/computerOrg_exp/ctrl.vt[5]&~Funct[4]&~Funct[3]& Funct[2]& Funct[1]& Funct[0];  //100 111
	
	wire r_slt = rtype& Funct[5]&~Funct[4]& Funct[3]&~Funct[2]& Funct[1]&~Funct[0];  //101 010
	wire r_sltu= rtype& Funct[5]&~Funct[4]& Funct[3]&~Funct[2]& Funct[1]& Funct[0];  //101 011

	wire r_sll = rtype&~Funct[5]&~Funct[4]&~Funct{3}&~Funct[2]&~Funct[1]&~Funct[0];  //000 000
	wire r_srl = rtype&~Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]&~Funct[0];  //000 010
	wire r_sllv= rtype&~Funct[5]&~Funct[4]&~Funct[3]& Funct[2]&~Funct[1]&~Funct[0];  //000 100
	wire r_srlv= rtype&~Funct[5]&~Funct[4]&~Funct[3]& Funct[2]& Funct[1]&~Funct[0];  //000 110

	wire r_jr  = rtype&~Funct[5]&~Funct[4]& Funct[3]&~Funct[2]&~Funct[1]&~Funct[0];  //001 000  ?
 	wire r_jalr= rtype&~Funct[5]&~Funct[4]& Funct[3]&~Funct[2]&~Funct[1]& Funct[0];  //001 001  ?

	//I type
	wire i_addi=~Op[5]&~Op[4]& Op[3]&~Op[2]&~Op[1]&~Op[0];  //op:001 000     

	wire i_andi=~Op[5]&~Op[4]& Op[3]& Op[2]&~Op[1]&~Op[0];  //op:001 100     
	wire i_ori =~Op[5]&~Op[4]& Op[3]& Op[2]&~Op[1]& Op[0];  //op:001 101     

	wire i_slti=~Op[5]&~Op[4]& Op[3]&~Op[2]& Op[1]&~Op[0];  //op:001 010     
    
	wire i_lw  = Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]& Op[0];  //op:100 011     ?
	wire i_rw  = Op[5]&~Op[4]& Op[3]&~Op[2]& Op[1]& Op[0];  //op:101 011     ?

	wire i_beq =~Op[5]&~Op[4]&~Op[3]& Op[2]&~Op[1]&~Op[0];  //op:000 100
	wire i_bne =~Op[5]&~Op[4]&~Op[3]& Op[2]&~Op[1]& Op[0];  //op:000 101     ?

	wire i_lui =~Op[5]&~Op[4]& Op[3]& Op[2]& Op[1]& Op[0];  //op:001 111     ?

	//J type
	wire  j_j  =~Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]&~Op[0];  //op:000 010      ?
	wire j_jal =~Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]& Op[1];  //op:000 011      ?

	assign RegWrite = r_add|i_addi|r_addu|r_sub|r_subu|r_and|i_andi|r_or|i_ori|r_nor|r_slt|r_sltu|r_sll|r_srl|r_sllv|r_srlv|i_lui;
 	assign MemWrite = i_sw;
	assign MemRead = i_lw;
	assign jal = j_jal|j_jalr;

	assign RegDst = i_addi|i_andi|i_ori|i_lw|i_sw|i_slti|i_lui;
	assign ALUSrc = i_addi|i_andi|i_ori|i_lw|i_sw|i_slti|i_beq|i_bnq|i_lui;
	assign WRSrc = i_lw;

	assign EXTOp = i_addi|i_andi|i_ori|i_lw|i_sw|i_slti|i_sltiu;

	always@(*) begin
		if(r_add|r_addu|i_addi|i_lw|i_sw) assign ALUOp = `ALU_ADD;
		if(r_sub|r_subu) assign ALUOp = `ALU_SUB;
		if(r_and|i_andi) assign ALUOp = `ALU_AND;
		if(r_or|i_ori) assign ALUOp = `ALU_OR;
		if(r_nor) assign ALUOp = `ALU_NOR;
		if(r_slt|i_slti) assign ALUOp = `ALU_SLT;
		if(r_sltu) assign ALUOp = `ALU_SLTU;
		if(r_sll) assign ALUOp = `ALU_SLL;
		if(r_srl) assign ALUOp = `ALU_SRL;
		if(r_sllv)assign ALUOp = `ALU_SLLV;
		if(r_srlv)assign ALUOp = `ALU_SRLV;
		if(i_lui) assign ALUOp = `ALU_LUI;
		
		if(j_jr|j_jalr) assign NPCOp = `NPC_JR;
		else if((i_beq&Zero)|(i_bne&~Zero)) assign NPCOp = `NPC_BRANCH;
		else if(j_j) assign NPCOp = `NPC_JUMP;
		else assign NPCOp = `NPC_PLUS4;
		end
endmodule


