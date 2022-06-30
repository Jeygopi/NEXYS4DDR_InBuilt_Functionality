`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2018 15:20:06
// Design Name: 
// Module Name: TEST1_overflowClockDivider
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


module TEST1_overflowClockDivider(
    );
    reg mClk, rst, en;
    wire dClk;
    
    overflowClockDivider UUT ( 
        .clk(mClk),
        .reset(rst),
        .enable(en),
        .dividedClk(dClk)
    );
    
    initial begin
        mClk = 1;
        rst = 1;
        en = 0;
    
        #23.45
        rst = 0;
    
        #43.816
        en = 1;
    end
    
    always begin
        #5
        mClk = ~mClk;
    end
    
endmodule
