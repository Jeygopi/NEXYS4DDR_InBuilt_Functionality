`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2018 23:12:14
// Design Name: 
// Module Name: SSDDriver_REFINED
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


module SSDDriver_REFINED(
    input wire clk,
    input wire dClk,
    input wire activeDisplay,
    input wire state,
    output reg ssdNumber,
    output reg ssdAnode
    );
    
    always @(posedge dClk) begin
        if (state == 4'b0010) begin
            
        
endmodule
