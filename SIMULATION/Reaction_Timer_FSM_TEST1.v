`timescale 1ns / 1ps

module Reaction_Timer_FSM_TEST1(

    );
    
    reg clk_100MHz, clk_1kHz, rst, itoP, tmB;
    wire [15:0] le;
    //wire [13:12] leu;
    //wire [15:14] let;
    //wire [11:10] lev;
    wire [7:0] ssdA;
    wire [6:0] ssdC;
    wire [3:0] st;
    wire [3:0] nSt;
    wire [31:0] pcount;
    wire [3:0] CA;
    wire [3:0] CB;
    wire [3:0] CC;
    wire [3:0] CD;
    wire clk_1khzt;
    //wire itoP_RE;
    reactiontimerFSM UUT (
        .clk(clk_100MHz),
        .dclk(clk_1kHz),
        .reset(rst),
        .idletoPrep(itoP),
        .testmodeBtn(tmB),
        .led(le),
        .ssdAnode(ssdA),
        .ssdCathode(ssdC),
        .state(st),
        .nextState(nSt),
        .prepCounter(pcount),
        .counter_a(CA),
        .counter_b(CB),
        .counter_c(CC),
        .counter_d(CD),
        .clk_1Hzt(clk_1khzt)
    );
        
        
    always begin
        #5
        clk_100MHz = ~clk_100MHz;
    end
    
    always begin 
        #500_000
        clk_1kHz = ~clk_1kHz;
    end
    
    initial begin
        clk_100MHz = 1;
        clk_1kHz = 1;
        rst = 0;
        itoP = 0;
        tmB = 0;
        #50
        itoP = 1;
        
        #20
        itoP = 0;
        
        #50 
        itoP = 1;
        
        
        #412294524 //result using 550 is a time of 90ns, this hsould be 1090ns
        tmB = 1;
        #20
        tmB = 0;
    end
endmodule
