`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2018 18:58:11
// Design Name: 
// Module Name: ReactionTimer_TOP_Refined
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


module ReactionTimer_TOP_Refined(
    input wire clk,
    input wire reset,
    input wire startBtn,
    input wire testmodeBtn,
    output wire [15:0] led,
    output wire [6:0] ssdCathode,
    output reg [7:0] ssdAnode
    );
    
    
    debouncer START_BTN_DEBOUNCER (
        .clk(clk),
        .buttonIn(startBtn),
        .buttonOut(startBtn_dB)
    );
        
    debouncer TESTMODE_BTN_DEBOUNCER (
        .clk(clk),
        .buttonIn(testmodeBtn),
        .buttonOut(testmodeBtn_dB)
    );    
    
    clockDivider #(
        .THRESHOLD(50_000_000)
    ) clockD (
        .clk(clk),
        .reset(1'b0),
        .enable(1'b1),
        .dividedClk(dClk)
    );
    
    reg [1:0] activeDisplay;
    
    always @(posedge dClk) begin
        if (activeDisplay >= 2'b11) begin
            activeDisplay <= 2'b00;
        end else begin
            activeDisplay <= activeDisplay + 2'b01;
        end
    end
    
    reg [3:0] ssdNumber;
    always @(posedge clk) begin
        case(activeDisplay)
            2'd0 : begin
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
        endcase
    end
    
    sevenSegmentDecoder SSD (
        .bcd(ssdNumber),
        .ssd(ssdCathode)
    );
    
endmodule
