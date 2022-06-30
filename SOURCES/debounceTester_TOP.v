`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2018 18:50:13
// Design Name: 
// Module Name: debounceTester_TOP
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


module debounceTester_TOP(
    input masterClk,
    input pushButton,
    output wire debouncedPushButton
    );
    
    clockDivider #(
        .THRESHOLD(50_000)
    ) debounceEnableGenerator (
        .clk(masterClk),
        .reset(1'b0),
        .enable(1'b1),
        .dividedClk(debounceEnable)
    );
    
    switchDebouncer pushButtonDebouncer (
        .clk(masterClk),
        .enable(debounceEnable),
        .buttonIn(pushButton),
        .buttonOut(debouncedPushButton)
    );
    
endmodule
