`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.01.2021 15:51:24
// Design Name: 
// Module Name: simple_kill_boolean
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


module simple_kill_boolean(
    input A,
    input B,
    input C,
    output LED1,
    output LED2,
    output LED3
    );
    
    assign LED1 = (A & ~B & ~C) | (A & B & ~C); 
    assign LED2 = (A & B & ~C) | (A & B & ~C);
    assign LED3 = (A & B & ~C);
endmodule
