`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.02.2021 01:45:50
// Design Name: 
// Module Name: water_fill
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


module water_fill(
    input CLOCK, //100 MHz clock
    input [6:0] SW, //7 switches needed for drainage
    output reg [13:0] LED = 0, //EVL LED is LED13
    output reg [7:0] SG = 0, //7 segment display
    output reg [3:0] AN = 4'b1111 //common anode
    
    );
    
    reg [6:0] A; //holding values for switches
    
    reg [24:0] SET_COUNT2 = 16666666; // 3 Hz
    reg [25:0] SET_COUNT3 = 33333333; // 1.5 Hz
    
    reg [5:0] water_count = 0; //water level
    
    //counts for various purposes
    reg [6:0] COUNT = -1;
    reg [4:0] COUNT2  = 0;
    reg [4:0] COUNT3 = 0;
    reg [6:0] COUNT4 = -1;
    reg [6:0] COUNT5 = 0;
    
    reg EMPTY = 0; //empty water tank check
    reg FULL = 0; //full water tank check
    
    wire freq3_0; //clock 3 Hz
    wire freq1_5; //clock 1.5 Hz
    
    modular_clock water_drop ( CLOCK, SET_COUNT2, freq3_0);
    modular_clock seg_disp ( CLOCK, SET_COUNT3, freq1_5);
    
    //3 Hz clock, water droplets move at this rate
    always @ (posedge freq3_0) begin
    COUNT4 = COUNT4 + 1;
    
    //once switch turns on, A value holds
    if (SW[0] && FULL == 1) A[0] = 1;
    if (SW[1] && FULL == 1) A[1] = 1;
    if (SW[2] && FULL == 1) A[2] = 1;
    if (SW[3] && FULL == 1) A[3] = 1;
    if (SW[4] && FULL == 1) A[4] = 1;
    if (SW[5] && FULL == 1) A[5] = 1;
    if (SW[6] && FULL == 1) A[6] = 1;
    
    //water drains when switches are correct and tank is full; will drain at 1.5 Hz
    if ((A == 7'b1111111) && (FULL == 1) && (COUNT4 % 2 == 0)) begin
        LED[13] <= 0;
        LED[12] <= LED[12] ? (LED[13] ? 1 : 0) : 0;
        LED[11] <= LED[11] ? (LED[12] ? 1 : 0) : 0;
        LED[10] <= LED[10] ? (LED[11] ? 1 : 0) : 0;
        LED[9] <= LED[9] ? (LED[10] ? 1 : 0) : 0;
        LED[8] <= LED[8] ? (LED[9] ? 1 : 0) : 0;
        LED[7] <= LED[7] ? (LED[8] ? 1 : 0) : 0;
        LED[6] <= LED[6] ? (LED[7] ? 1 : 0) : 0;
        LED[5] <= LED[5] ? (LED[6] ? 1 : 0) : 0;
        LED[4] <= LED[4] ? (LED[5] ? 1 : 0) : 0;
        LED[3] <= LED[3] ? (LED[4] ? 1 : 0) : 0;
        LED[2] <= LED[2] ? (LED[3] ? 1 : 0) : 0;
        LED[1] <= LED[1] ? (LED[2] ? 1 : 0) : 0;
        LED[0] <= LED[0] ? (LED[1] ? 1 : 0) : 0; 
    
        COUNT2 = COUNT2 + 1;
    
    if (COUNT2 >= 14)begin
        EMPTY = 1; //tank is empty
    end
    
    end
    
    //water filling
    if ((A != 7'b1111111) || (FULL == 0)) begin
    COUNT = COUNT + 1;
   
    //water_count increases every 4th cycle, 0.75Hz
    if (COUNT % 4 == 0 && water_count != 14) begin
        water_count = water_count + 1;
    end
    
    //check adjacent LEDs before moving signal
    LED[0] <= LED[0] ? LED[0] : (LED[1] ? 1 : 0);
    LED[1] <= LED[1] ? (LED[0] ? 1 : 0) : (LED[2] ? 1 : 0);
    LED[2] <= LED[2] ? (LED[1] ? 1 : 0) : (LED[3] ? 1 : 0);
    LED[3] <= LED[3] ? (LED[2] ? 1 : 0) : (LED[4] ? 1 : 0);
    LED[4] <= LED[4] ? (LED[3] ? 1 : 0) : (LED[5] ? 1 : 0);
    LED[5] <= LED[5] ? (LED[4] ? 1 : 0) : (LED[6] ? 1 : 0);
    LED[6] <= LED[6] ? (LED[5] ? 1 : 0) : (LED[7] ? 1 : 0);
    LED[7] <= LED[7] ? (LED[6] ? 1 : 0) : (LED[8] ? 1 : 0);
    LED[8] <= LED[8] ? (LED[7] ? 1 : 0) : (LED[9] ? 1 : 0);
    LED[9] <= LED[9] ? (LED[8] ? 1 : 0) : (LED[10] ? 1 : 0);
    LED[10] <= LED[10] ? (LED[9] ? 1 : 0) : (LED[11] ? 1 : 0);
    LED[11] <= LED[11] ? (LED[10] ? 1 : 0) : (LED[12] ? 1 : 0);
    LED[12] <= LED[12] ? (LED[11] ? 1 : 0) : (LED[13] ? 1 : 0);
    
    if (water_count >= 14) begin
        //0.37 Hz blink
        case(COUNT5)
        5'd0: begin
            LED[13] = 1;
            FULL = 1; //tank is full
        end
        5'd1: LED[13] = 1;
        5'd2: LED[13] = 1;
        5'd3: LED[13] = 1;
        5'd4: LED[13] = 1;
        5'd5: LED[13] = 1;
        5'd6: LED[13] = 1;
        5'd7: LED[13] = 1;
        5'd8: LED[13] = 0;
        5'd9: LED[13] = 0;
        5'd10: LED[13] = 0;
        5'd11: LED[13] = 0;
        5'd12: LED[13] = 0;
        5'd13: LED[13] = 0;
        5'd14: LED[13] = 0;
        5'd15: begin
            LED[13] = 0;
            COUNT5 = -1;
        end 
        endcase
        COUNT5 = COUNT5 + 1;
    end
    else begin
        LED[13] <= (COUNT % 4 == 0) ? 1 : 0; //0.75 Hz water droplets
    end
    
    end
    
    end
    
    //SEGMENT DISPLAY
    always @ (posedge freq1_5) begin
    //display starts when tank is full
    if ((water_count >= 14) && (EMPTY == 0)) begin
    AN = 4'b0010; //turn on appropriate common anodes
    case (COUNT3)
    4'b0: SG = 8'b11111110; //DP
    4'd1: SG = 8'b11110101; //R
    4'd2: SG = 8'b01100001; //E
    4'd3: SG = 8'b11100011; //L
    4'd4: SG = 8'b01100001; //E
    4'd5: SG = 8'b00010001; //A
    4'd6: SG = 8'b01001001; //S
    4'd7: SG = 8'b01100001; //E
    4'd8: SG = 8'b11111101; //-
    4'd9: SG = 8'b10101011; //W
    4'd10: SG = 8'b00010001; //A
    4'd11: SG = 8'b11100001; //T
    4'd12: SG = 8'b01100001; //E
    4'd13: SG = 8'b11110101; //R
    4'd14: SG = 8'b11111101; //-
    4'd15: SG = 8'b11010101; //N
    5'd16: SG = 8'b00000011; //O
    5'd17: begin
        SG = 8'b10101011; //W
        COUNT3 = -1; //reset loop
    end
    endcase
    COUNT3 = COUNT3 + 1;
    end
    
    else begin
        SG = 8'b11111111; //turn everything off
    end

    end
    
endmodule
