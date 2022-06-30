`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2018 19:23:13
// Design Name: 
// Module Name: TEST_singledisplay
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


module TEST_singledisplay(

    );
    reg mClk, rst, en;
    wire [6:0] ssdC;
    wire [7:0] ssdA;
    wire clk1hz;
    
    singleSevenSegmentDisplay_TOP UUT (
        .clk(mClk),
        .reset(rst),
        .enable(en),
        .ssdCathode(ssdC),
        .ssdAnode(ssdA),
        .clk_1Hz_reg(clk1hz)
    );
    
    initial begin
        mClk = 1;
        rst = 0;
        en = 1;
        
    end
    
    always begin
        #5
        mClk = ~mClk;
    end
endmodule
