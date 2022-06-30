`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2018 18:44:24
// Design Name: 
// Module Name: reactiontimer_TOP
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


module reactiontimer_TOP(
    input wire clk,
    input wire reset,
    input wire enable,
    input wire startBtn,
    input wire testmodeBtn,
    output wire [15:0] led,
    //output [15:14] ledt,
    //output [13:12] ledu,
    output wire [6:0] ssdCathode,
    output wire [7:0] ssdAnode,
    output wire [3:0] CA,
    output wire [3:0] CB,
    output wire [3:0] CC,
    output wire [3:0] CD,
    output wire clk_1kHz
    //output reg [3:0] finalstate
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
    wire clk_1kHZ;
    wire clk_1kHZ_risingEdge;
    clockDivider #(
        .THRESHOLD(50_000)
    ) clockDivider (
        .clk(clk),
        .reset(1'b0),
        .enable(1'b1),
        .dividedClk(clk_1kHZ)
        );
    wire [15:0] lede;
    wire [15:14] ledet;
    wire [13:12] ledeu;
    wire [11:10] ledev;
    wire [6:0] ssdCathodee;
    wire [7:0] ssdAnodee;
    wire [3:0] fstate;
    reactiontimerFSM reactFSM (
        .clk(clk),
        .dclk(clk_1kHZ),
        .reset(reset),
        .idletoPrep(startBtn_dB),
        .testmodeBtn(testmodeBtn_dB),
        .led(led),
        .ssdAnode(ssdAnode),
        .ssdCathode(ssdCathode),
        .state(),
        .nextState(),
        .prepCounter(),
        .counter_a(CA),
        .counter_b(CB),
        .counter_c(CC),
        .counter_d(CD),
        .clk_1Hzt()
        //.state(fstate)
    );
    //assign led = lede;
    //assign ledt = ledet;
    //assign ledu = ledeu;
    //assign ledv = ledev;
    //reg [1:0] activeDisplay; //activedisplay might need to be in the top module 
    
        
    edgeDetector CLOCK_1KHZ_EDGE ( 
        .clk(clk),
        .signalIn(clk_1kHZ),
        .signalOut(),
        .risingEdge(clk_1kHZ_risingEdge),
        .fallingEdge()
    );
        
   
endmodule
