`timescale 1ns / 1ps

module riscv #(
    parameter DATA_W = 32)
    (input logic clk, reset, // clock and reset signals
    output logic [31:0] WB_Data// The ALU_Result
    );

logic [6:0] opcode;
logic ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch,Jump,Jalr, AUI, BranchSig;

logic [31:0] AUIPC_Data;
logic [31:0] Jumpadd;
logic [31:0] JALRadd;
logic [31:0] jalrplus4add;
logic [1:0] ALUop;
logic [6:0] Funct7;
logic [2:0] Funct3;
logic [3:0] Operation;

    Controller c(opcode, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,Branch,Jump,Jalr,AUI, ALUop);
    
    ALUController ac(ALUop, Funct7, Funct3, Operation);

    Datapath dp(clk, reset, RegWrite , MemtoReg, ALUSrc , MemWrite, MemRead,Branch,Jump,Jalr, AUI, Operation, opcode, Funct7, Funct3,	   WB_Data,AUIPC_Data,Jumpadd,JALRadd,jalrplus4add, BranchSig);
        
endmodule
