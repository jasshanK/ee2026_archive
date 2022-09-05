`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.02.2021 14:24:55
// Design Name: 
// Module Name: slow_blinky
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


module slow_blinky(input CLOCK, output reg LED = 0);

reg [3:0] COUNT = 4'b0000;

always @ (posedge CLOCK) begin
    COUNT <= COUNT + 1;
    LED <= (COUNT == 4'b0000) ? ~LED : LED ; 
    end
    
endmodule
