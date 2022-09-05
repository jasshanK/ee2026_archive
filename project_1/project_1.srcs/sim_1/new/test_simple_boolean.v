`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.01.2021 14:40:52
// Design Name: 
// Module Name: test_simple_boolean
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


module test_simple_boolean(

    );
    //Simulation inputs 
    reg A; 
    reg B; 
    
    //Simulation Outputs
    wire LED1; 
    wire LED2; 
    wire LED3; 
    
    //Instantiation of the module to be simulated 
    simple_boolean dut(A, B, LED1, LED2, LED3);
    
    //Stimuli 
    initial begin 
        A = 0; B = 0; #10;
        A = 0; B = 1; #10;
        A = 1; B = 0; #10;
        A = 1; B = 1; #10;
    end
    
endmodule
