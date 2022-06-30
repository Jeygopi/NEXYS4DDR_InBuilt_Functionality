`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2018 14:24:30
// Design Name: 
// Module Name: rotaryEncoder
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


module rotaryEncoder(
    input clk,
    input reset,
    input A,
    input B,
    output reg Clockwise,
    output reg counterClockwise
    );
    wire A_dB_risingEdge, B_dB_risingEdge;
    
    edgeDetector ED_AdB (
        .clk(clk),
        .signalIn(A),
        .signalOut(),
        .risingEdge(A_dB_risingEdge),
        .fallingEdge()
    );
    
    edgeDetector ED_BdB (
        .clk(clk),
        .signalIn(B),
        .signalOut(),
        .risingEdge(B_dB_risingEdge),
        .fallingEdge()
    );
    
    always @(*) begin
        if (A_dB_risingEdge == 1 || B_dB_risingEdge == 1) begin
            if (A == 0 && B == 1) begin
                Clockwise <= 1'b1;
            end else if  (A == 1 && B == 0) begin
                counterClockwise <= 1'b1;
            end
        end else begin
            Clockwise <= 1'b0;
            counterClockwise <= 1'b0;
        end
    end
endmodule
