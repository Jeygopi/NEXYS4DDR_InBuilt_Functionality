`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2018 23:46:17
// Design Name: 
// Module Name: TEST_waveformGenerator
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


module TEST_waveformGenerator(

    );
    
    reg clk_100MHz, rst, en; //describing input as regs because 
    //reg [15:0] increment; //we descirbe time varying behaviour with
    wire [7:0] waveformOut; //always and initial blocks
    wire waveformEnabled;
    reg [15:0] incr;
    waveformGenerator_TOP UUT (
        .clk(clk_100MHz),
        .reset(rst),
        .enable(en),
        .increment(incr),
        .waveform(waveformOut),
        .waveformEnabled(waveformEnabled)
    );
    
    always begin
        #5
        clk_100MHz = ~clk_100MHz;
    end
    
    initial begin
        clk_100MHz = 1;
        incr = 16'd21_475;
        rst = 1;
        en = 0;
        
        #123.45
        rst = 0;
        
        #321.9
        en = 1;
    end
endmodule
