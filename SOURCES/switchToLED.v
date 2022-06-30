`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.02.2018 14:18:19
// Design Name: 
// Module Name: switchToLED
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


module switchToLED (
    input wire [15:0] switch,
    output reg [15:0] led
);
    always @(*) begin : bitReversal
        integer i;
        for (i=0; i<=15; i=i+1)
            led[15-i] = switch[i];
    
    end
endmodule
