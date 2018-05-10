`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:23:43 PM
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu#(
        parameter DATA_WIDTH = 32,
        parameter OPCODE_LENGTH = 4
        )(
        input logic [DATA_WIDTH-1:0]    SrcA,
        input logic [DATA_WIDTH-1:0]    SrcB,

        input logic [OPCODE_LENGTH-1:0]    Operation,
        output logic[DATA_WIDTH-1:0] ALUResult
        );
    
        always_comb
        begin
            ALUResult = 'd0;
            case(Operation)
            4'b0000:        // AND, ANDI
                    ALUResult = SrcA & SrcB;
            4'b0001:        //OR, ORI
                    ALUResult = SrcA | SrcB;
            4'b0010:        //ADD, ADDI
                    ALUResult = SrcA + SrcB;
            4'b0110:        //Sub , BEQ
                    ALUResult = $signed(SrcA) - $signed(SrcB);
		
		//for Lab2 instructions

   	    4'b0100:        //XOR,XORI
                    ALUResult = SrcA ^ SrcB;
   	    4'b0011:        //SLL, SLLI	
                    ALUResult = SrcA << SrcB[4:0];	

   	    4'b0101:        //SLT, SLTI , BLT
                    ALUResult = $signed(SrcA) < $signed(SrcB); //fix this

   	    4'b0111:        //SLTU, SLTIU , BLTU
                    ALUResult = $unsigned(SrcA) < $unsigned(SrcB); // fix this

   	    4'b1000:        //SRL, SRLI
                    ALUResult = SrcA >> SrcB[4:0];
   	    4'b1001:        //SRA, SRAI
                    ALUResult = SrcA >> $signed(SrcB[4:0]);
		
		//For Branches

	    4'b1010:        //BNE (($signed(SrcA) - $signed(SrcB)) !== 32'b0) ? 32'h00000001: 32'b0;
                    ALUResult = SrcA !== SrcB;
	    4'b1011:        //BGE
                    ALUResult = ((SrcA) >= $signed(SrcB)) ? 32'h00000001: 32'b0;
	    4'b1100:        //BGEU
                    ALUResult = ((SrcA) >= $unsigned(SrcB)) ? 32'h00000001: 32'b0;
	    4'b1110:        //BEQ
		    ALUResult = (SrcA == SrcB);

	    4'b1101:        //LUI, AUIPC, JAL, JALR 
                    ALUResult = SrcB;
            default:
                    ALUResult = 'b0;
            endcase
        end
endmodule
