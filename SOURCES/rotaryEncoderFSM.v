`timescale 1ns / 1ps

// Authors: Lyle Roberts, Ross Pure
// Date: 16/03/2018
// Description: Rotary encoder driver using an FSM to monitor the sequence of events when rotated clockwise and counter-clockwise.

module rotaryEncoderFSM #(
	parameter integer ACTIVE_HIGH = 1
)(
	input clk,
	input reset,
	input enable,
	input Ain,
	input Bin,
	output reg clockwise,
	output reg counterClockwise	
);

	//---------------------------------------------------------------------------------------------------//
	//									ACTIVE HIGH / LOW CONVERSION 									 //
	//---------------------------------------------------------------------------------------------------//
	
	// This module assumes that Ain and Bin are active high. If they aren't, then their values can
	// be flipped by setting the ACTIVE_HIGH parameter to 0 (false) which will invert Ain and Bin 
	// such that they are active high within this module.
	
	reg A_activeHigh, B_activeHigh;

	always @(*) begin
		if (ACTIVE_HIGH == 1) begin
			A_activeHigh <= Ain;
			B_activeHigh <= Bin;
		end else begin
			A_activeHigh <= ~Ain;
			B_activeHigh <= ~Bin;
		end
	end


	//---------------------------------------------------------------------------------------------------//
	//											   DEBOUNCING 									 		 //
	//---------------------------------------------------------------------------------------------------//

	wire A, B;

	debouncer #(
		.THRESHOLD(50)
	) DEBOUNCE_A (
		.clk(clk),
		.buttonIn(A_activeHigh),
		.buttonOut(A)
	);

	debouncer #(
		.THRESHOLD(50)
	) DEBOUNCE_B (
		.clk(clk),
		.buttonIn(B_activeHigh),
		.buttonOut(B)
	);

	//---------------------------------------------------------------------------------------------------//
	//									 	  STATE MACHINE LOGIC 	 									 //
	//---------------------------------------------------------------------------------------------------//
	// This rotary encoder driver uses a finite state machine to detect a rotation by looking for a specific
	// sequence of events to occur. A clockwise rotation occurs when:
	// * B transitions from 0 to 1
	// * A transitions from 0 to 1
	// * B transitions from 1 to 0
	// * A transitions from 1 to 0 <----- CLOCKWISE ROTATION DETECTED
	//
	// A counter-clockwise rotation occurs when:
	// * A transitions from 0 to 1
	// * B transitions from 0 to 1
	// * A transitions from 1 to 0
	// * B transitions from 1 to 0 <----- COUNTER-CLOCKWISE ROTATION DETECTED
	//
	// The following finite state machine monitors the sequence in which A and B change state. 

	localparam NUM_STATES = 9; // IDLE, CW1, CW2, CW3, CW4, CCW, CCW2, CCW3, CCW4;
	localparam IDLE = 8'b0000_0000;
	localparam CW1  = 8'b0000_0001, CW2  = 8'b0000_0010, CW3  = 8'b0000_0100, CW4  = 8'b0000_1000;
	localparam CCW1 = 8'b0001_0000, CCW2 = 8'b0010_0000, CCW3 = 8'b0100_0000, CCW4 = 8'b1000_0000;

	reg [NUM_STATES-1:0] state, nextState; 	

	// Next state driver (When do we transition to the next state? Always on the positive edge of 'clk')
	always @(posedge clk) begin
 		if (reset == 1) begin
 			state <= IDLE; // Always return to IDLE when reset
 		end else begin
			state <= nextState; // Otherwise, move to whatever the next state is.
 		end
 	end

	// Next-state logic (What is the next state given the current 'state' and inputs 'A' and 'B'?)
	always @(*) begin
		case(state)
			IDLE : begin
				if (B == 1) begin
					nextState <= CW1;
				end else if (A == 1) begin
					nextState <= CCW1;
				end else begin
					nextState <= IDLE;
				end
			end

			// CLOCKWISE ROTATION SEQUENCE (CW1 -> CW2 -> CW3 -> CW4)
			CW1 : begin
				if (A == 1) begin
					nextState <= CW2;
				end else if (B == 0) begin
					nextState <= IDLE;
				end else begin
					nextState <= CW1;
				end
			end

			CW2 : begin
				if (B == 0) begin
					nextState <= CW3;
				end else if (A == 0) begin
					nextState <= CW1;
				end else begin
					nextState <= CW2;
				end
			end

			CW3 : begin
				if (A == 0) begin
					nextState <= CW4;
				end else if (B == 1) begin
					nextState <= CW2;
				end else begin
					nextState <= CW3;
				end
			end

			CW4 : begin
				nextState <= IDLE;
			end


			// COUNTER CLOCKWISE ROTATION SEQUENCE (CCW1 -> CCW2 -> CCW3 -> CCW4)
			CCW1 : begin
				if (B == 1) begin
					nextState <= CCW2;
				end else if (A == 0) begin
					nextState <= IDLE;
				end else begin
					nextState <= CCW1;
				end
			end

			CCW2 : begin
				if (A == 0) begin
					nextState <= CCW3;
				end else if (B == 0) begin
					nextState <= CCW1;
				end else begin
					nextState <= CCW2;
				end
			end

			CCW3 : begin
				if (B == 0) begin
					nextState <= CCW4;
				end else if (A == 1) begin
					nextState <= CCW2;
				end else begin
					nextState <= CCW3;
				end
			end

			CCW4 : begin
				nextState <= IDLE;
			end
		endcase
	end
	
	//---------------------------------------------------------------------------------------------------//
    //                                  	STATE-DEPENDENT BEHAVIOUR                                    //
    //---------------------------------------------------------------------------------------------------//
    // We are only updating the values of clockwise and counterClockwise when the FSM enters state CW4 or 
    // CCW4 respectively.

    always @(posedge clk) begin
        if (reset == 1) begin
            clockwise <= 0;
            counterClockwise <= 0;
        end else if (enable == 1) begin
            if (state == CW4) begin
                clockwise <= 1;
            end else if (state == CCW4) begin
                counterClockwise <= 1;
            end else begin
                clockwise <= 0;
                counterClockwise <= 0;
            end
        end
    end

endmodule








