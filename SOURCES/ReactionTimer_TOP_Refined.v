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
    input wire previousTimeBtn,
    output wire [15:0] led,
    output wire [6:0] ssdCathode,
    output wire [7:0] ssdAnode,
    output wire decimalPoint
    );
    
    //Debouncers for the system for all the push buttons used
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
    
    debouncer PREVIOUSTIME_BTN_DEBOUNCER (
        .clk(clk),
        .buttonIn(previousTimeBtn),
        .buttonOut(previousTimeBtn_dB)
    );       
    debouncer RESET_BTN_DB (
        .clk(clk),
        .buttonIn(reset),
        .buttonOut(reset_dB)
    );  
    
    //1 kHz clock divider used for seven segment displays and a lot of counting mechanisms 
    clockDivider #(
        .THRESHOLD(50_000)
    ) clockD1khz (
        .clk(clk),
        .reset(1'b0),
        .enable(1'b1),
        .dividedClk(dClk)
    );
    
    //main Finite State Machine associated with the system 
    ReactionTimer_FSM_Refined FSMRT (
        .clk(clk),
        .resetFSM(reset_dB),
        .clk_1kHz(dClk),
        .idletoPrep(startBtn_dB),
        .testtoResult(testmodeBtn_dB),
        .checkTime(previousTimeBtn_dB),
        .led(led),
        .ssdCathode(ssdCathode),
        .ssdAnode(ssdAnode),
        .DP(decimalPoint)
        );
        
endmodule
