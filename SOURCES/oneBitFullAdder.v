`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.02.2018 15:25:08
// Design Name: 
// Module Name: oneBitFullAdder
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


module oneBitFullAdder(
    input X,
    input Y,
    input carryIn,
    output Z,
    output carryOut
);
    wire V;
    assign V = X^Y;
    assign Z = carryIn^V;
    assign carryOut = (X & Y) | (carryIn & V);
endmodule
