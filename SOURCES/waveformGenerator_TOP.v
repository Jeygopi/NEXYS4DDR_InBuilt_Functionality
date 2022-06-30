`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2018 20:45:26
// Design Name: 
// Module Name: waveformGenerator_TOP
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


module waveformGenerator_TOP(
    input wire clk,
    input wire reset,
    input wire enable,
    input wire encA,
    input wire encB,
    input wire encButton,
    input wire encSwitch,
    output wire [7:0] waveform,
    output wire waveformEnabled
    );
    
    wire [22:0] waveFrequency;
    wire [7:0] waveAmplitude;
    sawtoothGenerator SAWTOOTH_GEN ( 
            .clk(clk),
            .reset(reset),
            .enable(enable),
            .frequency(waveFrequency),
            .amplitude(waveAmplitude),
            .sawtoothOut(waveform)
    );
    wire CW;
    wire CCW;
    rotaryEncoderFSM ROTARY_ENCODER_DRIVER (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .Ain(~encA),
        .Bin(~encB),
        .clockwise(CW),
        .counterClockwise(CCW)
    );    
    
    wire encButton_dB;
    
    waveformFSM WAVEFORM_GEN_FSM (
        .clk(clk),
        .reset(reset),
        .increase(CW),
        .decrease(CCW),
        .changeState(encButton_dB),
        .frequency(waveFrequency),
        .amplitude(waveAmplitude)
    );
    
    debouncer ENC_BUTTON_DEBOUNCER (
        .clk(clk),
        .buttonIn(encButton),
        .buttonOut(encButton_dB)
    );
    
    
    assign waveformEnabled = enable;
    
endmodule