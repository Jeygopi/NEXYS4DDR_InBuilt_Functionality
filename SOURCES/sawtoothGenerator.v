`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2018 20:47:57
// Design Name: 
// Module Name: sawtoothGenerator
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


module sawtoothGenerator(
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [22:0] frequency,
    input wire [7:0] amplitude,
    output wire [7:0] sawtoothOut    
    );
    
    reg [31:0] accumulator;
    
    always @(posedge clk) begin
        if (reset) begin
            accumulator = 32'd0;
        end else begin
            accumulator = accumulator + frequency;
        end
    end
    
    wire [7:0] truncatedAccumulator;
    reg [15:0] multiplication;
    
    assign truncatedAccumulator = accumulator[31:24];
    
    always @(posedge clk) begin
        multiplication <= truncatedAccumulator*amplitude;
    end
    
    
    assign sawtoothOut =  multiplication[15:8] + 1;
    
    
endmodule
