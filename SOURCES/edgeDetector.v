`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.03.2018 13:03:02
// Design Name: 
// Module Name: edgeDetector
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


module edgeDetector(
    input clk,
    input signalIn,
    output wire signalOut,
    output reg risingEdge,
    output reg fallingEdge
    );
    reg [1:0] pipeline;
    
    always @(posedge clk) begin
          pipeline[1] <= pipeline[0];
          pipeline[0] <= signalIn;
       //non blocking assignments <= , takes the value of the input before the current
       //clock step, checks for this later 
       // pipeline[0] = 0;
    end
    
    always @(*) begin
        if (pipeline == 2'b01) begin
            risingEdge = 1;
            fallingEdge = 0;
            end
        else if (pipeline == 2'b10) begin
            fallingEdge = 1;
            risingEdge = 0;
            end
        else begin
            risingEdge = 0;
            fallingEdge = 0; 
            end
    end

    
    assign signalOut = pipeline[1];
endmodule
