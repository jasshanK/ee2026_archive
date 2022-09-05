`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.01.2021 12:02:34
// Design Name: 
// Module Name: segment_sim
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


module segment_sim(

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
    wire B; 
    wire D; 
    wire F;
    
    password segment_sim(SW0, SW1, SW2, SW3, SW4, SW5, SW6, SW7, SW8, SW9, B, D, F);
    
    initial begin
    SW0 = 1; SW1 = 1; SW2 = 1; SW3 = 0; SW4 = 1; SW5 = 0; SW6 = 1; SW7 = 0; SW8 = 0; SW9 = 0; #10;
    SW0 = 0; SW1 = 1; SW2 = 1; SW3 = 0; SW4 = 1; SW5 = 1; SW6 = 1; SW7 = 0; SW8 = 0; SW9 = 0; #10;
    SW0 = 1; SW1 = 0; SW2 = 0; SW3 = 0; SW4 = 1; SW5 = 0; SW6 = 1; SW7 = 0; SW8 = 0; SW9 = 1; #10;
    SW0 = 1; SW1 = 1; SW2 = 1; SW3 = 0; SW4 = 1; SW5 = 0; SW6 = 1; SW7 = 0; SW8 = 0; SW9 = 0; #10;
    end
endmodule
