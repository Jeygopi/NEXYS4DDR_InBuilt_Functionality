`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.04.2018 20:09:21
// Design Name: 
// Module Name: LSFR_TEST
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


module LSFR_TEST(

    );
    
    reg clk_tb;
    reg rst_tb;
    wire [11:0] out_tb;
    wire [12:0] outwithfourk;
    
    initial begin 
        clk_tb = 0;
        rst_tb = 1;
        #15;
        
        rst_tb = 0;
        #200;
        
        
        #400
        $display("outwithfourk = %d",outwithfourk);
    end
    
    always begin
        #5
        clk_tb = ~clk_tb;
    end
    
    LSFR UUT(clk_tb,rst_tb,out_tb,outwithfourk);
endmodule
