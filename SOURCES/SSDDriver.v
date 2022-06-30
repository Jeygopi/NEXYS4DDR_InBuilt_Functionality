`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2018 15:59:02
// Design Name: 
// Module Name: SSDDriver
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


module SSDDriver(
    input wire clk,
    input wire CA,
    input wire CB,
    input wire CC,
    input wire CD,
    input wire activeD,
    output reg [7:0] ssA,
    output wire [6:0] ssC
    );
    reg [3:0] ssdNumber; 
    clockDivider #(
            .THRESHOLD(50_000)
        ) clockDivider (
            .clk(clk),
            .reset(1'b0),
            .enable(1'b1),
            .dividedClk(clk_1kHZ)
        );
            
        edgeDetector CLOCK_1KHZ_EDGE ( 
            .clk(clk),
            .signalIn(clk_1kHZ),
            .signalOut(),
            .risingEdge(clk_1kHZ_risingEdge),
            .fallingEdge()
        );
    always @(posedge clk_1kHZ_risingEdge) begin
            case (activeD)
                2'd0 : begin
                    ssdNumber <= CA;
                    ssA <= 8'b1111_1110;
                end
                2'd1 : begin
                    ssdNumber <= CB;
                    ssA <= 8'b1111_1101;
                end
                2'd2 : begin
                    ssdNumber <= CC;
                    ssA <= 8'b1111_1011;
                end
                2'd3 : begin
                    ssdNumber <= CD;
                    ssA <= 8'b1111_0111;
                end
                default : begin
                    ssdNumber <= 4'd13;
                    ssA <= 8'b1111_1111;
                end
            endcase
    end
    
    sevenSegmentDecoder SevSD (
        .bcd(ssdNumber),
        .ssd(ssdC)
    ); 
endmodule
