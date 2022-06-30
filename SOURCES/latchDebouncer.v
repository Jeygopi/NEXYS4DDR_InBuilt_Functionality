`timescale 1ns / 1ps

// Use this debouncer to debounce the rotary encoder
module latchDebouncer #(
    parameter integer LIMIT = 20_000_000
)(
    input clk,
    input inputSignal,
    output reg debouncedSignal
);
    
    wire inputSignal_risingEdge;
    
    edgeDetector INPUT_EDGE_DETECTOR (
        .clk(clk),
        .signalIn(inputSignal),
        .signalOut(),
        .risingEdge(inputSignal_risingEdge),
        .fallingEdge()
    );
    
    reg holdOffLatch;
    reg [$clog2(LIMIT)-1:0] holdOffCounter; // $clog2 is a ceiling'd log 2 function.
    
    always @(posedge clk) begin
        if (inputSignal_risingEdge == 1 && holdOffLatch == 0) begin
            holdOffLatch <= 1;
        end else if (holdOffCounter >= LIMIT-1) begin
            // When holdOffCounter reaches limit, turn the latch off
            holdOffLatch <= 0;
        end
    end
    
    always @(posedge clk) begin
        if (holdOffLatch == 1) begin
            holdOffCounter <= holdOffCounter + 1;
        end else if (holdOffLatch == 0) begin
            holdOffCounter <= 0;
        end
    end
    
    always @(*) begin
        debouncedSignal <= holdOffLatch;
    end
    
endmodule
