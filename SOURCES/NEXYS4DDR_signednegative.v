`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.03.2018 14:31:51
// Design Name: 
// Module Name: NEXYS4DDR_signednegative
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

module tb;
  reg signed [8:0] a;
  reg [7:0] b;

  initial
    begin
      a = 9'b011111010;
      b = 8'b11111010;
      $display("a is %d and b is %d", a, b);
      a = 9'b100000110;
      b = ~b + 1;
      $display("a is %d and b is %d", a, b);
    end
endmodule
