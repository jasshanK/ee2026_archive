`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//
//  LAB SESSION DAY (Delete where applicable): TUESDAY P.M
//
//  STUDENT A NAME: Daryl Ang Jia Jun
//  STUDENT A MATRICULATION NUMBER: A0214978N
//
//  STUDENT B NAME: Jasshan Kumeresh
//  STUDENT B MATRICULATION NUMBER: A0216402W
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input  J_MIC3_Pin3,   
    output J_MIC3_Pin1,  
    output J_MIC3_Pin4,
    
    input CLK100MHZ,
    input btnC, btnL, btnR, btnU,
    input [15:0] sw,
    output [15:0] led,
    output [7:0] JB,
    output [7:0] seg, [3:0] an
    );
    
    wire frame_begin, sending_pixels, sample_pixel;
    wire [12:0] pixel_index; //current pixel being updated
    wire F; //reset
    
    wire bL, bR, bU;
    
    wire [5:0]row;
    wire [6:0]col;

    wire [11:0] mic_in;
    reg [11:0] temp;
    reg [9:0] vol_count;

    wire [15:0] main_oled_data;
    
    //feature oled outputs
    wire [15:0] ryu_oled, volume_oled;
    
    //switch between features, 0 for volume_main, 1 for ryu_main
    reg [3:0] feature;
    
    //Clocks 
    wire clk6p25m, clk20k, clk381, clk400;
    reg [3:0] count6_25M = 8;
    reg [11:0] count20_k = 2500;
    reg [17:0] count381 = 131234;
    reg [17:0] count400 = 125000;
    
    modular_clock six_25MHz(CLK100MHZ, count6_25M, clk6p25m);
    modular_clock twenty_kHz(CLK100MHZ, count20_k, clk20k);
    modular_clock four_00Hz(CLK100MHZ, count400, clk400);
    modular_clock three_81Hz(CLK100MHZ, count381, clk381);
    
    //Oled_Display instnatiation
    Oled_Display oled(.clk(clk6p25m), .reset(F), .pixel_data(main_oled_data), 
                      .frame_begin(frame_begin), .sending_pixels(sending_pixels), .sample_pixel(sample_pixel), .pixel_index(pixel_index), 
                      .cs(JB[0]), .sdin(JB[1]), .sclk(JB[3]), .d_cn(JB[4]), .resn(JB[5]), .vccen(JB[6]),.pmoden(JB[7])
                      );
    
    //Audio_Capture instantiation
    Audio_Capture mic(.CLK(CLK100MHZ), .cs(clk20k), .MISO(J_MIC3_Pin3), .clk_samp(J_MIC3_Pin1), .sclk(J_MIC3_Pin4), .sample(mic_in));
    
    //VOLUME
    volume_main vol(.CLOCK(CLK100MHZ), .feature(feature), .frame_begin(frame_begin),
     .sw(sw), .row(row), .col(col), .mic_in(mic_in), .oled_data(volume_oled), .bL(bL), .bR(bR),
     .led(led), .seg(seg), .an(an));
    
    //RYU
    ryu_main ryu(.CLOCK(clk6p25m), .mic_in(mic_in),.feature(feature),.pixel_index(pixel_index),.frame_begin(frame_begin),
     .oled_data(ryu_oled), .bL(bL), .bR(bR), .row(row), .col(col), .clk6p25m(clk6p25m), .clk381(clk381));
    
    //debounced single output
    deb_single_out dbs1(.CLOCK(clk400), .D1(btnC), .F(F));
    deb_single_out dbs2(.CLOCK(clk400), .D1(btnL), .F(bL));
    deb_single_out dbs3(.CLOCK(clk400), .D1(btnR), .F(bR));
    deb_single_out dbs4(.CLOCK(clk400), .D1(btnU), .F(bU));
    
    //row and col mapping based on pixel index
    assign row = pixel_index / 96; //64 rows
    assign col = pixel_index % 96; //96 rows
    
    //switching oled data
    assign main_oled_data = (feature == 0) ? volume_oled : (feature == 1) ? ryu_oled : main_oled_data;
    
    always @ (*) begin
        if (~sw[12] & sw[11]) feature = 0;
        else if (sw[12] & ~sw[11]) feature = 1;
        else feature = feature;
    end

endmodule