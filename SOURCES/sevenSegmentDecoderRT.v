`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.03.2018 15:54:48
// Design Name: 
// Module Name: sevenSegmentDecoder
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


module sevenSegmentDecoderRT(
    input [3:0] bcd,
    output reg [6:0] ssd
    );
    
    //top segment A
    //middle segment G
    //bottom segment D
    //top left segment F
    //bottom left segment E
    //top right segment B
    //bottom right segment C
    //7 represented by 7'b0001111
    //2 represented by 7'b0010010
    always @(*) begin
        case(bcd)
            4'b0000 : ssd = 7'b0000001; //0. THIS
            4'b0001 : ssd = 7'b1001111; //1. THIS
            4'b0010 : ssd = 7'b0010010; //2.
            4'b0011 : ssd = 7'b0000110; //3.
            4'b0100 : ssd = 7'b1001100; //4. THIS
            4'b0101 : ssd = 7'b0100100; //5. THIS
            4'b0110 : ssd = 7'b1100000; //6.
            4'b0111 : ssd = 7'b0001111; //7.
            4'b1000 : ssd = 7'b0000000; //8. THIS
            4'b1001 : ssd = 7'b0000100; //9. THIS
            4'b1010 : ssd = 7'b0000001; //0. carry on digit THIS
            4'b1011 : ssd = 7'b0111000; //F symbol THIS
            4'b1100 : ssd = 7'b0001000; //A symbol THIS
            4'b1101 : ssd = 7'b1001111; //I symbol THIS
            4'b1110 : ssd = 7'b1110001; //L symbol THIS
            4'b1111 : ssd = 7'b1111111; //all cathodes off symbol THIS
            default : ssd = 7'b1111111;
        endcase
    end
endmodule
