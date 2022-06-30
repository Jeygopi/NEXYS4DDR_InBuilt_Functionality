`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2018 03:42:39
// Design Name: 
// Module Name: Reaction_timer_TEST
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


module Reaction_timer_TEST(

    );
    
    reg mClk, rst, en;
        wire dClk;
            
            clockDivider #(
                .THRESHOLD(50000)
                ) UUT ( 
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
