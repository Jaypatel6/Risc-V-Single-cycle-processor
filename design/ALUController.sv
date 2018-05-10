`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: ALUController
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


module ALUController(
    
    //Inputs
    input logic [1:0] ALUOp,  //7-bit opcode field from the instruction
    input logic [6:0] Funct7, // bits 25 to 31 of the instruction
    input logic [2:0] Funct3, // bits 12 to 14 of the instruction
    
    //Output
    output logic [3:0] Operation //operation selection for ALU
);
 
 assign Operation[0]= (ALUOp==2'b11)|| ((ALUOp==2'b10) && (Funct3==3'b110)) || 
			((ALUOp==2'b10) && (Funct7==7'b0000000) && ((Funct3==3'b110) || (Funct3==3'b010) || (Funct3==3'b011) || (Funct3==3'b001))) ||
  			((ALUOp==2'b10) && (Funct7==7'b0100000) && (Funct3==3'b101)) || 
			((ALUOp==2'b01) && ((Funct3==3'b100) || (Funct3==3'b110) || (Funct3==3'b101)));

 assign Operation[1]= (ALUOp==2'b00) || ((ALUOp==2'b01) && (Funct3==3'b000)) || 
		     ((ALUOp==2'b01) && ((Funct3==3'b110) || (Funct3==3'b001) || (Funct3==3'b101))) ||
                     ((ALUOp==2'b10) && (Funct7==7'b0000000) && ((Funct3==3'b000) || (Funct3==3'b011) || (Funct3==3'b001))) ||
                     ((ALUOp==2'b10) && (Funct7==7'b0100000) && (Funct3==3'b000));
                    
 assign Operation[2]= (ALUOp==2'b11)|| 
			((ALUOp==2'b10) && (Funct7==7'b0100000) && (Funct3==3'b000)) || 
			((ALUOp==2'b01) && ((Funct3==3'b000) || (Funct3==3'b100) || (Funct3==3'b110) || (Funct3==3'b111) )) ||
			((ALUOp==2'b10) && (Funct7==7'b0000000) && ((Funct3==3'b100) || (Funct3==3'b010)|| (Funct3==3'b011)));

 assign Operation[3]= (ALUOp==2'b11)|| 
		      ((ALUOp==2'b10) && ((Funct7==7'b0000000) || (Funct7==7'b0100000)) && (Funct3==3'b101)) ||
		      ((ALUOp==2'b01) && ((Funct3==3'b000) ||(Funct3==3'b001) || (Funct3==3'b101) || (Funct3==3'b111)));

endmodule
