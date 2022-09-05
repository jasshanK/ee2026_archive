`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.01.2021 00:51:49
// Design Name: 
// Module Name: password
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


module password(
    //switches
    input SW0,
    input SW1,
    input SW2,
    input SW3,
    input SW4,
    input SW5,
    input SW6,
    input SW7,
    input SW8,
    input SW9,
    
    //LED
//    output LED0,
//    output LED1,
//    output LED2,
//    output LED3,
//    output LED4,
//    output LED5,
//    output LED6,
//    output LED7,
//    output LED8,
//    output LED9,
    
    //segments
    output SEG_B,
    output SEG_D,
    output SEG_F,
    
    //hardcoded segments 
//    output SEG_A,
//    output SEG_C, 
//    output SEG_E, 
//    output SEG_G,
//    output SEG_DP,
    
//    //common anode
//    output AN0, 
//    output AN1, 
//    output AN2, 
//    output AN3
    );
    //switches assigned to corresponding LEDs
//    assign LED0 = SW0;
//    assign LED1 = SW1;
//    assign LED2 = SW2;
//    assign LED3 = SW3;
//    assign LED4 = SW4;
//    assign LED5 = SW5;
//    assign LED6 = SW6;
//    assign LED7 = SW7;
//    assign LED8 = SW8;
//    assign LED9 = SW9;
    
    //segments assigned based on password
    assign SEG_B = (SW0 & SW1 & SW2 & ~SW3 & SW4 & ~SW5 & SW6 & ~SW7 & ~SW8 & ~SW9);
    assign SEG_D = (SW0 & SW1 & SW2 & ~SW3 & SW4 & ~SW5 & SW6 & ~SW7 & ~SW8 & ~SW9);
    assign SEG_F = (SW0 & SW1 & SW2 & ~SW3 & SW4 & ~SW5 & SW6 & ~SW7 & ~SW8 & ~SW9);
    
    //hardcoded segments
//    assign SEG_A = 1;
//    assign SEG_C = 1;
//    assign SEG_E = 1;
//    assign SEG_G = 1;
//    assign SEG_DP = 1;
    
    //hardcoded common anode
//    assign AN0 = 1; 
//    assign AN1 = 0; 
//    assign AN2 = 1; 
//    assign AN3 = 1; 
endmodule

