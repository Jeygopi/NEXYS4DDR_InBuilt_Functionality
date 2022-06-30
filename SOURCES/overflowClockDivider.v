`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2018 15:08:41
// Design Name: 
// Module Name: overflowClockDivider
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


module overflowClockDivider(
    input wire clk,
    input wire reset,
    input wire enable,
    output wire dividedClk
    );
    reg [26:0] counter;
    always @(posedge clk) begin
        if (reset == 1) begin
            counter = 0;
        end else if (enable == 1) begin
            counter = counter + 1;
        end
    end
    assign dividedClk = counter[26];
endmodule
