`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.02.2018 15:29:45
// Design Name: 
// Module Name: TEST_oneBitFullAdder
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


module TEST_oneBitFullAdder(

);
    reg X;
    reg Y;
    reg carryIn;
    wire Z;
    wire carryOut;
    
    oneBitFullAdder UUT (
       .X(X),
       .Y(Y),
       .carryIn(carryIn),
       .Z(Z),
       .carryOut(carryOut)
    ); //variables are the term inside the brackets the function terms are arbritary
    
    initial begin
        X = 1'b0;
        Y = 1'b0;
        carryIn = 1'b0;
    
        #10 // wait for 10 time-steps
        X = 1'b1;
        Y = 1'b0;
        carryIn = 1'b0;
    
        #10
        X = 1'b0;
        Y = 1'b1;
        carryIn = 1'b0;
    
        #10
        X = 1'b1;
        Y = 1'b1;
        carryIn = 1'b0;

        #10
        X = 1'b0;
        Y = 1'b0;
        carryIn = 1'b1;
    
        #10 // wait for 10 time-steps
        X = 1'b1;
        Y = 1'b0;
        carryIn = 1'b1;
    
        #10
        X = 1'b0;
        Y = 1'b1;
        carryIn = 1'b1;
    
        #10
        X = 1'b1;
        Y = 1'b1;
        carryIn = 1'b1;
    // Other input conditions...
    end
endmodule
