`timescale 1ns / 1ps

module adder32b
    #(parameter WIDTH = 32)
    (input logic [WIDTH-1:0] a,
	input logic [ 8:0] b,
     output logic [WIDTH-1:0] y);


assign y = a + b;

endmodule
