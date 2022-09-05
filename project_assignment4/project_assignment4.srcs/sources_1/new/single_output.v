`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.03.2021 14:45:22
// Design Name: 
// Module Name: single_output
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


module single_output(
    input CLOCK, D1,
    output F
    );
    
    wire Q2;
    wire Q1;
    
    dff dff1(.CLOCK(CLOCK), .D(D1), .Q(Q1));
    dff dff2(.CLOCK(CLOCK), .D(Q1), .Q(Q2));
    
    assign F = Q1 & ~Q2;

endmodule