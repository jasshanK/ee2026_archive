`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.03.2021 14:37:38
// Design Name: 
// Module Name: sim_single_output
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


module sim_single_output( );
    reg CLOCK;
    reg D1;
    
    wire F;
    
    single_output so(.CLOCK(CLOCK), .D1(D1), .F(F));
    
    initial begin
    CLOCK = 0; D1 = 1; #10;
    end
    
    always begin    
        #5 CLOCK = ~CLOCK;
    end
    
endmodule
