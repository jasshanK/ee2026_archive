`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.01.2021 01:13:34
// Design Name: 
// Module Name: test_password
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


module test_password(

    );
    
    //sim inputs 
    reg SW0;
    reg SW1;
    reg SW2;
    reg SW3;
    reg SW4;
    reg SW5;
    reg SW6;
    reg SW7;
    reg SW8;
    reg SW9;
    
    //sim outputs 
    wire SEG_B;
    wire SEG_D;
    wire SEG_F;
//    wire LED0;
//    wire LED1;
//    wire LED2;
//    wire LED3;
//    wire LED4;
//    wire LED5;
//    wire LED6;
//    wire LED7;
//    wire LED8;
//    wire LED9;
    
    //instantiation of module to be tested 
    password sim_1(SW0, SW1, SW2, SW3, SW4, SW5, SW6, SW7, SW8, SW9, SEG_B, SEG_D, SEG_F);
    
    //sim
    initial begin
        SW0 = 1; SW1 = 1; SW2 = 1; SW3 = 0; SW4 = 1; SW5 = 0; SW6 = 1; SW7 = 0; SW8 = 0; SW9 = 0; #10;
        SW0 = 0; SW1 = 1; SW2 = 1; SW3 = 0; SW4 = 1; SW5 = 0; SW6 = 1; SW7 = 0; SW8 = 0; SW9 = 0; #10;
        SW0 = 1; SW1 = 0; SW2 = 1; SW3 = 0; SW4 = 1; SW5 = 0; SW6 = 1; SW7 = 0; SW8 = 0; SW9 = 0; #10;
        SW0 = 1; SW1 = 1; SW2 = 1; SW3 = 0; SW4 = 1; SW5 = 0; SW6 = 1; SW7 = 0; SW8 = 0; SW9 = 0; #10;
    end
    
    
endmodule
