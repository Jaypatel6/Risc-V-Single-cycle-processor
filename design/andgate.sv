`timescale 1ns / 1ps

module andgate
    #(parameter WIDTH = 32)
    (input logic  a, 
     input logic [WIDTH-1:0] b,
     output logic  y);


assign y = a &&  b;

endmodule
