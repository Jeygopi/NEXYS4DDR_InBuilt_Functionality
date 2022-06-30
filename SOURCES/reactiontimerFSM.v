`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2018 15:53:47
// Design Name: 
// Module Name: reactiontimerFSM
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


module reactiontimerFSM(
    input clk,
    input dclk,
    input reset,
    input idletoPrep,
    input testmodeBtn,
    output reg [15:0] led,
    output wire [7:0] ssdAnode,
    output wire [6:0] ssdCathode,
    output reg [3:0] state,
    output reg [3:0] nextState,
    output reg [31:0] prepCounter,
    output reg [3:0] counter_a,
    output reg [3:0] counter_b,
    output reg [3:0] counter_c,
    output reg [3:0] counter_d,
    output wire clk_1Hzt
    //output wire idletoPrep_risingEdge
    //output reg [3:0] state
    );
    
    parameter IDLE_MODE = 4'b0001;
    parameter PREPARATION_MODE = 4'b0010;
    parameter TEST_MODE = 4'b0100;
    parameter RESULT_MODE = 4'b1000; 
    
//    initial begin
//        clk_1kHzz = 1;
//    end
    
//    always @(*) begin
//        clk_1kHzz = clk_1kHz;
//    end
    //reg [3:0] state, nextState;
    
    wire idletoPrep_risingEdge; 
    wire clk_1kHz;
    wire clk_1Hz;
    assign clk_1Hzt = clk_1Hz;
    
    initial begin
        prepCounter = 32'd0;
    end
//
//The button to Change the state from idle to preparation   
    edgeDetector CHANGE_STATE_IDLE_TO_PREP (
        .clk(clk),
        .signalIn(idletoPrep),
        .signalOut(),
        .risingEdge(idletoPrep_risingEdge),
        .fallingEdge()
    );
//
//end of button IDLE -> PREP
    wire testmodeBtn_risingEdge;
//
//The button to change the state from Test to Result
    edgeDetector CHANGE_STATE_TEST_TO_RESULT (
        .clk(clk),
        .signalIn(testmodeBtn),
        .signalOut(),
        .risingEdge(testmodeBtn_risingEdge),
        .fallingEdge()
    );
//
//end of button TEST -> RESULT
//ClockDivider for 1kHZ clock 
    clockDivider #(
        .THRESHOLD(50_000)
    ) CLOCK_1KHZ_GENERATOR (
        .clk(clk),
        .reset(1'b0),
        .enable(1'b1),
        .dividedClk(clk_1kHz)
    );
    
    edgeDetector CLOCK_1kHZ_risingEdge (
        .clk(clk),
        .signalIn(clk_1kHz),
        .signalOut(),
        .risingEdge(clk_1kHz_risingEdge),
        .fallingEdge()
    );
//      
//ClockDivider for 1HZ clock + Edgedetector to detect the clock periods    
    clockDivider #(
        .THRESHOLD(50_000_000)
    ) CLOCK_1HZ_GENERATOR (
        .clk(clk),
        .reset(1'b0),
        .enable(1'b1),
        .dividedClk(clk_1Hz)
    );
    
    edgeDetector CLOCK_1HZ_risingEdge (
        .clk(clk),
        .signalIn(clk_1Hz),
        .signalOut(),
        .risingEdge(clk_1Hz_risingEdge),
        .fallingEdge()
    );
//Clock divider and edge detector code end here
//    
    //reg [31:0] prepCounter; //counter for preparation mode
    reg [3:0] resultCounter;
    
    always @(posedge clk) begin
        case(state)
            IDLE_MODE : begin //Put the words reaction timer on the display
                if (idletoPrep_risingEdge == 1) begin
                    nextState <= PREPARATION_MODE;
                //end else begin
                //    nextState <= IDLE_MODE;
                end
            end
             //cycle from left to right 
            PREPARATION_MODE : begin //count down/perform some visual indication
                if (prepCounter > 32'd50) begin
                    nextState <= TEST_MODE;
                end else if (reset == 1) begin
                    nextState <= IDLE_MODE;
                end else begin
                    //prepCounter <= prepCounter + 32'd10;
                    nextState <= PREPARATION_MODE;
                end
            end
                
            TEST_MODE : begin //becomes active as soon as preparation ends
                if (testmodeBtn_risingEdge == 1) begin
                    nextState <= RESULT_MODE;
                end else if (reset == 1) begin
                    nextState <= IDLE_MODE;
                end
            end                              //terminate when reaction test ends when
                              //subject pushes a button
            RESULT_MODE : begin //dispalys result on seven segment display
                if (resultCounter > 4'd10 || reset == 1) begin
                    nextState <= IDLE_MODE;
                end else begin 
                    nextState <= RESULT_MODE;
                end                                       //before reverting to idle mode 
            end
            
            default : nextState <= IDLE_MODE;
        endcase
    end
    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE_MODE;
            //prepCounter = 32'd0;
        //if (state == IDLE_MODE) begin    
        end else begin
            state <= nextState;
        end
    end
    
    //reg a; 
    //This should be the code for the IDLE state of the system
    //always @(posedge clk) begin
      //  if (state == IDLE_STATE) begin
        //    a = 1;
        //end
    //end
    //always @(posedge clk) begin
      //  if (state == IDLE_MODE) begin
        //    ledt [15:14] = 2'd1;
   //     end else begin
     //       ledt [15:14] = 2'd3;
       // end
    //end
//This should be the code for the PREPARATION state of the system    
    //always @(posedge clk) begin
    always @(posedge clk) begin
        if (state == PREPARATION_MODE) begin
            prepCounter <= prepCounter + 32'd1;
        end
    end
//This should be the code for the TEST state of the system
    always @(posedge clk) begin
        if (state ==  TEST_MODE) begin
            led [15:0] = 16'b1111_1111_1111_1111;
        end else begin
            led [15:0] = 16'b0000_0000_0000_0000;
        end
    end
    
    //reg [3:0] counter_a; //least significant digit 
    //reg [3:0] counter_b; //second least significant digit
    //reg [3:0] counter_c; //second most significant digit
    //reg [3:0] counter_d; //most significant digit
    reg [3:0] counter_e;
    reg [3:0] counter_f;
    reg [3:0] counter_g;
    reg [3:0] counter_h;
    reg [3:0] counter_i;
    reg [3:0] counter_j; 
    integer reaction_time;
    
    initial begin
        counter_a = 0;
        counter_b = 0;
        counter_c = 0;
        counter_d = 0;
    end
    
    always @(posedge dclk) begin //right solution is clk_1kHz_risingEdge
        if (state == TEST_MODE) begin
            counter_a <= counter_a + 1;
            //overflow counter here to count each digit
            if (counter_a >= 4'd9) begin
                counter_b <= counter_b + 4'b0001;
                counter_a <= 4'd0;
            end else if (counter_b >= 4'd9) begin
                counter_c <= counter_c + 4'b0001;
                counter_b <= 4'd0;
            end else if (counter_c >= 4'd9) begin
                counter_d <= counter_d + 4'b0001;
                counter_c <= 4'd0; 
            //end else
            //    counter_a <= 4'd0;
            //    counter_b <= 4'd0;
            //    counter_c <= 4'd0;
            //    counter_d <= 4'd0;
            end                
        end
    end
//This should be the code for the RESULT state of the system
    reg [1:0] activeDisplay;
     
    always @(posedge clk_1kHz) begin
        if (state == RESULT_MODE) begin
            if (activeDisplay > 2'b11) begin
                activeDisplay <= 2'b00;
            end else begin 
                activeDisplay <= activeDisplay + 2'b01;
            end
        end
    end
    
    SSDDriver Driver (
        .clk(clk),
        .CA(counter_a),
        .CB(counter_b),
        .CC(counter_c),
        .CD(counter_d),
        .activeD(activeDisplay),
        .ssA(ssdAnode),
        .ssC(ssdCathode)
    );    
    
 //put this in seperate module   
    
endmodule
