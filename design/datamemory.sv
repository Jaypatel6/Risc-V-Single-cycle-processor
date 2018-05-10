`timescale 1ns / 1ps

module datamemory#(
    parameter DM_ADDRESS = 9 ,
    parameter DATA_W = 32
    )(
    input logic clk,
    input logic MemRead , // comes from control unit
    input logic MemWrite , // Comes from control unit
    input logic [2:0] Funct3, // bits 12 to 14 of the instruction
    input logic [ DM_ADDRESS -1:0] a , // Read / Write address - 9 LSB bits of the ALU output
    input logic [ DATA_W -1:0] wd , // Write Data
    output logic [ DATA_W -1:0] rd // Read Data
    );
    
    logic [DATA_W-1:0] mem [(2**DM_ADDRESS)-1:0];
    
    always_comb 
    begin
       if(MemRead)
	    rd = mem[a];
	    case(Funct3)
	    3'b000: //LB, 8bit and signextend
            	rd = {rd[8]? 24'hffffff: 24'b0, rd[7:0]};
	    3'b001: //LH, 16 bit and signextend
            	rd = {rd[15]? 16'hffff: 16'b0, rd[15:0]};
	    3'b010: //LW, 32 bit
            	rd = {rd[31:12], rd[11:0]};
	    3'b100: //LBU, 8 bit and zeroextend
            	rd = {24'b0, rd[7:0]};
  	    3'b101: //LHU, 16 bit and zeroextend
            	rd = {16'b0, rd[15:0]};
	    default: //default case
                rd = mem[a];
            endcase
	end
    
    always @(posedge clk) begin
       if (MemWrite)
            //mem[a] = wd;
	    case(Funct3)
	    3'b000: //SB
            	mem[a] = {wd[8]? 24'hffffff: 24'b0, wd[7:0]};
	    3'b001: //SH
            	mem[a] = {wd[15]? 16'hffff: 16'b0, wd[15:0]};
	    3'b010: //SW
             	mem[a] = {wd[31:0]};
	    default:
                mem[a] = wd;
            endcase
    end
    
endmodule

