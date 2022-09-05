`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2021 02:27:35
// Design Name: 
// Module Name: volume_main
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


module volume_main(
    input CLOCK, feature, frame_begin, bL, bR,
    input [15:0] sw,
    input [5:0] row,
    input [6:0] col,
    input [11:0] mic_in,
    output reg [15:0] led,
    output reg [15:0] oled_data,
    output reg [7:0] seg, reg [3:0] an
    );
    
    reg [15:0] temp;         // control leds
    reg [31:0] vol_count;    // peak volume in 2000 counts
    reg [15:0] save_temp = 0; 
    reg [1:0] seg_count = 0; // 7 segment 
    reg [3:0] sw2_count = 0; // 7 segment pattern when sw[2] is on

    reg [6:0]L_bound = 40;
    reg [6:0]R_bound = 55;
    reg [4:0]volume = 1; // 1 - 16

    wire [1:0]border_thickness;

    /* ----------- clocks ------------ */
    wire clk6p25m, clk20k, clk381, clk400;
    reg [3:0] count6_25M = 8;
    reg [11:0] count20_k = 2500;
    reg [17:0] count381 = 131234;
    reg [17:0] count400 = 125000;
    
    wire freq_selector;
    wire freq6_25M;
    reg [3:0] SET_COUNT_2 = 8;           // 6.25MHz
    wire freq5;
    reg [31:0] SET_COUNT_4 = 10_000_000; // 5Hz
    wire freq8;
    reg [31:0] SET_COUNT_5 = 6_250_000;  // 8Hz
    wire freq11;
    reg [31:0] SET_COUNT_6 = 4_545_454;  // 11Hz
    wire freq14;
    reg [31:0] SET_COUNT_7 = 3_571_428;  // 14Hz
    wire freq17;
    reg [31:0] SET_COUNT_8 = 2_941_176;  // 17Hz
    wire freq20;
    reg [31:0] SET_COUNT_9 = 2_500_000;  // 20Hz
    wire freq23;
    reg [31:0] SET_COUNT_10 = 2_173_913; // 23Hz
    wire freq400;
    reg [17:0] SET_COUNT_11 = 125_000;   // 400Hz
    
    /* ------------- Module instantiations -------------- */
    modular_clock six_25MHz(CLOCK, count6_25M, clk6p25m);
    modular_clock twenty_kHz(CLOCK, count20_k, clk20k);
    modular_clock four_00Hz(CLOCK, count400, clk400);
    modular_clock three_81Hz(CLOCK, count381, clk381);
    
    modular_clock c2 (CLOCK, SET_COUNT_2, freq6_25M);
    modular_clock c4 (CLOCK, SET_COUNT_4, freq5);
    modular_clock c5 (CLOCK, SET_COUNT_5, freq8);
    modular_clock c6 (CLOCK, SET_COUNT_6, freq11);
    modular_clock c7 (CLOCK, SET_COUNT_7, freq14);
    modular_clock c8 (CLOCK, SET_COUNT_8, freq17);
    modular_clock c9 (CLOCK, SET_COUNT_9, freq20);
    modular_clock c10 (CLOCK, SET_COUNT_10, freq23);
    modular_clock c11 (CLOCK, SET_COUNT_11, freq400);
    
     // 0 is off, 1 is 1 px, 2 is 3 px
     assign border_thickness = sw[15] ? (sw[14] ? 2 : 1): 0;
 
     //buttons
     always @ (posedge clk381) begin
         //move bounds unless out of range   
         if (feature == 0) begin
             if (bL && (L_bound - 3 > 2)) begin 
                 L_bound = L_bound - 3;         
                 R_bound = R_bound - 3;         
             end                                 
             if (bR && (R_bound + 3 < 94)) begin
                 L_bound = L_bound + 3;         
                 R_bound = R_bound + 3;         
             end 
         end
     end
     
     //volume assignment based on mic_in input
     always @ (posedge clk20k) begin 
     
         // toggling between 12-bit mic in and peak intensity         
         if (sw[0] == 0) begin                                        
            led = mic_in;                                            
            end                                                      
        
         if (mic_in > temp) begin
              temp = mic_in;
         end
          
          //volume is refreshed every 1000 cycles, and is set based on the mic_in value using thresholds
          //MONSTER MUX #1
          if (vol_count == 2000) begin
          
              led[0] = (temp >= 2000) ? 1'b1 : 1'b0;   
              led[1] = (temp >= 2133) ? 1'b1 : 1'b0;   
              led[2] = (temp >= 2266) ? 1'b1 : 1'b0;   
              led[3] = (temp >= 2399) ? 1'b1 : 1'b0;   
              led[4] = (temp >= 2532) ? 1'b1 : 1'b0;   
              led[5] = (temp >= 2665) ? 1'b1 : 1'b0;   
              led[6] = (temp >= 2798) ? 1'b1 : 1'b0;   
              led[7] = (temp >= 2931) ? 1'b1 : 1'b0;   
              led[8] = (temp >= 3064) ? 1'b1 : 1'b0;   
              led[9] = (temp >= 3197) ? 1'b1 : 1'b0;   
              led[10] = (temp >= 3330) ? 1'b1 : 1'b0;  
              led[11] = (temp >= 3463) ? 1'b1 : 1'b0;  
              led[12] = (temp >= 3596) ? 1'b1 : 1'b0;  
              led[13] = (temp >= 3729) ? 1'b1 : 1'b0;  
              led[14] = (temp >= 3862) ? 1'b1 : 1'b0;  
              led[15] = (temp >= 3995) ? 1'b1 : 1'b0;  
             
              volume = (temp >= 3862) ? 16: (temp >= 3729) ? 15 : (temp >= 3596) ? 14 : (temp >= 3463) ? 13 : 
              (temp >= 3330) ? 12 : (temp >= 3197) ? 11 : (temp >= 3064) ? 10 : (temp >= 2931) ? 9 :
              (temp >= 2798) ? 8 : (temp >= 2665) ? 7 : (temp >= 2532) ? 6 : (temp >= 2399) ? 5 : 
              (temp >= 2266) ? 4 : (temp >= 2133) ? 3 : (temp >= 2000) ? 2 : 1;
              
              save_temp <= temp; // for 7 segments
              temp <= 0;
          end
          
          vol_count = (vol_count == 2000) ? 0: vol_count + 1;                   
     end
     
     initial begin
         an = 4'b1111;
         seg = 8'b11111111;
     end
     
    /* ------------------  7 segments  ------------------ */
     /* if sw[2] is on, 7 different frequencies based on volume level */
     assign freq_selector = (sw[2] == 1) ? 
                             ((save_temp >= 3596) ? freq23 : (save_temp >= 3330) ? freq20 :
                              (save_temp >= 3064) ? freq17 : (save_temp >= 2798) ? freq14 : 
                              (save_temp >= 2532) ? freq11 : (save_temp >= 2266) ? freq8 : freq5) : clk381;
                              
     always @(posedge freq_selector) begin
         
         case (seg_count)
         /* logic for an[3] : Low Med or High */
         2'd0: begin
             an = 4'b1111;     
             seg = 8'b11111111;
 
             if (sw[1] == 1 && sw[2] != 1) begin
                 an = 4'b0111;
                 seg = (save_temp >= 2000 && save_temp < 2665) ? 8'b11000111 : seg; // L
                 seg = (save_temp >= 2665 && save_temp < 3463) ? 8'b11101010 : seg; // M
                 seg = (save_temp >= 3463) ? 8'b10001001 : seg;                     // H
                 end
             end
         /* an[2] */
         2'd1: begin
             an = 4'b1111;
             seg = 8'b11111111;
                                               
             end
         /* an[1] : show 1*/
         2'd2: begin
             an = 4'b1111;
             seg = 8'b11111111;                                                          
                 
             if (sw[2] != 1) begin
                 an = 4'b1101;
                 seg = (save_temp >= 3330) ? 8'b11111001 : 8'b11111111; // 1 if temp >= 3330
                 end
             end
         /* an[0] : show 0 to 9*/
         2'd3: begin
             an = 4'b1111;
             seg = 8'b11111111;
                                                                   
             if (sw[2] != 1) begin
                 an = 4'b1110;
                 seg = ((save_temp >= 2000 && save_temp < 2133) || (save_temp >= 3330 && save_temp < 3463)) ? 8'b11000000 : seg; // 0 or 10
                 seg = ((save_temp >= 2133 && save_temp < 2266) || (save_temp >= 3463 && save_temp < 3596)) ? 8'b11111001 : seg; // 1 or 11
                 seg = ((save_temp >= 2266 && save_temp < 2399) || (save_temp >= 3596 && save_temp < 3729)) ? 8'b10100100 : seg; // 2 or 12
                 seg = ((save_temp >= 2399 && save_temp < 2532) || (save_temp >= 3729 && save_temp < 3862)) ? 8'b10110000 : seg; // 3 or 13
                 seg = ((save_temp >= 2532 && save_temp < 2665) || (save_temp >= 3862 && save_temp < 3995)) ? 8'b10011001 : seg; // 4 or 14
                 seg = ((save_temp >= 2665 && save_temp < 2798) || save_temp >= 3995) ? 8'b10010010 : seg; // 5 or 15
                 seg = (save_temp >= 2798 && save_temp < 2931) ? 8'b10000010 : seg; // 6
                 seg = (save_temp >= 2931 && save_temp < 3064) ? 8'b11111000 : seg; // 7
                 seg = (save_temp >= 3064 && save_temp < 3197) ? 8'b10000000 : seg; // 8
                 seg = (save_temp >= 3197 && save_temp < 3330) ? 8'b10011000 : seg; // 9
                 end
             end
             
         endcase
         
         /* if sw[2] turns on, start wave pattern */
         if (sw[2] == 1) begin
             case (sw2_count)
             0: begin an = 4'b0111; seg = 8'b11110111; end // L 
             1: begin an = 4'b1011; seg = 8'b10111111; end // M
             2: begin an = 4'b1101; seg = 8'b11111110; end // H
             3: begin an = 4'b1110; seg = 8'b11110111; end // L
             
             4: begin an = 4'b0111; seg = 8'b10111111; end // M
             5: begin an = 4'b1011; seg = 8'b11111110; end // H
             6: begin an = 4'b1101; seg = 8'b11110111; end // L
             7: begin an = 4'b1110; seg = 8'b10111111; end // M
             
             8: begin an = 4'b0111; seg = 8'b11111110; end // H
             9: begin an = 4'b1011; seg = 8'b11110111; end // L
             10: begin an = 4'b1101; seg = 8'b10111111; end // M
             11: begin an = 4'b1110; seg = 8'b11111110; end // H
             
             endcase
             
             sw2_count <= (sw2_count == 11) ? 0 : sw2_count + 1; // pattern count
         
             end
  
         seg_count <= (seg_count == 3) ? 0 : seg_count + 1; // 7 segment count
         
     end // always freq_selector

 
     always @ (*) begin
        if (feature == 0) begin
            //white border, format: top, bottom, left, right
             case(border_thickness) 
                 2'd0: oled_data = `black;
                 2'd1: begin
                     if (row < 1 || row > 62 || col < 1 || col > 94) begin
                         oled_data = 16'hFFFF;
                     end
                     else oled_data = `black;
                 end
                 2'd2: begin
                     if (row < 3 || row > 60 || col < 3 || col > 92) begin
                         oled_data = 16'hFFFF;
                     end
                     else oled_data = `black;
                 end
             endcase
             
             //volume indicator
             case(sw[13]) 
                 1'd0: begin
                     if (row < 61 && row > 13 && col > L_bound && col < R_bound && volume > 15) begin
                         oled_data = `black;
                     end
                     end
                 1'd1: begin
                     if ((row < 61) && (row > 58) && (col > L_bound) && (col < R_bound) && (volume > 0)) begin
                          oled_data = (sw[4] == 1) ? `low2 : `low;
                      end
                      if (row < 58 && row > 55 && col > L_bound && col < R_bound && volume > 1) begin
                          oled_data = (sw[4] == 1) ? `low2 : `low;
                      end
                      if (row < 55 && row > 52 && col > L_bound && col < R_bound && volume > 2) begin
                          oled_data = (sw[4] == 1) ? `low2 : `low;
                      end
                      if (row < 52 && row > 49 && col > L_bound && col < R_bound && volume > 3) begin
                          oled_data = (sw[4] == 1) ? `low2 : `low;
                      end
                      if (row < 49 && row > 46 && col > L_bound && col < R_bound && volume > 4) begin
                          oled_data = (sw[4] == 1) ? `low2 : `low;
                      end
                      if (row < 46 && row > 43 && col > L_bound && col < R_bound && volume > 5) begin
                          oled_data = (sw[4] == 1) ? `med2 : `med;
                      end
                      if (row < 43 && row > 40 && col > L_bound && col < R_bound && volume > 6) begin
                          oled_data = (sw[4] == 1) ? `med2 : `med;
                      end
                      if (row < 40 && row > 37 && col > L_bound && col < R_bound && volume > 7) begin
                          oled_data = (sw[4] == 1) ? `med2 : `med;
                      end
                      if (row < 37 && row > 34 && col > L_bound && col < R_bound && volume > 8) begin
                          oled_data = (sw[4] == 1) ? `med2 : `med;
                      end
                      if (row < 34 && row > 31 && col > L_bound && col < R_bound && volume > 9) begin
                          oled_data = (sw[4] == 1) ? `med2 : `med;
                      end
                      if (row < 31 && row > 28 && col > L_bound && col < R_bound && volume > 10) begin
                          oled_data = (sw[4] == 1) ? `med2 : `med;
                      end
                      if (row < 28 && row > 25 && col > L_bound && col < R_bound && volume > 11) begin
                          oled_data = (sw[4] == 1) ? `high2 : `high;
                      end
                      if (row < 25 && row > 22 && col > L_bound && col < R_bound && volume > 12) begin
                          oled_data = (sw[4] == 1) ? `high2 : `high;
                      end
                      if (row < 22 && row > 19 && col > L_bound && col < R_bound && volume > 13) begin
                          oled_data = (sw[4] == 1) ? `high2 : `high;
                      end
                      if (row < 19 && row > 16 && col > L_bound && col < R_bound && volume > 14) begin
                          oled_data = (sw[4] == 1) ? `high2 : `high;
                      end
                      if (row < 16 && row > 13 && col > L_bound && col < R_bound && volume > 15) begin
                          oled_data = (sw[4] == 1) ? `high2 : `high;
                      end

                     /* L M H on the OLED if sw[3] is on */                                                           
                     if (sw[3] == 1) begin                                                                            
                                                                                                                      
                         /* default - display on the right */                                                         
                         if (R_bound <= 69) begin                                                                     
                             if (volume >= 11) begin // display H                                                     
                                 if ((col > 69 && col < 71 || col > 78 && col < 80) && (row >= 8 && row <= 20) ||     
                                     (row > 13 && row < 15 && col >= 71 && col <= 78)) begin                          
                                     oled_data = `pink_red;                                                           
                                     end                                                                              
                                 end                                                                                  
                             if (volume >= 5 && volume < 11) begin // display M                                       
                                 if (((col > 68 && col < 70 || col > 78 && col < 80) && (row >= 34 && row <= 39)) ||  
                                     ((col > 69 && col < 71 || col > 77 && col < 79) && (row >= 29 && row <= 33)) ||  
                                     ((col > 70 && col < 72 || col > 76 && col < 78) && (row >= 29 && row <= 30)) ||  
                                     ((col > 71 && col < 73 || col > 75 && col < 77) && (row >= 31 && row <= 32)) ||  
                                     ((col > 72 && col < 74 || col > 74 && col < 76) && (row >= 33 && row <= 34)) ||  
                                     ( col > 73 && col < 75 && (row >= 34 && row <= 35))) begin                       
                                     oled_data = `cobalt;                                                             
                                     end                                                                              
                                 end                                                                                  
                             if (volume < 5) begin // display L                                                       
                                 if (col > 69 && col < 71 && row >= 45 && row <= 57 ||                                
                                     row > 56 && row < 58 && col >= 70 && col <= 79) begin                            
                                     oled_data = `parakeet;                                                           
                                     end                                                                              
                                 end                                                                                  
                         end                                                                                          
                                                                                                                      
                         /* else display on the left */                                                               
                         else begin                                                                                   
                             if (volume >= 11) begin // display H                                                     
                                 if ((col > 16 && col < 18 || col > 25 && col < 27) && (row >= 8 && row <= 20) ||     
                                     (row > 13 && row < 15 && col >= 18 && col <= 25)) begin                          
                                     oled_data = `pink_red;                                                           
                                     end                                                                              
                                 end                                                                                  
                             if (volume >= 5 && volume < 11) begin // display M                                       
                                 if (((col > 15 && col < 17 || col > 25 && col < 27) && (row >= 34 && row <= 39)) ||  
                                     ((col > 16 && col < 18 || col > 24 && col < 26) && (row >= 29 && row <= 33)) ||  
                                     ((col > 17 && col < 19 || col > 23 && col < 25) && (row >= 29 && row <= 30)) ||  
                                     ((col > 18 && col < 20 || col > 22 && col < 24) && (row >= 31 && row <= 32)) ||  
                                     ((col > 19 && col < 21 || col > 21 && col < 23) && (row >= 33 && row <= 34)) ||  
                                     ( col > 20 && col < 22 && (row >= 34 && row <= 35))) begin                       
                                     oled_data = `cobalt;                                                             
                                     end                                                                              
                                 end                                                                                  
                             if (volume < 5) begin // display L                                                       
                                 if (col > 16 && col < 18 && row >= 45 && row <= 57 ||                                
                                     row > 56 && row < 58 && col >= 17 && col <= 26) begin                            
                                     oled_data = `parakeet;                                                           
                                     end                                                                              
                                 end                                                                                  
                                                                                                                      
                             end                                                                                      
                     end // if sw[3] == 1                                                                             
                 end // end sw[13] == 1
             endcase // end sw[13] toggle
         end // if feature == 0
     end // always *
     
endmodule
     
     