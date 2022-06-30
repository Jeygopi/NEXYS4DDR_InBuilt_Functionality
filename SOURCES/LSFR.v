`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2018 19:34:15
// Design Name: 
// Module Name: LSFR
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


module LSFR(
    input wire clk,
    input wire rst,
    output reg [11:0] out,
    output reg [12:0] outputLFSR
    );
    //primitive polynomial used here is x^11 + x^5 + x^3 + x^1 + 1
    wire feedback; //the feedback wire is where the XNOR of the output takes place
    assign feedback = ~(out[11]^out[5]^out[3]^out[1]);
    
    always @(posedge clk) begin
        if (rst)
            out = 12'b0;
        else 
            out = {out[10:0],feedback}; //the feedback variable is concatenated with the previous output to create the new output
    end
    
    always @(posedge clk) begin 
        if (out > 12'd4000) begin //a value of 4000 is added to the LFSR output, this is because the system specification at a minimum (next line)
            outputLFSR = out + 12'd4000 - 12'd96; //needs a delay of 4s (3s for the 3,2,1 countdown and 1s for the black SSD before test)
        end else begin
            outputLFSR = out + 12'd4000;
        end
    end
endmodule
