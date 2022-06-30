`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2018 02:33:42
// Design Name: 
// Module Name: TEST_Integerclockdivider
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


module TEST_Integerclockdivider(

    );
    reg mClk, rst, en;
    wire dClk;
        
        clockDivider #(
            .THRESHOLD(50_000_000)
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
