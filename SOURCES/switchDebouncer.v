`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2018 18:33:42
// Design Name: 
// Module Name: switchDebouncer
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


module switchDebouncer(
    input wire clk,
    input wire enable,
    input wire buttonIn,
    output wire buttonOut
    );
    
    reg [1:0] enableState;
    
    always @(enable) begin
        enableState[0] = enable; //need to use procedural block
    end //instead of assign because enableState is reg and not wire
    
    always @(posedge clk) begin
        enableState[1] = enableState[0];
    end
    
    reg [3:0] pipeline;
    
    always @(buttonIn) begin
        pipeline[0] = buttonIn;
    end
    
    always @(posedge clk) begin
        if (enableState == 2'b01) begin
            pipeline[1] <= pipeline[0];
            pipeline[2] <= pipeline[1];
            pipeline[3] <= pipeline[2]; // <= is needed to ensure
        end //that all statements will execute concurrently and 
    end //independent of each other instead of being dependent on the
        //previous result, if we used equals here, all the values
        //would be equal to each other as their value is passed to 
        //the next in order instead of concurrently
    assign buttonOut = pipeline[3] && pipeline[2] && pipeline[1] && pipeline[0];
    
endmodule
