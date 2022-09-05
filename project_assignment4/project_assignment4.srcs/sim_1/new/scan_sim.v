`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2021 09:49:59
// Design Name: 
// Module Name: scan_sim
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


module scan_sim(

    );
    
    reg CLOCK;
    reg BC;
    
    wire [15:0] LED;
    
    fingerprint_scan sim1(.CLOCK(CLOCK), .BC(BC), .LED(LED));
    
    initial begin
        CLOCK = 0; BC = 1; #10;
        BC = 0; #20;
        BC = 1; #200;
        BC = 0; #10;
    end
    
    always begin    
        #5 CLOCK = ~CLOCK;
    end
    
endmodule
