`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.01.2021 15:59:53
// Design Name: 
// Module Name: test_simple_kill_boolean
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


module test_simple_kill_boolean(

    );
    //Simul input
    reg A; 
    reg B; 
    reg C; 
    
    //Simul output
    wire LED1; 
    wire LED2; 
    wire LED3; 
    
    //calling module (instantiation)
    simple_kill_boolean kill(A, B, C, LED1, LED2, LED3);
    
    //simul 
    initial begin
        A = 0; B = 0; C = 0; #10;
        A = 0; B = 0; C = 1; #10;
        A = 0; B = 1; C = 0; #10;
        A = 1; B = 0; C = 0; #10;
        A = 1; B = 1; C = 0; #10;
        A = 0; B = 1; C = 1; #10;
        A = 1; B = 0; C = 1; #10;
        A = 1; B = 1; C = 1; #10;
    end
endmodule
