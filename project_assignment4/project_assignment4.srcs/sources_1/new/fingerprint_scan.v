`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2021 09:36:05
// Design Name: 
// Module Name: fingerprint_scan
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


module fingerprint_scan(
    input BC,
    input BL,
    input BR,
    input BU,
    input CLOCK,
    input [3:0] SW,
    output reg [15:0] LED,
    output reg [3:0] AN,
    output reg [7:0] SEG
    );
    
    wire freq5_95;
    wire freq0_745;
    wire freq381;
    wire freq400;
    
    wire safe_selector;
    
    reg [23:0] count5_95 = 8400000;
    reg [26:0] count0_745 = 67100000;
    reg [17:0] count381 = 131234;
    reg [17:0] count400 = 125000;

    reg [4:0] count_safe = 0;
    reg [4:0] count_matric = 0;
    reg [11:0] count5_37s = 0; //count to 2050, 5.37 seconds
    reg [12:0] count10_74s = 0; //count to 4092, 10.74 seconds at 381 hz
       
    reg lit_check = 0;
    reg safe_check = 0;
    reg matric_check = 0;
    reg sub_b_check = 0;
    
    //rooms, left to right
    wire room_l;
    wire room_c;
    wire room_r;
    wire reset;
    
    //counting number of ppl in a room
    reg [2:0] count_l = 0;
    reg [2:0] count_c = 0;
    reg [2:0] count_r = 0;
    reg [30:0] count_b = 0;
    
    //checking where a person entered last
    reg check_l = 0;
    reg check_c = 0;
    reg check_r = 0;
    
    reg breach_check_l = 0;
    reg breach_check_c = 0;
    reg breach_check_r = 0;
    reg breach_check = 0;
    
    reg l_clock = 0;
    reg c_clock = 0;
    reg r_clock = 0;
    
    reg fast_count;
    reg slow_count;
    reg [2:0] b_anode_count = 0;
    reg [3:0] chances = 8;

    
    modular_clock five_95HZ(.CLOCK(CLOCK), .SET_COUNT(count5_95), .set_freq(freq5_95));
    modular_clock zero_745HZ(.CLOCK(CLOCK), .SET_COUNT(count0_745), .set_freq(freq0_745));
    modular_clock three81HZ(.CLOCK(CLOCK), .SET_COUNT(count381), .set_freq(freq381));
     modular_clock four00HZ(.CLOCK(CLOCK), .SET_COUNT(count400), .set_freq(freq400));
    
    //button single output
    single_output buttonL(.CLOCK(freq400), .D1(BL), .F(room_l));
    single_output buttonC(.CLOCK(freq400), .D1(BC), .F(room_c));
    single_output buttonR(.CLOCK(freq400), .D1(BR), .F(room_r));
    single_output buttonU(.CLOCK(freq400), .D1(BU), .F(reset));
    
    initial begin
        AN = 4'b1111;
        SEG = 8'b00000000;
    end
    
    //when button is pressed down, LEDs light up
    always @ (posedge freq5_95) begin 
        if (LED == 16'b1111111111111111) begin
            lit_check = 1;
        end

        if (BC == 1 && lit_check == 0) begin
            LED[0] <= 1;
            LED[1] <= LED[1] ? 1 : LED[0];
            LED[2] <= LED[2] ? 1 : LED[1];
            LED[3] <= LED[3] ? 1 : LED[2];
            LED[4] <= LED[4] ? 1 : LED[3];
            LED[5] <= LED[5] ? 1 : LED[4];
            LED[6] <= LED[6] ? 1 : LED[5];
            LED[7] <= LED[7] ? 1 : LED[6];
            LED[8] <= LED[8] ? 1 : LED[7];
            LED[9] <= LED[9] ? 1 : LED[8];
            LED[10] <= LED[10] ? 1 : LED[9];
            LED[11] <= LED[11] ? 1 : LED[10];
            LED[12] <= LED[12] ? 1 : LED[11];
            LED[13] <= LED[13] ? 1 : LED[12];
            LED[14] <= LED[14] ? 1 : LED[13];
            LED[15] <= LED[15] ? 1 : LED[14];
        end
        
        if (BC == 0 && lit_check == 0) begin
            LED <= 0;
        end
    end
    
    //safe clock selector
    assign safe_selector = safe_check ? freq381 : freq0_745;
    
    //SAFE feature
    always @ (posedge safe_selector) begin
        if (count5_37s > 2049) begin
            matric_check = 1;
        end
        
        if (lit_check == 1 && BC == 0 && matric_check == 0 && sub_b_check == 0) begin
            case (count_safe) 
                1'd0: begin
                    AN = 4'b0111;
                    SEG = 8'b01001001; //S
                end
                1'd1: begin
                    AN = 4'b1011;
                    SEG = 8'b00010001; //A
                end
                2'd2: begin
                    AN = 4'b1101;
                    SEG = 8'b01110001; //F
                end
                2'd3: begin
                    AN = 4'b1110;
                    SEG = 8'b01100001; //E
                end
                3'd4: begin
                   safe_check = 1; 
                end
            endcase
        end
        
        if (matric_check == 1 && sub_b_check == 0) begin
            case (count_matric)
                1'd0: begin
                    if (SW[3] == 0) begin
                        AN = 4'b0111;
                        SEG = 8'b01000001; //6
                    end
                    else begin
                        AN = 4'b1111;
                        SEG = 8'b11111111;
                    end
                end
                1'd1: begin
                    if (SW[2] == 0) begin
                        AN = 4'b1011;
                        SEG = 8'b10011001; //4
                    end
                    else begin
                        AN = 4'b1111;
                        SEG = 8'b11111111;
                    end
                end
                2'd2: begin
                    if (SW[1] == 0) begin
                        AN = 4'b1101;
                        SEG = 8'b00000011; //0
                    end
                    else begin
                        AN = 4'b1111;
                        SEG = 8'b11111111;
                    end
                end
                2'd3: begin
                    if (SW[0] == 0) begin
                        AN = 4'b1110;
                        SEG = 8'b00100101; //2
                        safe_check = 1;
                    end
                    else begin
                        AN = 4'b1111;
                        SEG = 8'b11111111;
                    end
                end
            endcase
        end
        
        if (lit_check == 1 && BC == 0) begin
            count_safe = count_safe == 4 ? 0 : count_safe + 1;
            count_matric = count_matric == 4 ? 0 : count_matric + 1;
        end
        
        count5_37s = count5_37s + 1; 
        
        //------------------------------------------------------------------------//
        
        //sub task b activates//
        if (SW == 4'b1111) begin
            sub_b_check = 1;
        end
        
        if (sub_b_check == 1) begin
            AN = 4'b0000;
            
            //reset
            if (reset == 1) begin
                //breaches
                breach_check = 0;
                breach_check_l = 0;
                breach_check_c = 0;
                breach_check_r = 0;
                
                //counts
                count_l = 0;
                count_c = 0;
                count_r = 0;
                
                //chances
                chances = 8;
                
                //entry checks
                check_l = 0;
                check_c = 0;
                check_r = 0;
                
                //counts
                count_b = 0;
                count10_74s = 0;
            end
            
            //rule 4
            if (count_b == 1105 && (count_l + count_c + count_r) != 9) begin
                chances = chances - 3;
            end
            
            //rules 1-3
            //entering left room
            if (breach_check == 0) begin
                if (room_l == 1) begin
                    if (breach_check_l == 0 && check_l == 0 && (count_l + 1 - count_c) < 2 && (count_l + 1 - count_r) < 2 && count_l + 1 < 4) begin
                        count_l = count_l + 1;
                        
                        //room last entered
                        check_l = 1;
                        check_c = 0;
                        check_r = 0;
                    end
                    else begin
                        breach_check_l = 1;
                        chances = chances - 1;
                    end
                end
    
                //entering center room
                if (room_c == 1) begin
                    if (breach_check_c == 0 && check_c == 0 && (count_c + 1 - count_l) < 2 && (count_c + 1 - count_r) < 2 && count_c + 1 < 4) begin
                        count_c = count_c + 1;
                        
                        //room last entered
                        check_l = 0;
                        check_c = 1;
                        check_r = 0;
                    end
                    else begin
                        breach_check_c = 1;
                        chances = chances - 1;
                    end
                end
                
                //entering right room
                if (room_r == 1) begin
                    if (breach_check_r == 0 && check_r == 0 && (count_r + 1 - count_l) < 2 && (count_r + 1 - count_c) < 2 && count_r + 1 < 4) begin
                        count_r = count_r + 1;
                        
                        //room last entered
                        check_l = 0;
                        check_c = 0;
                        check_r = 1;
                    end
                    else begin
                        breach_check_r = 1;
                        chances = chances - 1;
                    end
                end
            end
            
            //chances cannot go below zero 
            if (chances < 0) begin
                chances = 0;
            end
            
            //checking whether rules 1-3 are broken, to disable all room entry
            breach_check = (breach_check_l == 1 || breach_check_c == 1 || breach_check_r == 1) ? 1 : 0; 
            
            //slow count at 1.49hz, approx every 256 counts at 381 hz
            slow_count = (count_b % 128) == 0 ? ~slow_count : slow_count; 
            
            //clock selector, fast = 381 hz, slow = 1.49 hz, when chances == 0, no more blinking
            l_clock = (breach_check_l && chances > 0) ? slow_count: 1; 
            r_clock = (breach_check_r && chances > 0) ? slow_count: 1;
            c_clock = (breach_check_c && chances > 0) ? slow_count: 1;
            
            //cooldown period of 10.74s
            if (breach_check == 1) begin
                count10_74s = count10_74s == 4092 ? 0 : count10_74s + 1;
                if (count10_74s == 0) begin
                    breach_check = 0;
                    breach_check_l = 0;
                    breach_check_r = 0;
                    breach_check_c = 0;
                end
            end            
            
            //anode display for system b
            case(b_anode_count)
                1'd0: begin //anode 0
                    AN = 4'b1110; 
                    case(chances)
                    1'd0: SEG = 8'b11100011; //L
                    1'd1: SEG = 8'b10011111; //1
                    2'd2: SEG = 8'b00100101; //2
                    2'd3: SEG = 8'b00001101; //3
                    3'd4: SEG = 8'b10011001; //4
                    3'd5: SEG = 8'b01001001; //5
                    3'd6: SEG = 8'b01000001; //6
                    3'd7: SEG = 8'b00011111; //7
                    4'd8: SEG = 8'b00000001; //8
                    endcase
                end
                1'd1: begin //anode 1
                    AN = 4'b1101; 
                    if (r_clock == 1) begin
                        if (chances != 0) begin
                            case(count_r)
                            1'd0: SEG = 8'b11111111; //no tick
                            1'd1: SEG = 8'b11101111; //1 tick
                            2'd2: SEG = 8'b11101101; //2 tick
                            2'd3: SEG = 8'b01101101; //3 tick
                            endcase
                        end
                        if (chances == 0) begin
                            SEG = 8'b11110011; //I
                        end
                    end
                    else begin
                        SEG = 8'b11111111;
                    end
                end
                2'd2: begin //anode 2
                    AN = 4'b1011;
                    if (c_clock == 1) begin
                        if (chances != 0) begin 
                            case(count_c)
                            1'd0: SEG = 8'b11111111; //no tick
                            1'd1: SEG = 8'b11101111; //1 tick
                            2'd2: SEG = 8'b11101101; //2 tick
                            2'd3: SEG = 8'b01101101; //3 tick
                            endcase
                        end
                        if (chances == 0) begin
                            SEG = 8'b00010001; //A
                        end
                    end
                    else begin
                        SEG = 8'b11111111;
                    end
                end
                2'd3: begin //anode 3
                    AN = 4'b0111;
                    if (l_clock == 1) begin
                        if (chances != 0) begin 
                            case(count_l)
                            1'd0: SEG = 8'b11111111; //no tick
                            1'd1: SEG = 8'b11101111; //1 tick
                            2'd2: SEG = 8'b11101101; //2 tick
                            2'd3: SEG = 8'b01101101; //3 tick
                            endcase
                        end
                        if (chances == 0) begin
                            SEG = 8'b01110001; //F
                        end
                    end
                    else begin
                        SEG = 8'b11111111;
                    end
                end
            endcase
            
             //b anode display case statement count
            b_anode_count = b_anode_count == 3 ? 0 : b_anode_count + 1;
            count_b = count_b + 1;
        end //sub task b ends
    end 
    
    
    
endmodule

