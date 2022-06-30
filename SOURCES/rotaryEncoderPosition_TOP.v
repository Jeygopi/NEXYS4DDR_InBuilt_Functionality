`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2018 19:50:21
// Design Name: 
// Module Name: rotaryEncoderPosition_TOP
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


module rotaryEncoderPosition_TOP(
    input clk,
    input reset,
    input enable,
    input A,
    input B,
    output wire [6:0] ssdCathode,
    output reg [7:0] ssdAnode
    );
    wire A_dB, B_dB;
    clockDivider #(
        .THRESHOLD(50_000)
    ) clockDivider (
        .clk(clk),
        .reset(1'b0),
        .enable(1'b1),
        .dividedClk(clk_1Khz)
    );
    edgeDetector CLOCK_1Khz_EDGE (
        .clk(clk),
        .signalIn(clk_1Khz),
        .signalOut(),
        .risingEdge(clk_1Khz_risingEdge),
        .fallingEdge()
    );
    latchDebouncer encoder_debouncer_A (
        .clk(clk),
        .inputSignal(~A),
        .debouncedSignal(A_dB) //A_dB and B_dB are both active high
    );
        
    latchDebouncer encoder_debouncer_B (
        .clk(clk),
        .inputSignal(~B),
        .debouncedSignal(B_dB)
    );
    wire Clockwise;
    wire counterClockwise;
    rotaryEncoder RE (
        .clk(clk),
        .reset(reset),
        .A(A_dB),
        .B(B_dB),
        .Clockwise(Clockwise),
        .counterClockwise(counterClockwise)
    );
    
    reg signed [4:0] encoderPosition;
    always @(posedge clk) begin
        if (Clockwise == 1'b1 && encoderPosition < 5'sd9) begin
            encoderPosition <= encoderPosition + 1'b1;
        end else if (counterClockwise == 1'b1 && encoderPosition > -5'sd9) begin
            encoderPosition <= encoderPosition - 1'b1;
        end else if (reset == 1) begin
            encoderPosition = 0;
        end
    end
    
    
    reg [3:0] minusSign;
    reg [3:0] absoluteEncoderPosition;
    
    always @(posedge clk) begin
        if (encoderPosition < 0) begin
            minusSign = 4'd15;
            absoluteEncoderPosition = -encoderPosition;
        end else if (encoderPosition >= 0) begin
            minusSign = 4'd14;
            absoluteEncoderPosition = encoderPosition;
        end
    end
    
    reg [1:0] activeDisplay;
    reg [3:0] ssdNumber;
    
    always @(posedge clk_1Khz_risingEdge) begin
        if (activeDisplay >= 2'b10) begin
            activeDisplay <= 2'b00;
        end else
            activeDisplay <= activeDisplay + 1'b1;
    end
    
    always @(*) begin
        case(activeDisplay)
            2'd0 : begin
                ssdNumber <= absoluteEncoderPosition;
                ssdAnode <= 8'b1111_1110;
            end
            2'd1 : begin
                ssdNumber <= minusSign;
                ssdAnode <= 8'b1111_1101;
            end
            default : begin
                ssdNumber <= 4'd13;
                ssdAnode <= 8'b1111_1111;
            end
        endcase
    end
    
    sevenSegmentDecoder SSD (
        .bcd(ssdNumber),
        .ssd(ssdCathode)
    );
endmodule
//generate new 1KHz clock there is a delay in the LED lighting up
//incorporate the condition for the knobs not going past 9 in same        