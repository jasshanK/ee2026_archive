`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.02.2021 14:27:36
// Design Name: 
// Module Name: slow_blinky_test
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


module slow_blinky_test( );
    
    reg CLOCK;
    wire LED;
    
    dynamic_blinker sim2 (CLOCK, LED);
    
    initial begin 
        CLOCK = 0; 
    end 
    
    always begin 
        #5 CLOCK = ~CLOCK;
    end
    
endmodule
