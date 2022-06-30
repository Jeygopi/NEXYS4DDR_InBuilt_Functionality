`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.03.2018 14:27:05
// Design Name: 
// Module Name: TEST_edgeDetector
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


module TEST_edgeDetector(
    
    );
    reg mClk, SigIn;
    wire rEdge, fEdge, SigOut;
    
    edgeDetector UUT (
            .clk(mClk),
            .signalIn(SigIn),
            .risingEdge(rEdge),
            .fallingEdge(fEdge),
            .signalOut(SigOut)
    );
    
    initial begin
        mClk = 1;
        SigIn = 0;
        
        #100
        SigIn = 1;
        
        #200
        SigIn = 0;
        
        #300
        SigIn = 1;
        
        #400 
        SigIn = 0;
        
        #1_000_000_000
        SigIn = 0;
        
        #1_500_000_000
        SigIn = 1;
        
    end
    
    always begin
            #5
            mClk = ~mClk;
    end
endmodule
