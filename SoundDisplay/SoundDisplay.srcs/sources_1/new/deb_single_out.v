`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.03.2021 14:18:42
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


module deb_single_out(
    input CLOCK, D1,
    output F
    );
    
    wire Q2;
    wire Q1;
//    wire freq3_0;
    
//    reg [24:0] SET_COUNT1  = 16666667;
    
//    modular_clock three_hz(.CLOCK(CLOCK), .SET_COUNT(SET_COUNT1), .set_freq(freq3_0));
    
    dff dff1(.CLOCK(CLOCK), .D(D1), .Q(Q1));
    dff dff2(.CLOCK(CLOCK), .D(Q1), .Q(Q2));
    
    assign F = Q1 & ~Q2;

endmodule
