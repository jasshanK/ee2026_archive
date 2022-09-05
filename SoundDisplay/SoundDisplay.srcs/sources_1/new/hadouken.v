`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2021 23:40:34
// Design Name: 
// Module Name: hadouken
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


module hadouken(
    input clk381,
    input [5:0] row,
    input [6:0] col,
    input [2:0] hadouken_state,
    input [8:0] anchor,
    output reg [15:0] hk_data
    );
    
    reg [3:0] frame_counter;
    reg [18:0] base_count;
    always @ (posedge clk381) begin
        base_count <= (base_count == 13000) ? 0 : base_count + 1;
        frame_counter <= (base_count % 2600 == 0) ? frame_counter + 1 : (base_count == 13000) ? 0 : frame_counter;
    end
    
    always @ (*) begin 
        case(hadouken_state) 
            2'b01: begin
                if ( col > anchor + 10 && col < anchor + 13 && row > 21 && row < 23) hk_data = `bandana;
                else if (row > 22 && row < 24) begin                                                              
                    if ( col > anchor + 10 && col < anchor + 12) hk_data = `bandana;                                                          
                    else if ( col > anchor + 13 && col < anchor + 17) hk_data = `bandana;                          
                end 
                else if (row > 23 && row < 25) begin                                                              
                    if ( col > anchor + 5 && col < anchor + 11) hk_data = `black;                                                          
                    else if ( col > anchor + 10 && col < anchor + 12) hk_data = `bandana;  
                    else if ( col > anchor + 12 && col < anchor + 15) hk_data = `bandana;                        
                end           
                else if (row > 24 && row < 26) begin                                                              
                    if ( col > anchor + 4 && col < anchor + 12) hk_data = `black;                                                          
                    else if ( col > anchor + 11 && col < anchor + 14) hk_data = `bandana;                         
                end 
                else if ( col > anchor + 3 && col < anchor + 13 && row >  25 && row < 27) hk_data = `bandana;     
                else if (row > 26 && row < 28) begin                                                              
                    if ( col > anchor + 2 && col < anchor + 6) hk_data = `black;                                
                    else if ( col > anchor + 5 && col < anchor + 11) hk_data = `white;                          
                    else if ( col > anchor + 11 && col < anchor + 14) hk_data = `black;                          
                end                                                                                               
                else if (row > 27 && row < 29) begin                                                              
                    if ( col > anchor + 1 && col < anchor + 5) hk_data = `black;                                
                    else if ( col > anchor + 4 && col < anchor + 12) hk_data = `white;                          
                    else if ( col > anchor + 11 && col < anchor + 15) hk_data = `black;                         
                end                                                                                               
                else if (row > 28 && row < 30) begin                                                              
                    if ( col > anchor + 1 && col < anchor + 5) hk_data = `black;                                
                    else if ( col > anchor + 4 && col < anchor + 6) hk_data = `white;
                    else if ( col > anchor + 5 && col < anchor + 7) hk_data = `black; 
                    else if ( col > anchor + 6 && col < anchor + 10) hk_data = `white;
                    else if ( col > anchor + 9 && col < anchor + 11) hk_data = `black;
                    else if ( col > anchor + 10 && col < anchor + 12) hk_data = `white;                         
                    else if ( col > anchor + 11 && col < anchor + 15) hk_data = `black;                         
                end                                                                                               
                else if (row > 29 && row < 31) begin                                                              
                    if ( col > anchor + 1 && col < anchor + 5) hk_data = `black;                                
                    else if ( col > anchor + 4 && col < anchor + 7) hk_data = `white;                           
                    else if ( col > anchor + 6 && col < anchor + 8) hk_data = `black;                           
                    else if ( col > anchor + 7 && col < anchor + 9) hk_data = `white;                          
                    else if ( col > anchor + 8 && col < anchor + 10) hk_data = `black;                          
                    else if ( col > anchor + 9 && col < anchor + 12) hk_data = `white;                         
                    else if ( col > anchor + 11 && col < anchor + 15) hk_data = `black;                         
                end                                                                                               
                else if (row > 30 && row < 32) begin                                                              
                    if ( col > anchor + 1 && col < anchor + 5) hk_data = `black;                                
                    else if ( col > anchor + 4 && col < anchor + 12) hk_data = `white;                         
                    else if ( col > anchor + 11 && col < anchor + 15) hk_data = `black;                         
                end                                                                                               
                else if (row > 31 && row < 33) begin                                                              
                    if ( col > anchor + 2 && col < anchor + 6) hk_data = `black;                                
                    else if ( col > anchor + 5 && col < anchor + 8) hk_data = `white; 
                    else if ( col > anchor + 7 && col < anchor + 9) hk_data = `black; 
                    else if ( col > anchor + 8 && col < anchor + 11) hk_data = `white;                        
                    else if ( col > anchor + 10 && col < anchor + 14) hk_data = `black;                         
                end                                                                                               
                else if (row > 32 && row < 34) begin                                                              
                    if ( col > anchor + 3 && col < anchor + 7) hk_data = `black;
                    else if ( col > anchor + 6 && col < anchor + 10) hk_data = `white;                        
                    else if ( col > anchor + 9 && col < anchor + 13) hk_data = `black;                                                        
                end                                                                                               
                else if (row > 33 && row < 35) begin                                                              
                    if ( col > anchor + 4 && col < anchor + 12) hk_data = `black;                                                        
                end                                                                                               
                else if (row > 34 && row < 36) begin                                                              
                    if ( col > anchor + 5 && col < anchor + 11) hk_data = `black;                                                         
                end                                                                                               
                else if (row > 35 && row < 37) begin                                                              
                    if ( col > anchor + 5 && col < anchor + 11) hk_data = `black;                               
                end                                                                                               
                //head end, middle start                                                                          
                else if ( col > anchor + 5 && col < anchor + 11 && row > 36 && row < 38) hk_data = `black;      
                else if ( col > anchor + 4 && col < anchor + 12 && row > 37 && row < 39) hk_data = `black;      
                else if (row > 38 && row < 40) begin                                                              
                    if ( col > anchor + 3 && col < anchor + 13) hk_data = `black;                               
                end                                                                                               
                else if (row > 39 && row < 41) begin                                                              
                    if ( col > anchor + 2 && col < anchor + 14) hk_data = `black;                                                      
                end                                                                                               
                else if (row > 40 && row < 42) begin                                                              
                    if ( col > anchor + 1 && col < anchor + 6) hk_data = `black;                                
                    else if ( col > anchor + 6 && col < anchor + 8) hk_data = `black;  
                    else if ( col > anchor + 7 && col < anchor + 9) hk_data = `orange;  
                    else if ( col > anchor + 9 && col < anchor + 10) hk_data = `black;
                    else if ( col > anchor + 10 && col < anchor + 15) hk_data = `black;                        
                end                                                                                               
                else if (row > 41 && row < 43) begin                                                              
                    if ( col > anchor + 1 && col < anchor + 5) hk_data = `black;                                
                    else if ( col > anchor + 6 && col < anchor + 10) hk_data = `orange;                           
                    else if ( col > anchor + 11 && col < anchor + 15) hk_data = `black;                         
                end                                                                                               
                else if (row > 42 && row < 44) begin                                                              
                    if ( col > anchor + 1 && col < anchor + 5) hk_data = `black;                                
                    else if ( col > anchor + 5 && col < anchor + 8) hk_data = `orange;  
                    else if ( col > anchor + 7 && col < anchor + 9) hk_data = `yellow;                          
                    else if ( col > anchor + 8 && col < anchor + 11) hk_data = `orange;   
                    else if ( col > anchor + 11 && col < anchor + 15) hk_data = `black;                       
                end                                                                                               
                else if (row > 43 && row < 45) begin                                                              
                    if ( col > anchor + 1 && col < anchor + 6 ) hk_data = `black;                                
                    else if ( col > anchor + 5 && col < anchor + 7) hk_data = `orange;                           
                    else if ( col > anchor + 6 && col < anchor + 10) hk_data = `yellow;  
                    else if ( col > anchor + 9 && col < anchor + 11) hk_data = `orange;  
                    else if ( col > anchor + 10 && col < anchor + 15) hk_data = `black;                       
                end
                else if (row > 44 && row < 46) begin                                                              
                    if ( col > anchor + 2 && col < anchor + 6) hk_data = `black;                                
                    else if ( col > anchor + 5 && col < anchor + 7) hk_data = `orange;    
                    else if ( col > anchor + 6 && col < anchor + 8) hk_data = `yellow;           
                    else if ( col > anchor + 7 && col < anchor + 9) hk_data = `beige;
                    else if ( col > anchor + 8 && col < anchor + 10) hk_data = `yellow; 
                    else if ( col > anchor + 9 && col < anchor + 11) hk_data = `orange;   
                    else if ( col > anchor + 10 && col < anchor + 14) hk_data = `black;                                  
                end 
                else if (row > 45 && row < 47) begin                                                              
                    if ( col > anchor + 3 && col < anchor + 6) hk_data = `black;                                
                    else if ( col > anchor + 5 && col < anchor + 7) hk_data = `orange;    
                    else if ( col > anchor + 6 && col < anchor + 8) hk_data = `yellow;           
                    else if ( col > anchor + 7 && col < anchor + 9) hk_data = `beige;
                    else if ( col > anchor + 8 && col < anchor + 10) hk_data = `yellow; 
                    else if ( col > anchor + 9 && col < anchor + 11) hk_data = `orange;   
                    else if ( col > anchor + 10 && col < anchor + 13) hk_data = `black;                                  
                end                                                                                                               
                else if (row > 46 && row < 48) begin                                                              
                    if ( col > anchor + 5 && col < anchor + 7) hk_data = `orange; 
                    else if ( col > anchor + 6 && col < anchor + 8) hk_data = `yellow; 
                    else if ( col > anchor + 7 && col < anchor + 9) hk_data = `beige;  
                    else if ( col > anchor + 8 && col < anchor + 10) hk_data = `yellow;
                    else if ( col > anchor + 9 && col < anchor + 11) hk_data = `orange;                                                  
                end                                                                                               
                //middle end, lower start                                                                         
                else if (row > 47 && row < 49) begin
                    if ( col > anchor + 5 && col < anchor + 8) hk_data = `orange; 
                    else if ( col > anchor + 7 && col < anchor + 9) hk_data = `yellow; 
                    else if ( col > anchor + 8 && col < anchor + 11) hk_data = `orange;                                                        
                end                                                                                               
                else if (row > 48 && row < 50) begin                                                              
                    if ( col > anchor + 4 && col < anchor + 7) hk_data = `black;                                
                    else if ( col > anchor + 6 && col < anchor + 10) hk_data = `orange; 
                    if ( col > anchor + 9 && col < anchor + 12) hk_data = `black;                         
                end                                                                                               
                else if (row > 49 && row < 51) begin                                                              
                    if ( col > anchor + 3 && col < anchor + 8) hk_data = `black;                                
                    else if ( col > anchor + 7 && col < anchor + 9) hk_data = `orange;  
                    if ( col > anchor + 8 && col < anchor + 13) hk_data = `black;                        
                end                                                                                              
                else if (row > 50 && row < 52) begin                                                              
                    if ( col > anchor + 2 && col < anchor + 7) hk_data = `black;                                
                    else if ( col > anchor + 9 && col < anchor + 14) hk_data = `black;                         
                end                                                                                               
                else if (row > 51 && row < 53) begin                                                              
                    if ( col > anchor + 1 && col < anchor + 6) hk_data = `black;                                
                    else if ( col > anchor + 10 && col < anchor + 15) hk_data = `black;                         
                end                                                                                               
                else if (row > 52 && row < 54) begin                                                              
                    if ( col > anchor + 1 && col < anchor + 5) hk_data = `black;                                
                    else if ( col > anchor + 11 && col < anchor + 15) hk_data = `black;                         
                end                                                                                               
                else if (row > 53 && row < 55) begin                                                              
                    if ( col > anchor + 1 && col < anchor + 5) hk_data = `black;                                
                    else if ( col > anchor + 11 && col < anchor + 15) hk_data = `black;                         
                end                                                                                               
                else if (row > 54 && row < 56) begin                                                              
                    if ( col > anchor + 1 && col < anchor + 5) hk_data = `black;                                
                    else if ( col > anchor + 11 && col < anchor + 15) hk_data = `black;                         
                end                                                                                               
                else if (row > 55 && row < 57) begin                                                              
                    if ( col > anchor + 1 && col < anchor + 5) hk_data = `black;                                
                    else if ( col > anchor + 11 && col < anchor + 15) hk_data = `black;                         
                end                                                                                               
                else if (row > 56 && row < 58) begin                                                              
                    if ( col > anchor + 1 && col < anchor + 5) hk_data = `black;                                
                    else if ( col > anchor + 11 && col < anchor + 15) hk_data = `black;                         
                end                                                                                               
                else if (row > 57 && row < 59) begin                                                              
                    if ( col > anchor + 1 && col < anchor + 5) hk_data = `black;                                
                    else if ( col > anchor + 11 && col < anchor + 15) hk_data = `black;                         
                end   
                //lower end
            end
            2'b10: begin
                if ( col > anchor + 4 && col < anchor + 7 && row > 21 && row < 23) hk_data = `bandana;
                else if (row > 22 && row < 24) begin                                                              
                    if ( col > anchor + 5 && col < anchor + 9) hk_data = `bandana;                                                                                  
                end 
                else if (row > 23 && row < 25) begin                                                              
                    if ( col > anchor + 7 && col < anchor + 11) hk_data = `bandana;                                                          
                    else if ( col > anchor + 13 && col < anchor + 19) hk_data = `black;                         
                end           
                else if (row > 24 && row < 26) begin                                                              
                    if ( col > anchor + 12 && col < anchor + 20) hk_data = `black;                                                          
                    else if ( col > anchor + 9 && col < anchor + 13) hk_data = `bandana;                         
                end 
                else if ( col > anchor + 8 && col < anchor + 21 && row >  25 && row < 27) hk_data = `bandana;     
                else if (row > 26 && row < 28) begin                                                              
                    if ( col > anchor + 6 && col < anchor + 10) hk_data = `bandana;                                
                    else if ( col > anchor + 10 && col < anchor + 14) hk_data = `black;                          
                    else if ( col > anchor + 18 && col < anchor + 22) hk_data = `black;
                    else if ( col > anchor + 13 && col < anchor + 19) hk_data = `white;                          
                end                                                                                               
                else if (row > 27 && row < 29) begin                                                              
                    if ( col > anchor + 4 && col < anchor + 8) hk_data = `bandana;                                
                    else if ( col > anchor + 9 && col < anchor + 13) hk_data = `black;                          
                    else if ( col > anchor + 12 && col < anchor + 16) hk_data = `white;  
                    else if ( col > anchor + 15 && col < anchor + 17) hk_data = `black;   
                    else if ( col > anchor + 16 && col < anchor + 20) hk_data = `white;  
                    else if ( col > anchor + 19 && col < anchor + 23) hk_data = `black;                  
                end                                                                                               
                else if (row > 28 && row < 30) begin                                                              
                    if ( col > anchor + 2 && col < anchor + 6) hk_data = `bandana;                                
                    else if ( col > anchor + 9 && col < anchor + 13) hk_data = `black;                          
                    else if ( col > anchor + 12 && col < anchor + 17) hk_data = `white;  
                    else if ( col > anchor + 16 && col < anchor + 18) hk_data = `black;   
                    else if ( col > anchor + 17 && col < anchor + 20) hk_data = `white;  
                    else if ( col > anchor + 19 && col < anchor + 23) hk_data = `black;                         
                end                                                                                               
                else if (row > 29 && row < 31) begin                                                              
                    if ( col > anchor + 1 && col < anchor + 4) hk_data = `bandana;                                
                    else if ( col > anchor + 9 && col < anchor + 13) hk_data = `black;                          
                    else if ( col > anchor + 12 && col < anchor + 20) hk_data = `white;      
                    else if ( col > anchor + 19 && col < anchor + 23) hk_data = `black;                         
                end                                                                                               
                else if (row > 30 && row < 32) begin                                                              
                    if ( col > anchor + 9 && col < anchor + 13) hk_data = `black;                                
                    else if ( col > anchor + 12 && col < anchor + 17) hk_data = `white;                         
                    else if ( col > anchor + 16 && col < anchor + 23) hk_data = `black;                         
                end                                                                                               
                else if (row > 31 && row < 33) begin                                                              
                    if ( col > anchor + 10 && col < anchor + 14) hk_data = `black;                                
                    else if ( col > anchor + 13 && col < anchor + 19) hk_data = `white; 
                    else if ( col > anchor + 18 && col < anchor + 22) hk_data = `black;                         
                end                                                                                               
                else if (row > 32 && row < 34) begin                                                              
                    if ( col > anchor + 11 && col < anchor + 15) hk_data = `black;
                    else if ( col > anchor + 14 && col < anchor + 18) hk_data = `white;                        
                    else if ( col > anchor + 17 && col < anchor + 21) hk_data = `black;                                                        
                end                                                                                               
                else if (row > 33 && row < 35) begin                                                              
                    if ( col > anchor + 12 && col < anchor + 20) hk_data = `black;                                                        
                end                                                                                               
                else if (row > 34 && row < 36) begin                                                              
                    if ( col > anchor + 13 && col < anchor + 19) hk_data = `black;
                    else if ( col > anchor + 28 && col < anchor + 30) hk_data = `black;                                                         
                end                                                                                               
                else if (row > 35 && row < 37) begin                                                              
                    if ( col > anchor + 13 && col < anchor + 19) hk_data = `black;
                    else if ( col > anchor + 27 && col < anchor + 30) hk_data = `black;                                
                end                                                                                               
                //head end, middle start 
                else if (row > 36 && row < 38) begin                                                              
                    if ( col > anchor + 13 && col < anchor + 19) hk_data = `black;
                    else if ( col > anchor + 19 && col < anchor + 30) hk_data = `black;                                
                end 
                else if (row > 37 && row < 39) begin                                                              
                    if ( col > anchor + 13 && col < anchor + 30) hk_data = `black;                               
                end
                else if (row > 38 && row < 40) begin                                                              
                    if ( col > anchor + 13 && col < anchor + 22) hk_data = `black;                               
                end                                                                                          
                else if (row > 39 && row < 41) begin                                                              
                    if ( col > anchor + 13 && col < anchor + 30) hk_data = `black;                                                      
                end                                                                                               
                else if (row > 40 && row < 42) begin                                                              
                    if ( col > anchor + 13 && col < anchor + 30) hk_data = `black;                                                     
                end                                                                                               
                else if (row > 41 && row < 43) begin                                                              
                    if ( col > anchor + 13 && col < anchor + 18) hk_data = `black;                                
                    else if ( col > anchor + 27 && col < anchor + 30) hk_data = `black;                                                   
                end                                                                                               
                else if (row > 42 && row < 44) begin                                                              
                    if ( col > anchor + 13 && col < anchor + 18) hk_data = `black;                                
                    else if ( col > anchor + 28 && col < anchor + 30) hk_data = `black;                       
                end                                                                                               
                else if (row > 43 && row < 45) begin                                                              
                    if ( col > anchor + 13 && col < anchor + 18 ) hk_data = `black;                                                       
                end
                else if (row > 44 && row < 46) begin                                                              
                    if ( col > anchor + 12 && col < anchor + 18) hk_data = `black;                                                               
                end 
                else if (row > 45 && row < 47) begin                                                              
                    if ( col > anchor + 12 && col < anchor + 18) hk_data = `black;                                                                  
                end                                                                                                               
                else if (row > 46 && row < 48) begin                                                              
                    if ( col > anchor + 11 && col < anchor + 19) hk_data = `black;                                                 
                end                                                                                               
                //middle end, lower start                                                                         
                else if (row > 47 && row < 49) begin
                    if ( col > anchor + 11 && col < anchor + 20) hk_data = `black;                                                      
                end                                                                                               
                else if (row > 48 && row < 50) begin                                                              
                    if ( col > anchor + 10 && col < anchor + 15) hk_data = `black;                                
                    if ( col > anchor + 15 && col < anchor + 21) hk_data = `black;                         
                end                                                                                               
                else if (row > 49 && row < 51) begin                                                              
                    if ( col > anchor + 10 && col < anchor + 15) hk_data = `black;                                 
                    if ( col > anchor + 16 && col < anchor + 21) hk_data = `black;                        
                end                                                                                              
                else if (row > 50 && row < 52) begin                                                              
                    if ( col > anchor + 9 && col < anchor + 14) hk_data = `black;                                
                    else if ( col > anchor + 16 && col < anchor + 22) hk_data = `black;                         
                end                                                                                               
                else if (row > 51 && row < 53) begin                                                              
                    if ( col > anchor + 7 && col < anchor + 13) hk_data = `black;                                
                    else if ( col > anchor + 17 && col < anchor + 23) hk_data = `black;                         
                end                                                                                               
                else if (row > 52 && row < 54) begin                                                              
                    if ( col > anchor + 5 && col < anchor + 13) hk_data = `black;                                
                    else if ( col > anchor + 18 && col < anchor + 23) hk_data = `black;                         
                end                                                                                               
                else if (row > 53 && row < 55) begin                                                              
                    if ( col > anchor + 3 && col < anchor + 12) hk_data = `black;                                
                    else if ( col > anchor + 18 && col < anchor + 23) hk_data = `black;                         
                end                                                                                               
                else if (row > 54 && row < 56) begin                                                              
                    if ( col > anchor + 2 && col < anchor + 10) hk_data = `black;                                
                    else if ( col > anchor + 17 && col < anchor + 23) hk_data = `black;                         
                end                                                                                               
                else if (row > 55 && row < 57) begin                                                              
                    if ( col > anchor + 1 && col < anchor + 8) hk_data = `black;                                
                    else if ( col > anchor + 16 && col < anchor + 22) hk_data = `black;                         
                end                                                                                               
                else if (row > 56 && row < 58) begin                                                              
                    if ( col > anchor + 1 && col < anchor + 6) hk_data = `black;                                
                    else if ( col > anchor + 15 && col < anchor + 21) hk_data = `black;                         
                end                                                                                               
                else if (row > 57 && row < 59) begin                                                              
                    if ( col > anchor + 1 && col < anchor + 5) hk_data = `black;                                
                    else if ( col > anchor + 15 && col < anchor + 21) hk_data = `black;                         
                end   
                //lower end
            end
            2'b11: begin 
                if (row > 23 && row < 25) begin                                                              
                    if ( col > anchor + 8 && col < anchor + 14) hk_data = `black;                                                                            
                end     
                else if (row > 24 && row < 26) begin                                                              
                    if ( col > anchor + 7 && col < anchor + 15) hk_data = `black;                                                                                 
                end
                else if (row >  25 && row < 27) begin                                                              
                    if ( col > anchor + 6 && col < anchor + 10) hk_data = `black;   
                    else if ( col > anchor + 9 && col < anchor + 13) hk_data = `white; 
                    else if ( col > anchor + 12 && col < anchor + 16) hk_data = `black;                                                                             
                end      
                else if (row > 26 && row < 28) begin                                                              
                    if ( col > anchor + 5 && col < anchor + 9) hk_data = `black;                                
                    else if ( col > anchor + 8 && col < anchor + 14) hk_data = `white;                          
                    else if ( col > anchor + 13 && col < anchor + 17) hk_data = `black;                         
                end                                                                                               
                else if (row > 27 && row < 29) begin                                                                                             
                    if ( col > anchor + 4 && col < anchor + 8) hk_data = `black;                          
                    else if ( col > anchor + 7 && col < anchor + 11) hk_data = `white;  
                    else if ( col > anchor + 10 && col < anchor + 12) hk_data = `black;   
                    else if ( col > anchor + 11 && col < anchor + 13) hk_data = `white;  
                    else if ( col > anchor + 12 && col < anchor + 14) hk_data = `black; 
                    else if ( col > anchor + 13 && col < anchor + 15) hk_data = `white;  
                    else if ( col > anchor + 14 && col < anchor + 18) hk_data = `black;               
                end                                                                                               
                else if (row > 28 && row < 30) begin                                                              
                    if ( col > anchor + 4 && col < anchor + 8) hk_data = `black;                          
                    else if ( col > anchor + 7 && col < anchor + 10) hk_data = `white;  
                    else if ( col > anchor + 9 && col < anchor + 11) hk_data = `black;   
                    else if ( col > anchor + 10 && col < anchor + 15) hk_data = `white;  
                    else if ( col > anchor + 14 && col < anchor + 18) hk_data = `black;                         
                end                                                                                               
                else if (row > 29 && row < 31) begin                                                              
                    if ( col > anchor + 4 && col < anchor + 8) hk_data = `black;                             
                    else if ( col > anchor + 7 && col < anchor + 15) hk_data = `white;  
                    else if ( col > anchor + 14 && col < anchor + 18) hk_data = `black;                          
                end                                                                                               
                else if (row > 30 && row < 32) begin                                                              
                    if ( col > anchor + 4 && col < anchor + 8) hk_data = `black;                             
                    else if ( col > anchor + 7 && col < anchor + 11) hk_data = `white;  
                    else if ( col > anchor + 10 && col < anchor + 13) hk_data = `black;
                    else if ( col > anchor + 12 && col < anchor + 15) hk_data = `white;
                    else if ( col > anchor + 14 && col < anchor + 18) hk_data = `black;                         
                end                                                                                               
                else if (row > 31 && row < 33) begin                                                              
                    if ( col > anchor + 5 && col < anchor + 9) hk_data = `black;                                
                    else if ( col > anchor + 8 && col < anchor + 14) hk_data = `white;                          
                    else if ( col > anchor + 13 && col < anchor + 17) hk_data = `black;                         
                end                                                                                               
                else if (row > 32 && row < 34) begin                                                              
                    if ( col > anchor + 6 && col < anchor + 10) hk_data = `black;   
                    else if ( col > anchor + 9 && col < anchor + 13) hk_data = `white; 
                    else if ( col > anchor + 12 && col < anchor + 16) hk_data = `black;                                                        
                end                                                                                               
                else if (row > 33 && row < 35) begin                                                              
                    if ( col > anchor + 7 && col < anchor + 15) hk_data = `black;                                                        
                end                                                                                               
                else if (row > 34 && row < 36) begin                                                              
                    if ( col > anchor + 6 && col < anchor + 14) hk_data = `black;                                                       
                end                                                                                               
                else if (row > 35 && row < 37) begin                                                              
                    if ( col > anchor + 5 && col < anchor + 14) hk_data = `black;                               
                end                                                                                               
                //head end, middle start 
                else if (row > 36 && row < 38) begin                                                              
                    if ( col > anchor + 5 && col < anchor + 14) hk_data = `black;                                
                end 
                else if (row > 37 && row < 39) begin                                                              
                    if ( col > anchor + 5 && col < anchor + 14) hk_data = `black;                               
                end
                else if (row > 38 && row < 40) begin                                                              
                    if ( col > anchor + 4 && col < anchor + 11) hk_data = `black;
                    else if ( col > anchor + 11 && col < anchor + 14) hk_data = `black;                               
                end                                                                                          
                else if (row > 39 && row < 41) begin                                                              
                    if ( col > anchor + 4 && col < anchor + 11) hk_data = `black;
                    else if ( col > anchor + 11 && col < anchor + 14) hk_data = `black;                                                      
                end                                                                                               
                else if (row > 40 && row < 42) begin                                                              
                    if ( col > anchor + 4 && col < anchor + 11) hk_data = `black;
                    else if ( col > anchor + 11 && col < anchor + 14) hk_data = `black;                                                     
                end                                                                                               
                else if (row > 41 && row < 43) begin                                                              
                    if ( col > anchor + 4 && col < anchor + 11) hk_data = `black;
                    else if ( col > anchor + 11 && col < anchor + 14) hk_data = `black;                                                   
                end                                                                                               
                else if (row > 42 && row < 44) begin                                                              
                    if ( col > anchor + 4 && col < anchor + 11) hk_data = `black;
                    else if ( col > anchor + 11 && col < anchor + 14) hk_data = `black;                       
                end                                                                                               
                else if (row > 43 && row < 45) begin                                                              
                    if ( col > anchor + 4 && col < anchor + 11) hk_data = `black;
                    else if ( col > anchor + 11 && col < anchor + 14) hk_data = `black;                                                       
                end
                else if (row > 44 && row < 46) begin                                                              
                    if ( col > anchor + 5 && col < anchor + 12) hk_data = `black;                                                               
                end 
                else if (row > 45 && row < 47) begin                                                              
                    if ( col > anchor + 5 && col < anchor + 13) hk_data = `black;                                                                  
                end                                                                                                               
                else if (row > 46 && row < 48) begin                                                              
                    if ( col > anchor + 5 && col < anchor + 14) hk_data = `black;                                                 
                end                                                                                               
                //middle end, lower start                                                                         
                else if (row > 47 && row < 49) begin
                    if ( col > anchor + 6 && col < anchor + 14) hk_data = `black;                                                      
                end                                                                                               
                else if (row > 48 && row < 50) begin                                                              
                    if ( col > anchor + 6 && col < anchor + 14) hk_data = `black;                         
                end                                                                                               
                else if (row > 49 && row < 51) begin                                                              
                    if ( col > anchor + 6 && col < anchor + 10) hk_data = `black;                                 
                    else if ( col > anchor + 10 && col < anchor + 14) hk_data = `black;                        
                end                                                                                              
                else if (row > 50 && row < 52) begin                                                              
                    if ( col > anchor + 6 && col < anchor + 10) hk_data = `black;                                 
                    else if ( col > anchor + 10 && col < anchor + 14) hk_data = `black;                         
                end                                                                                               
                else if (row > 51 && row < 53) begin                                                              
                    if ( col > anchor + 6 && col < anchor + 10) hk_data = `black;                                 
                    else if ( col > anchor + 10 && col < anchor + 14) hk_data = `black;                         
                end                                                                                               
                else if (row > 52 && row < 54) begin                                                              
                    if ( col > anchor + 5 && col < anchor + 10) hk_data = `black;                                 
                    else if ( col > anchor + 10 && col < anchor + 14) hk_data = `black;                         
                end                                                                                               
                else if (row > 53 && row < 55) begin                                                              
                    if ( col > anchor + 4 && col < anchor + 9) hk_data = `black;                                
                    else if ( col > anchor + 9 && col < anchor + 13) hk_data = `black;                         
                end                                                                                               
                else if (row > 54 && row < 56) begin                                                              
                    if ( col > anchor + 4 && col < anchor + 8) hk_data = `black;                                
                    else if ( col > anchor + 9 && col < anchor + 13) hk_data = `black;                         
                end                                                                                               
                else if (row > 55 && row < 57) begin                                                              
                    if ( col > anchor + 3 && col < anchor + 7) hk_data = `black;                                
                    else if ( col > anchor + 8 && col < anchor + 12) hk_data = `black;                         
                end                                                                                               
                else if (row > 56 && row < 58) begin                                                              
                    if ( col > anchor + 1 && col < anchor + 6) hk_data = `black;                                
                    else if ( col > anchor + 8 && col < anchor + 12) hk_data = `black;                         
                end                                                                                               
                else if (row > 57 && row < 59) begin                                                              
                    if ( col > anchor + 1 && col < anchor + 5) hk_data = `black;                                
                    else if ( col > anchor + 7 && col < anchor + 11) hk_data = `black;                         
                end   
                //lower end
            end
            default: begin 
            end
        endcase
    end
    
    
endmodule
