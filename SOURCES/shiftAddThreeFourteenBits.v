`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.04.2018 19:20:57
// Design Name: 
// Module Name: shiftAddThreeFourteenBits
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


module shiftAddThreeFourteenBits(
    input [13:0] binary,
    output reg [3:0] tenThousands,
    output reg [3:0] Thousands,
    output reg [3:0] Hundreds,
    output reg [3:0] Tens,
    output reg [3:0] Ones
    );
    
    integer i;
    always @(binary) begin
        tenThousands = 4'd0;
        Thousands = 4'd0;
        Hundreds = 4'd0;
        Tens = 4'd0;
        Ones = 4'd0;
        //This is the application of the shiftaddthree method that was learned, there is no new knowledge here and it is a basic application of the method
        for (i=13; i>=0; i=i-1) begin
            if (tenThousands >= 5)
                tenThousands = tenThousands + 3;
            if (Thousands >= 5)
                Thousands = Thousands +3;
            if (Hundreds >= 5)
                Hundreds = Hundreds + 3;
            if (Tens >= 5) 
                Tens = Tens + 3;
            if (Ones >= 5)
                Ones = Ones + 3;
            //the method is generally taught up to thousands, but a simple extension can be made to tenThousands    
            //Shifting left one
            tenThousands = tenThousands << 1;
            tenThousands[0] = Thousands[3];
            Thousands = Thousands << 1;
            Thousands[0] = Hundreds[3];
            Hundreds = Hundreds << 1;
            Hundreds[0] = Tens[3];
            Tens = Tens << 1;
            Tens[0] = Ones[3];
            Ones = Ones << 1;
            Ones[0] = binary[i];
        end
    end
        
endmodule
