`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.01.2021 11:35:46
// Design Name: 
// Module Name: LED_sim
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


module LED_sim(

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
    wire LED0;
    wire LED1;
    wire LED2;
    wire LED3;
    wire LED4;
    wire LED5;
    wire LED6;
    wire LED7;
    wire LED8;
    wire LED9;
    
    password led_sim(SW0, SW1, SW2, SW3, SW4, SW5, SW6, SW7, SW8, SW9, LED0, LED1, LED2, LED3, LED4, LED5, LED6, LED7, LED8, LED9);
    
    initial begin
    SW0 = 1; SW1 = 1; SW2 = 1; SW3 = 1; SW4 = 1; SW5 = 1; SW6 = 1; SW7 = 1;  SW8 = 1; SW9 = 1; #10;
    SW0 = 1; SW1 = 0; SW2 = 1; SW3 = 0; SW4 = 1; SW5 = 1; SW6 = 1; SW7 = 1;  SW8 = 0; SW9 = 1; #10;
    SW0 = 1; SW1 = 1; SW2 = 1; SW3 = 0; SW4 = 1; SW5 = 1; SW6 = 0; SW7 = 1;  SW8 = 1; SW9 = 1; #10;
    SW0 = 1; SW1 = 0; SW2 = 0; SW3 = 1; SW4 = 0; SW5 = 1; SW6 = 1; SW7 = 1;  SW8 = 1; SW9 = 1; #10;
    end
endmodule
