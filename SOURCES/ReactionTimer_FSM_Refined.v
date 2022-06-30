`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jeygopi Panisilvam
// 
// Create Date: 21.03.2018 18:57:49
// Design Name: 
// Module Name: ReactionTimer_FSM_Refined
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


module ReactionTimer_FSM_Refined(
    input wire clk,
    input wire resetFSM,
    input wire clk_1kHz,
    input wire idletoPrep,
    input wire testtoResult,
    input wire checkTime,
    output reg [15:0] led,
    output wire [6:0] ssdCathode,
    output reg [7:0] ssdAnode,
    output reg DP
    );
    
    //the 6 states associated with the finite state machine
    parameter IDLE_MODE = 6'b000001;
    parameter PREPARATION_MODE = 6'b000010;
    parameter TEST_MODE = 6'b000100;
    parameter RESULT_MODE = 6'b001000;
    parameter DELAY_MODE = 6'b010000;
    parameter RECORD_MODE = 6'b100000;
    
    //Three edgedetectors used for detecting accurately if the button is pressed in and a high signal is recieved
    edgeDetector CHANGE_STATE_IDLE_TO_PREP (
        .clk(clk),
        .signalIn(idletoPrep),
        .signalOut(),
        .risingEdge(idletoPrep_risingEdge),
        .fallingEdge()
    );
    
    edgeDetector CHANGE_STATE_IDLE_TO_RECORD (
            .clk(clk),
            .signalIn(checkTime),
            .signalOut(),
            .risingEdge(checkTime_risingEdge),
            .fallingEdge()
        );
    edgeDetector CHANGE_STATE_TEST_TO_RESULT (
        .clk(clk),
        .signalIn(testtoResult),
        .signalOut(),
        .risingEdge(testtoResult_risingEdge),
        .fallingEdge()
    );
    
    wire [12:0] totaloutput;
    //linear feedback shift register to obtain a randomized delay for the preparation stage
    LSFR linearFeedbackShiftRegister (
        .clk(clk),
        .rst(resetFSM),
        .out(),
        .outputLFSR(totaloutput)
    );
    
    //problem is totaloutput is constantly changing, hence its exiting the value too fast
    //need to find a way to get the system to hold a value until it goes into test state, then
    //reset the value to another random value for LFSR
    //cant create time delay using if loop because it will only run once, need to use while 
    //or for loop to iterate an amount of times equal to how long the preparation mode will last
    
    //declaration of all variables in the system
    reg [12:0] LFSRtotaloutput; //randomized time to use for the preparation mode
    reg [7:0] delayCounter; //counter to count how long the system has been in delay mode
    reg [7:0] RdelayCounter; //counter to count how long the system has been in results mode
    reg [10:0] recordCounter;
    reg activeDelayMode;
    reg [14:0] resultCounter;
    reg [5:0] state = IDLE_MODE;
    reg [5:0] nextState;
    reg [12:0] preparationCounter;
    wire [3:0] counter_a, counter_b, counter_c, counter_d;
    reg [3:0] counter_e, counter_f, counter_g, counter_h;
    reg [1:0] countdown_SSD;
    reg [2:0] activeDisplay;
    reg [3:0] FC_A, FC_B, FC_C, FC_D; //fail counters (values assigned to these will represent fail on SSD) 
    reg [13:0] previousRecord = 14'd9999;
    reg [13:0] totalReactionTime = 0;
    reg [20:0] overflowt = 0; //this determines how long we can track that the system has exceeded 9999 for 
    reg [1:0] countdownTimer;
    wire [3:0] overflowc;
    wire [3:0] recordTime_a, recordTime_b, recordTime_c, recordTime_d;
    reg [32:0] counter_prep;
    reg [10:0] i;
    reg [4:0] testcounter;
    reg [3:0] ssdNumber;
    //initial values for the system
    initial begin
        ssdAnode = 8'b1111_1111;
        activeDisplay <= 3'b111;
        DP <= 1'b1;
    end
    
    //next state logic in this always block
    always @(posedge clk) begin
        case(state)
            IDLE_MODE : begin //Put the words reaction timer on the display
                activeDelayMode = 1'b0;
                if (idletoPrep_risingEdge == 1) begin
                    nextState <= PREPARATION_MODE;
                end else if (checkTime_risingEdge == 1) begin
                    nextState <= RECORD_MODE;
                end else if (resetFSM == 1) begin
                    nextState <= IDLE_MODE;
                end
            end
             //cycle from left to right 
            PREPARATION_MODE : begin //count down/perform some visual indication
                if (testtoResult_risingEdge == 1) begin
                    nextState <= RESULT_MODE;
                end else if (resetFSM == 1) begin
                    nextState <= IDLE_MODE;
                end else if (preparationCounter >= LFSRtotaloutput) begin
                    nextState <= TEST_MODE;
                end else if (nextState == PREPARATION_MODE) begin
                    nextState <= PREPARATION_MODE;
                end
            end
                
            TEST_MODE : begin //becomes active as soon as preparation ends
                if (testtoResult_risingEdge == 1) begin
                    nextState <= RESULT_MODE;
                end else if (resetFSM == 1) begin
                    nextState <= IDLE_MODE;
                end
            end    
                                      
            RESULT_MODE : begin //dispalys result on seven segment display
                if (resultCounter >= 14'd10000 || resetFSM == 1) begin
                    nextState <= IDLE_MODE;
                end else if (((totalReactionTime < previousRecord) || activeDelayMode == 1'b1) && RdelayCounter >= 8'd250 && totalReactionTime > 14'd0) begin
                    nextState <= DELAY_MODE;
                    previousRecord <= totalReactionTime;
                end else begin 
                    nextState <= RESULT_MODE;
                end                                       
            end
            
            DELAY_MODE : begin
                activeDelayMode = 1'b1;
                if (resultCounter >= 14'd10000 || resetFSM == 1) begin
                    nextState <= IDLE_MODE;
                end else if (delayCounter >= 8'd250) begin
                    nextState <= RESULT_MODE;
                end else begin
                    nextState <= DELAY_MODE;
                end
            end
            RECORD_MODE : begin
                if (recordCounter >= 10'd1000 || resetFSM == 1) begin
                    nextState <= IDLE_MODE;
                end else begin
                    nextState <= RECORD_MODE;
                end
            end    
            default : nextState <= IDLE_MODE;
        endcase
    end
    
    //always block that is a counter for the record mode, to count how long system has been in RECORD_MODE
    always @(posedge clk_1kHz) begin
        if (state == RECORD_MODE) begin
            recordCounter = recordCounter + 10'd1;
        end else if (state == IDLE_MODE) begin
            recordCounter = 10'd0;
        end
    end
    //always block to count how long the system has been in RESULT_MODE and how long it has been in DELAY_MODE
    always @(posedge clk_1kHz) begin
        if (state == RESULT_MODE) begin
            RdelayCounter <= RdelayCounter + 8'd1;
            delayCounter <= 8'd0;
        end else if (state == DELAY_MODE) begin 
            delayCounter <= delayCounter + 8'd1;
            RdelayCounter <= 8'd0;
        end else if (state == IDLE_MODE) begin
            RdelayCounter <= 8'd0;
            delayCounter <= 8'd0;
        end
    end
    
    //this assigns a random LFSR output time for preparation mode when the idletoPrep button is pressed
    always @(posedge idletoPrep) begin
        LFSRtotaloutput = totaloutput;
    end
    
    //this is the state transition processs 
    always @(posedge clk) begin
        if (resetFSM) begin
            state <= IDLE_MODE;
        end else begin
            state <= nextState;
        end
    end
    
    //this code block is for the preparation counter for the countdown
    //the main issue with this is that there is a lag of around 1s, if i press
    //the next button too quick because this is on a clock tick of 1Hz
    //it will result in prepcounter not being reset
    always @(negedge clk_1kHz) begin
        if (state == PREPARATION_MODE) begin
            preparationCounter <= preparationCounter + 13'd1;
        end else if (state == IDLE_MODE) begin
            preparationCounter <= 32'd0;
        end
    end
    

    //counter to measure the reaction time, also counts if the counter has overflowed over 9.999s and produces a FAIL if it has
    always @(posedge clk_1kHz) begin
        if (state == IDLE_MODE) begin
            totalReactionTime = 14'd0;
            overflowt = 21'd0;
        end 
        else if (state == TEST_MODE) begin
            totalReactionTime <= totalReactionTime + 1;
              if (overflowc > 4'd0) begin
                overflowt = overflowt + 21'd1;
                counter_e <= 4'b1011;
                counter_f <= 4'b1100;
                counter_g <= 4'b1101;
                counter_h <= 4'b1110;
            end
        end else if (state == PREPARATION_MODE || counter_d > 4'd9) begin
            counter_e <= 4'b1011;
            counter_f <= 4'b1100;
            counter_g <= 4'b1101;
            counter_h <= 4'b1110;
        end
    end
    
    //ShiftAddThree algorithms to change the binary counter result to a form that can be displayed in decimal
    shiftAddThreeFourteenBits SAD_RT (
        .binary(totalReactionTime),
        .tenThousands(overflowc),
        .Thousands(counter_d),
        .Hundreds(counter_c),
        .Tens(counter_b),
        .Ones(counter_a)
        );
        
    shiftAddThreeFourteenBits SAD_RecordTime (
        .binary(previousRecord),
        .tenThousands(),
        .Thousands(recordTime_d),
        .Hundreds(recordTime_c),
        .Tens(recordTime_b),
        .Ones(recordTime_a)
        );        
        
    //always loop to set the LED's to turn on and off, on if test mode has begun/if system is still in test mode, off otherwise
    always @(posedge clk_1kHz) begin
        if (state == TEST_MODE) begin
            led [15:0] = 16'b1111_1111_1111_1111;
        end else begin
            led [15:0] = 16'b0000_0000_0000_0000;
        end
    end
    
    //code block to pick the activeDisplay
    //issue here is this only runs if the state is result mode, need to add more state conditions
    always @(posedge clk_1kHz) begin
        if (state == RESULT_MODE) begin
                if (activeDisplay >= 3'b011) begin
                    activeDisplay <= 3'b000;
                end else begin
                    activeDisplay <= activeDisplay + 3'b001;
                end
        end else if (state == RECORD_MODE) begin
            if (activeDisplay >= 3'b011) begin
                activeDisplay <= 3'b000;
            end else begin
                activeDisplay <= activeDisplay + 3'b001;
            end
        end else if (state == DELAY_MODE) begin
            activeDisplay <= 3'b111;
        end else if (state == PREPARATION_MODE) begin
            activeDisplay <= 3'b000;
        end else if (state == IDLE_MODE) begin
            activeDisplay <= 3'd7;
        end else if (state == TEST_MODE) begin
            if (activeDisplay >= 3'b111) begin
                activeDisplay <= 3'b011;
            end else begin
                activeDisplay <= activeDisplay + 3'b001;
            end
        end
    end
    
    //codeblock to set the state to IDLE_MODE if 10s has elapsed from entering result mode
    always @(posedge clk_1kHz) begin
        if (state == RESULT_MODE || state == DELAY_MODE) begin
            resultCounter <= resultCounter + 14'd1;
        end else if (state == IDLE_MODE) begin
            resultCounter <= 4'd0;
        end
    end
    
    //codeblock for counting down the numbers on the seven segment display in preparation moe
    reg [11:0] countdown_counterms;
    wire [3:0] countdown_counter;
    always @(posedge clk_1kHz) begin
        if (state == IDLE_MODE) begin
            countdown_counterms = 12'd4000;
        end
        else if (state == PREPARATION_MODE && countdown_counterms > 12'd1000) begin
            countdown_counterms = countdown_counterms - 12'd1;
        end
    end
    shiftAddThree PREPARATIONCOUNTER (
        .binary(countdown_counterms),
        .Thousands(countdown_counter),
        .Hundreds(),
        .Tens(),
        .Ones()
    );
    
    //The code block that dictates what will be displayed on the seven segment display depending on the state-dependent logic
    always @(posedge clk_1kHz) begin
        if (state == RESULT_MODE && totalReactionTime > 0 && overflowc == 4'd0 && overflowt == 21'd0) begin
            case(activeDisplay)
                3'd0 : begin
                    ssdNumber <= counter_a;
                    ssdAnode <= 8'b1111_1110;
                    DP <= 1'b1;
                end
                3'd1 : begin
                    ssdNumber <= counter_b;
                    ssdAnode <= 8'b1111_1101;
                    DP <= 1'b1;
                end    
                3'd2 : begin
                    ssdNumber <= counter_c;
                    ssdAnode <= 8'b1111_1011;
                    DP <= 1'b1;
                end
                3'd3 : begin
                    ssdNumber <= counter_d;
                    ssdAnode <= 8'b1111_0111;
                    DP <= 1'b0;
                end
            endcase
        end else if (state == RECORD_MODE && previousRecord < 14'd9999) begin
            case(activeDisplay)
                3'd0 : begin
                    ssdNumber <= recordTime_a;
                    ssdAnode <= 8'b1111_1110;
                    DP <= 1'b1;
                end
                3'd1 : begin
                    ssdNumber <= recordTime_b;
                    ssdAnode <= 8'b1111_1101;
                    DP <= 1'b1;
                end    
                3'd2 : begin
                    ssdNumber <= recordTime_c;
                    ssdAnode <= 8'b1111_1011;
                    DP <= 1'b1;
                end
                3'd3 : begin
                    ssdNumber <= recordTime_d;
                    ssdAnode <= 8'b1111_0111;
                    DP <= 1'b0;
                end
            endcase
        end else if (state == RESULT_MODE && (totalReactionTime == 14'd0 || overflowc > 4'd1 || overflowt > 0)) begin
            case(activeDisplay)
                3'd0 : begin
                    ssdNumber <= counter_e;
                    ssdAnode <= 8'b0111_1111;
                    DP <= 1'b1;
                end
                3'd1 : begin
                    ssdNumber <= counter_f;
                    ssdAnode <= 8'b1011_1111;
                    DP <= 1'b1;
                end
                3'd2 : begin
                    ssdNumber <= counter_g;
                    ssdAnode <= 8'b1101_1111;
                    DP <= 1'b1;
                end
                3'd3 : begin
                    ssdNumber <= counter_h;
                    ssdAnode <= 8'b1110_1111;
                    DP <= 1'b1;
                end
                default : begin
                    ssdNumber <= 4'd15; //4'd15 would give me -ve sign
                    ssdAnode <= 8'b1111_1111;
                    DP <= 1'b1;
                end
            endcase
        end else if (state == DELAY_MODE) begin
            case(activeDisplay)
                default : begin
                    ssdNumber <= 4'd15;
                    ssdAnode <= 8'b1111_1111;
                    DP <= 1'b1;
                end
            endcase
        end else if (state == PREPARATION_MODE && countdown_counterms > 12'd1000) begin
            case(activeDisplay)
                3'd0 : begin
                    ssdNumber <= countdown_counter;
                    ssdAnode <= 8'b1111_1110;
                    DP <= 1'b1;
                end
                default : begin
                    ssdNumber <= 4'd15;
                    ssdAnode <= 8'b1111_1111;
                    DP <= 1'b1;
                end
            endcase
        end else if (state == PREPARATION_MODE) begin
            case(activeDisplay)
                default : begin
                    ssdNumber <= 4'd15;
                    ssdAnode <= 8'b1111_1111;
                    DP <= 1'b1;
                end
            endcase
        end else if (state == IDLE_MODE) begin
            case(activeDisplay)
                default : begin
                    ssdNumber <= 4'd15;
                    ssdAnode <= 8'b1111_1111;
                    DP <= 1'b1;
                end
            endcase
        end
    end
    
    //the decoder that provides the nessecary cathode values based on the state dependent logic from the activeDisplay cases above
    sevenSegmentDecoderRT SSD (
        .bcd(ssdNumber),
        .ssd(ssdCathode)
    );    
endmodule
