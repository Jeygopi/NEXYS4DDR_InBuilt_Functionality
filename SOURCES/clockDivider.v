`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2018 16:22:35
// Design Name: 
// Module Name: clockDivider
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


module clockDivider #(
    parameter integer THRESHOLD = 50_000
)(
    input wire clk,
    input wire reset,
    input wire enable,
    output reg dividedClk //I think this output needs to be a wire because 
    //we're reusing it as a clock in the FSM module  
    );
    //assign enable = 1;
    reg [31:0] counter1;
        always @(posedge clk) begin
            if (reset == 1 || counter1 >= THRESHOLD-1) begin
                counter1 = 0;
            end else if (enable == 1) begin
                counter1 = counter1 + 1;
            end
        end
        
        always @(posedge clk) begin
            if (reset == 1) begin
                dividedClk = 0;
            end else if (counter1 >= THRESHOLD-1) begin
                dividedClk = ~dividedClk;
            end
        end
endmodule
