`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.03.2018 15:37:22
// Design Name: 
// Module Name: waveformFSM
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


module waveformFSM(
    input clk,
    input reset,
    input increase,
    input decrease,
    input changeState,
    output reg [22:0] frequency,
    output reg [7:0] amplitude
    );
    
    parameter FREQUENCY_MODE = 2'b01;
    parameter AMPLITUDE_MODE = 2'b10;
    
    reg [1:0] state, nextState;
    
    wire changeState_risingEdge;
    
    edgeDetector CHANGE_STATE_EDGE (
        .clk(clk),
        .signalIn(changeState),
        .signalOut(),
        .risingEdge(changeState_risingEdge),
        .fallingEdge()
    );
    
    always @(*) begin
        case(state)
            FREQUENCY_MODE : begin
                if (changeState_risingEdge == 1) begin
                    nextState <= AMPLITUDE_MODE;
                end else begin
                    nextState <= FREQUENCY_MODE;
                end
            end
            
            AMPLITUDE_MODE : begin
                if (changeState_risingEdge == 1) begin
                    nextState <= FREQUENCY_MODE;
                end else begin
                    nextState <= FREQUENCY_MODE; 
                end
            end
            
            default : nextState <= FREQUENCY_MODE;
        endcase
    end
    
    always @(posedge clk) begin
        if (reset) begin
            state <= FREQUENCY_MODE;
        end else begin
            state <= nextState;
        end
    end
    
    reg signed [9:0] frequencyCounter;
    
    always @(posedge clk) begin
        if (reset) begin
            frequencyCounter <= 0;
        end else if (state == FREQUENCY_MODE) begin
            if (increase == 1 && frequencyCounter < 10'sd500) begin
                frequencyCounter <= frequencyCounter + 1;
            end else if (decrease == 1 && frequencyCounter > -10'sd500) begin
                frequencyCounter <= frequencyCounter - 1;
            end
        end
    end
    
    parameter FREQ_STEP = 4_295;
    reg signed [22:0] freqChange;

    always @(posedge clk) begin
        freqChange = FREQ_STEP * frequencyCounter;
        frequency = 23'd2_147_484 + freqChange;
    end
    
    always @(posedge clk) begin
        if (reset) begin
            amplitude <= 8'd64;
        end else if (state == AMPLITUDE_MODE) begin
            if (increase == 1 && amplitude < 8'd255) begin
                amplitude <= amplitude + 1;
            end else if (decrease == 1 && amplitude > 0) begin
                amplitude <= amplitude - 1;
            end
        end
    end
    
    
        
endmodule
