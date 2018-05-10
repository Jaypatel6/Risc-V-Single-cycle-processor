`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: Datapath
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

module Datapath #(
    parameter PC_W = 9, // Program Counter
    parameter INS_W = 32, // Instruction Width
    parameter RF_ADDRESS = 5, // Register File Address
    parameter DATA_W = 32, // Data WriteData
    parameter DM_ADDRESS = 9, // Data Memory Address
    parameter ALU_CC_W = 4 // ALU Control Code Width
    )(
    input logic clk , reset , // global clock
                              // reset , sets the PC to zero
    RegWrite , MemtoReg ,     // Register file writing enable   // Memory or ALU MUX
    ALUsrc , MemWrite ,       // Register file or Immediate MUX // Memroy Writing Enable
    MemRead ,                 // Memroy Reading Enable
    Branch ,	      // Branch for if its branch and BranchSig if branch taken or not that controls the PC
    Jump,	     // 
    Jalr,
    AUI, 
    input logic [ ALU_CC_W -1:0] ALU_CC, // ALU Control Code ( input of the ALU )
    output logic [6:0] opcode,
    output logic [6:0] Funct7,
    output logic [2:0] Funct3,
    output logic [DATA_W-1:0] WB_Data, //ALU_Result
    output logic [DATA_W-1:0] AUIPC_Data,
    output logic [DATA_W-1:0] Jumpadd,
    output logic [DATA_W-1:0] JALRadd, 
    output logic [DATA_W-1:0] jalrplus4add,
    output logic BranchSig
    );

logic [PC_W-1:0] PC, PCPlus4,PcImm,NewPc,JumpPc,JalrPc;
logic [INS_W-1:0] Instr;
logic [DATA_W-1:0] Result;
logic [DATA_W-1:0] Reg1, Reg2;
logic [DATA_W-1:0] ReadData;
logic [DATA_W-1:0] SrcB, ALUResult;
logic [DATA_W-1:0] ExtImm, FinalExtImm, JumpExtImm,JalrExtImm;

// next PC
    adder #(9) pcadd (PC, 9'b100, PCPlus4);

    adder #(9) branch_add (PC,ExtImm[8:0], PcImm); //added offset for branch(PC+ imm), JAL

    //mux2 #(9) jump_mux(PCPlus4, PcImm, Jump, JumpPc);  //New address for next instruction based on jump signal 

    //mux2 #(9) jalrmux(NewPc, JALRadd[8:0], Jump,JalrPc);


    andgate checkBranch(Branch,ALUResult, BranchSig); // only 1 when branch instrution is true
    
    mux2 #(9) branch_mux(PCPlus4, PcImm, BranchSig, NewPc); // New address of instruction based on branch signal

    flopr #(9) pcreg(clk, reset, NewPc, PC);

 //Instruction memory
    instructionmemory instr_mem (PC, Instr);
    
    assign opcode = Instr[6:0];
    assign Funct7 = Instr[31:25];
    assign Funct3 = Instr[14:12];
      
// //Register File
    RegFile rf(clk, reset, RegWrite, Instr[11:7], Instr[19:15], Instr[24:20],
            Result, Reg1, Reg2);
            
    mux2 #(32) resmux(ALUResult, ReadData, MemtoReg, Result);
           
//// sign extend
    imm_Gen Ext_Imm (Instr,ExtImm); //original immediate

//// ALU
    adder32b #(32) auiadd(ExtImm, PC, AUIPC_Data); //PC+imm

    adder #(32) Jalradd(Reg1, ExtImm, JALRadd); //reg1+imm 

    adder32b #(32) Jalraddplus4(JALRadd, 9'b100, jalrplus4add); //reg1+imm+4
   
    adder #(9) jumpadd(AUIPC_Data[8:0],9'b100, Jumpadd); //PC+imm+4
    
    mux2 #(32) jalmux(AUIPC_Data, Jumpadd, Jump, JumpExtImm); // 0: PC+imm 1: PC+imm+4 , JAl

    mux2 #(32) jalrmux(JumpExtImm, jalrplus4add, Jalr, JalrExtImm); // 0: previousmuxoutput 1: reg1+imm+4
 
    mux2 #(32) auimux(ExtImm, JalrExtImm, AUI, FinalExtImm);  // 0: originalimmediate 1: previous mux

    mux2 #(32) srcbmux(Reg2, FinalExtImm, ALUsrc, SrcB); //0: reg2, 1: immediate

    alu alu_module(Reg1, SrcB, ALU_CC, ALUResult);
    
    assign WB_Data = Result;
    
////// Data memory 
    datamemory data_mem (clk, MemRead, MemWrite,Funct3, ALUResult[DM_ADDRESS-1:0], Reg2, ReadData);

///for jump
    //mux2 #(9) jumpmux(ALUResult[8:0], PCPlus4,Jump,JumpPc); 
endmodule
