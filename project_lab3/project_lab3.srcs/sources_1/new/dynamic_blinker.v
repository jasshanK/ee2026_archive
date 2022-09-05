`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.02.2021 15:28:48
// Design Name: 
// Module Name: dynamic_blinker
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


module dynamic_blinker(
    input CLOCK,
    output LED
    );
    
    reg [3:0] SET_COUNT = 4'b1111;
    
modular_clock clk1(CLOCK, SET_COUNT, LED);

endmodule
