`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2018 19:05:06
// Design Name: 
// Module Name: TEST_ReactionTimer_REFINED
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


module TEST_ReactionTimer_REFINED(

    );
    
    reg mClk, rst, sB, tB;
    wire [15:0] le;
    wire [6:0] ssdC;
    wire [7:0] ssdA;
    
    ReactionTimer_TOP_Refined UUT (
        .clk(mClk),
        .reset(rst),
        .startBtn(sB),
        .testmodeBtn(tB),
        .led(le),
        .ssdCathode(ssdC),
        .ssdAnode(ssdA)
    );
    
    initial begin
        mClk = 1;
        rst = 1;
        
        #22
        rst = 0;
        
    end
    
    always begin
        #5
        mClk = ~mClk;
    end
    
endmodule
