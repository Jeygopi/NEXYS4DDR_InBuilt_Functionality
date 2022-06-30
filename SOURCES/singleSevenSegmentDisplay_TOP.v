`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.03.2018 12:56:40
// Design Name: 
// Module Name: singleSevenSegmentDisplay_TOP
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
//to error check route a wire up to the top module from sub module
//and set it as an input/output to check if its providing desired val
module singleSevenSegmentDisplay_TOP(
    input wire clk,
    input wire reset,
    input wire enable,
    output wire [6:0] ssdCathode,
    output wire [7:0] ssdAnode
    );
    wire reset1 = 0; 
    //feedback indicates that the system is sequential
    clockDivider #(
        .THRESHOLD(50_000_000)
    ) clockDivider (
        .clk(clk),
        .reset(reset1), // need to make inputs different, cant share the 
        .enable(enable), //same reset between the global 
        .dividedClk(clk_1Hz)
    );
    
    edgeDetector CLOCK_1HZ_EDGE (
        .clk(clk),
        .signalIn(clk_1Hz),
        .signalOut(),
        .risingEdge(clk_1Hz_risingEdge),
        .fallingEdge()
    );
    reg [3:0] counter;
        always @(posedge clk_1Hz_risingEdge) begin
            if (reset == 1 || counter >= 4'd9) begin 
                counter <= 4'd0;
            end else if (enable == 1 && reset == 0) begin
                counter <= counter + 4'b0001;
            end
        end
    wire [6:0] ssd;
    sevenSegmentDecoder SSD (
        .bcd(counter),
        .ssd(ssd)
    );    
    
    assign ssdAnode = 8'b1111_1110;
    assign ssdCathode = ssd;
endmodule
