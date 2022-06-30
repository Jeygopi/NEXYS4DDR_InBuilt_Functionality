`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2018 14:03:26
// Design Name: 
// Module Name: multipleSevenSegmentDisplays_TOP
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


module multipleSevenSegmentDisplays_TOP(
    input clk,
    input reset,
    input enable,
    output wire [6:0] ssdCathode,
    output reg [7:0] ssdAnode
    );
    clockDivider #(
        .THRESHOLD(50_000)
    ) clockDivider (
        .clk(clk),
        .reset(1'b0),
        .enable(1'b1),
        .dividedClk(clk_1Khz)
    );
    edgeDetector CLOCK_1KHZ_EDGE (
        .clk(clk),
        .signalIn(clk_1Khz),
        .signalOut(),
        .risingEdge(clk_1Khz_risingEdge),
        .fallingEdge()
    );
    
    reg [2:0] activeDisplay;
    
    always @(posedge clk_1Khz_risingEdge) begin
        if (activeDisplay >= 3'b111) begin
            activeDisplay <= 3'b000;
        end else
            activeDisplay <= activeDisplay + 3'b001;
    end
    reg [3:0] ssdNumber;
     always @(*) begin
        case(activeDisplay)
            3'd0 : begin
                ssdNumber <= 4'd6;
                ssdAnode <= 8'b1111_1110;
            end
            3'd1 : begin
                ssdNumber <= 4'd6;
                ssdAnode <= 8'b1111_1101;
            end    
            3'd2 : begin
                ssdNumber <= 4'd7;
                ssdAnode <= 8'b1111_1011;
            end
            3'd3 : begin
                ssdNumber <= 4'd0;
                ssdAnode <= 8'b1111_0111;
            end
            3'd4 : begin
                ssdNumber <= 4'd9;
                ssdAnode <= 8'b1110_1111;
            end
            3'd5 : begin 
                ssdNumber <= 4'd1;
                ssdAnode <= 8'b1101_1111;
            end
            3'd6 : begin
                ssdNumber <= 4'd5;
                ssdAnode <= 8'b1011_1111;
            end
            3'd7 : begin
                ssdNumber <= 4'd10;
                ssdAnode <= 8'b0111_1111;
            end
            default : begin
                ssdNumber <= 4'd15;
                ssdAnode <= 8'b1111_1111;
            end
        endcase
    end
    
    sevenSegmentDecoder SSD (
        .bcd(ssdNumber),
        .ssd(ssdCathode)
    );
            
                    
                
endmodule

