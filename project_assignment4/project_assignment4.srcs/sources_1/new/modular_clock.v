`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.03.2021 15:00:51
// Design Name: 
// Module Name: clock_module
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


module modular_clock(
    input CLOCK,
    input [30:0] SET_COUNT,
    output reg set_freq = 0
    );
    
    reg [30:0] COUNT = 0;
always @ (posedge CLOCK) begin
    COUNT = COUNT + 1;
    
    set_freq <= ( COUNT == SET_COUNT ) ? ~set_freq: set_freq;
    COUNT = ( COUNT == SET_COUNT ) ? 0:COUNT;
end
endmodule

