`timescale 1ns / 1ps

module ryu_main(
    input CLOCK, feature, frame_begin, bL, bR, clk6p25m, clk381, clk20k,
    input [12:0] pixel_index,
    input [5:0] row,
    input [6:0] col,
    input [11:0] mic_in,
    output [15:0] oled_data
    );
    
    reg [3:0] main_state, main_nextstate;
    
    reg [8:0] anchor;
    reg [22:0] count_frame;
    reg [24:0] charge;
    reg [24:0] tired;
    reg [23:0] shot_frame;
    reg [2:0] hadouken_state;
    reg [8:0] f_counter;
    reg [22:0] base_count;
    reg fd_trigger, bd_trigger, hk_trigger, right_splat;
    
    reg [15:0] ryu_data;
    wire [15:0] hk_data;
    
    //states
    parameter stand = 2'b00, f1 = 2'b01, f2 = 2'b10, b1 = 2'b11, h1 = 3'b100, h2 = 3'b101, h3 = 3'b110, w1 = 3'b111;
    
    //frame count to control speed 
    parameter frame_count = 1250000, shot_count = 12500000, charge_count = 6250000;
    
    //charge and tired time    
    parameter charge_t = 7500000, tired_t = 15625000;
    
    //activation area colour
    reg [15:0] area;
    
    //volumed detection level
    parameter volume = 2700;
    
    initial begin
        main_state = stand;
        fd_trigger = 0;
        bd_trigger = 0;
        hk_trigger = 0;
        hadouken_state = 0;
        anchor = 0; // coordiante (0,0)
    end
    
    assign oled_data = ryu_data;

    //button inputs
    always @ (posedge clk381) begin
        if (feature == 1) begin
            if (bR && anchor + 21 < 95 && main_state == stand) begin
                fd_trigger = 1;
                anchor = anchor + 3; 
            end
            else if (bR && anchor + 21 > 94 && main_state == stand) right_splat = 1;
            else begin
                fd_trigger = 0;
                right_splat = 0;
            end
            
            if (bL && anchor - 3 > 0 && main_state == stand) begin
                bd_trigger = 1;
                anchor = anchor - 2;
            end
            else bd_trigger = 0;
            
            
        end
    end
    
    //next state and frames
    always @ (posedge clk6p25m) begin
        if (feature == 1) begin
            main_state <= main_nextstate;
            //controls how long 1 frame is on the screen
            if (main_state == f1 || main_state == f2 || main_state == b1 || main_state == h1 || main_state == w1) begin
                count_frame <= (count_frame == charge_count) ? 0 : count_frame + 1;
            end
            else count_frame <= 0;
            
            if (main_state == h2) begin
                shot_frame <= (shot_frame == shot_count) ? 0 : shot_frame + 1;
            end
            else shot_frame <= 0;
            
            //cooldown while hadouken fires
            if (main_state == h3) begin
                tired <= (tired == tired_t) ? 0 : tired + 1; 
            end
            else tired <= 0;
            
            //play sound for a certain amount of time for it to trigger
            if (mic_in >= volume && anchor < 10 && (main_state == stand || main_state == h1)) begin
                charge <= (charge == charge_t) ? 0 : charge + 1;
                hk_trigger = (charge == charge_t) ? 1 : 0;
            end
            
            if (main_state == h2 || main_state == h3) begin
                    base_count <= (base_count == 6250000) ? 0 : base_count + 1;
                    f_counter <= (base_count % 250000 == 0) ? f_counter + 1 : (base_count == 6250000) ? 0 : f_counter;
                end
                else begin
                    base_count = 0;
                    f_counter = 0;
            end
            
            if (anchor < 10) area = `red;
            else if (anchor < 30) area = `yellow;
            else area = `grass;
        end
    end
    
    
    //ryu doing stuff
    always @ (*) begin
        if (feature == 1) begin
            //bg
            if (row > 0) begin
                ryu_data = `sky_blue;
            end 
            if (row > 58) begin
                ryu_data = `grass;
            end
            
            if (row > 58 && col < 25) begin
                ryu_data = area;
            end
            
            //HADOUKEN
            if (main_state == h2 || main_state == h3) begin
                if ( row > 31 && row < 33) begin
                    if (col > anchor + f_counter + 37 && col < anchor + f_counter + 46) ryu_data = `orange;
                end
                else if ( row > 32 && row < 34) begin
                    if (col > anchor + f_counter + 35 && col < anchor + f_counter + 47) ryu_data = `orange;
                end
                else if ( row > 33 && row < 35) begin
                    if (col > anchor + f_counter + 38 && col < anchor + f_counter + 41) ryu_data = `orange;
                    else if (col > anchor + f_counter + 40 && col < anchor + f_counter + 43) ryu_data = `yellow;
                    else if (col > anchor + f_counter + 42 && col < anchor + f_counter + 48) ryu_data = `orange;
                end
                else if ( row > 34 && row < 36) begin
                    if (col > anchor + f_counter + 36 && col < anchor + f_counter + 40) ryu_data = `orange;
                    else if (col > anchor + f_counter + 39 && col < anchor + f_counter + 45) ryu_data = `yellow;
                    else if (col > anchor + f_counter + 44 && col < anchor + f_counter + 49) ryu_data = `orange;
                end
                else if ( row > 35 && row < 37) begin
                    if (col > anchor + f_counter + 34 && col < anchor + f_counter + 38) ryu_data = `orange;
                    else if (col > anchor + f_counter + 37 && col < anchor + f_counter + 46) ryu_data = `yellow;
                    else if (col > anchor + f_counter + 45 && col < anchor + f_counter + 50) ryu_data = `orange;
                end
                else if ( row > 36 && row < 38) begin
                    if (col > anchor + f_counter + 32 && col < anchor + f_counter + 36) ryu_data = `orange;
                    else if (col > anchor + f_counter + 35 && col < anchor + f_counter + 39) ryu_data = `yellow;
                    else if (col > anchor + f_counter + 38 && col < anchor + f_counter + 42) ryu_data = `beige;
                    else if (col > anchor + f_counter + 41 && col < anchor + f_counter + 47) ryu_data = `yellow;
                    else if (col > anchor + f_counter + 46 && col < anchor + f_counter + 51) ryu_data = `orange;
                end
                else if ( row > 37 && row < 39) begin
                    if (col > anchor + f_counter + 31 && col < anchor + f_counter + 34) ryu_data = `orange;
                    else if (col > anchor + f_counter + 33 && col < anchor + f_counter + 37) ryu_data = `yellow;
                    else if (col > anchor + f_counter + 36 && col < anchor + f_counter + 44) ryu_data = `beige;
                    else if (col > anchor + f_counter + 43 && col < anchor + f_counter + 47) ryu_data = `yellow;
                    else if (col > anchor + f_counter + 46 && col < anchor + f_counter + 51) ryu_data = `orange;
                end
                else if ( row > 38 && row < 40) begin
                    if (col > anchor + f_counter + 30 && col < anchor + f_counter + 33) ryu_data = `orange;
                    else if (col > anchor + f_counter + 32 && col < anchor + f_counter + 35) ryu_data = `yellow;
                    else if (col > anchor + f_counter + 34 && col < anchor + f_counter + 45) ryu_data = `beige;
                    else if (col > anchor + f_counter + 44 && col < anchor + f_counter + 47) ryu_data = `yellow;
                    else if (col > anchor + f_counter + 46 && col < anchor + f_counter + 51) ryu_data = `orange;
                end
                else if ( row > 39 && row < 41) begin
                    if (col > anchor + f_counter + 31 && col < anchor + f_counter + 34) ryu_data = `orange;
                    else if (col > anchor + f_counter + 33 && col < anchor + f_counter + 37) ryu_data = `yellow;
                    else if (col > anchor + f_counter + 36 && col < anchor + f_counter + 44) ryu_data = `beige;
                    else if (col > anchor + f_counter + 43 && col < anchor + f_counter + 47) ryu_data = `yellow;
                    else if (col > anchor + f_counter + 46 && col < anchor + f_counter + 51) ryu_data = `orange;
                end
                else if ( row > 40 && row < 42) begin
                    if (col > anchor + f_counter + 32 && col < anchor + f_counter + 36) ryu_data = `orange;
                    else if (col > anchor + f_counter + 35 && col < anchor + f_counter + 39) ryu_data = `yellow;
                    else if (col > anchor + f_counter + 38 && col < anchor + f_counter + 42) ryu_data = `beige;
                    else if (col > anchor + f_counter + 41 && col < anchor + f_counter + 47) ryu_data = `yellow;
                    else if (col > anchor + f_counter + 46 && col < anchor + f_counter + 51) ryu_data = `orange;
                end
                else if ( row > 41 && row < 43) begin
                    if (col > anchor + f_counter + 34 && col < anchor + f_counter + 38) ryu_data = `orange;
                    else if (col > anchor + f_counter + 37 && col < anchor + f_counter + 46) ryu_data = `yellow;
                    else if (col > anchor + f_counter + 45 && col < anchor + f_counter + 50) ryu_data = `orange;
                end
                else if ( row > 42 && row < 44) begin
                    if (col > anchor + f_counter + 36 && col < anchor + f_counter + 40) ryu_data = `orange;
                    else if (col > anchor + f_counter + 39 && col < anchor + f_counter + 45) ryu_data = `yellow;
                    else if (col > anchor + f_counter + 44 && col < anchor + f_counter + 49) ryu_data = `orange;
                end
                else if ( row > 43 && row < 45) begin
                    if (col > anchor + f_counter + 38 && col < anchor + f_counter + 41) ryu_data = `orange;
                    else if (col > anchor + f_counter + 40 && col < anchor + f_counter + 43) ryu_data = `yellow;
                    else if (col > anchor + f_counter + 42 && col < anchor + f_counter + 48) ryu_data = `orange;
                    else if (col > anchor + f_counter + 42 && col < anchor + f_counter + 48) ryu_data = `orange;
                end
                else if ( row > 44 && row < 46) begin
                    if (col > anchor + f_counter + 35 && col < anchor + f_counter + 47) ryu_data = `orange;
                end
                if ( row > 45 && row < 47) begin
                    if (col > anchor + f_counter + 37 && col < anchor + f_counter + 46) ryu_data = `orange;
                end
            end
            
            
            case (main_state)
                stand : begin
                //STANDING FRAME
                //head start
                if ( col > anchor + 5 && col < anchor + 11 && row > 21 && row < 23) ryu_data = `black;
                else if ( col > anchor + 4 && col < anchor + 12 && row >  22 && row < 24) ryu_data = `black;
                else if (row > 23 && row < 25) begin
                    if ( col > anchor + 3 && col < anchor + 7) ryu_data = `black;
                    else if ( col > anchor + 6 && col < anchor + 10) ryu_data = `white;
                    else if ( col > anchor + 9 && col < anchor + 13) ryu_data = `black;
                end
                else if (row > 24 && row < 26) begin
                    if ( col > anchor + 2 && col < anchor + 6) ryu_data = `black;
                    else if ( col > anchor + 5 && col < anchor + 11) ryu_data = `white;
                    else if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;
                end
                else if (row > 25 && row < 27) begin
                    if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;
                    else if ( col > anchor + 4 && col < anchor + 12) ryu_data = `white;
                    else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;
                end
                else if (row > 26 && row < 28) begin
                    if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;
                    else if ( col > anchor + 4 && col < anchor + 8) ryu_data = `white;
                    else if ( col > anchor + 7 && col < anchor + 9) ryu_data = `black;
                    else if ( col > anchor + 8 && col < anchor + 10) ryu_data = `white;
                    else if ( col > anchor + 9 && col < anchor + 11) ryu_data = `black;
                    else if ( col > anchor + 10 && col < anchor + 12) ryu_data = `white;
                    else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;
                end
                else if (row > 27 && row < 29) begin
                    if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;
                    else if ( col > anchor + 4 && col < anchor + 8) ryu_data = `white;
                    else if ( col > anchor + 7 && col < anchor + 9) ryu_data = `black;
                    else if ( col > anchor + 8 && col < anchor + 10) ryu_data = `white;
                    else if ( col > anchor + 9 && col < anchor + 11) ryu_data = `black;
                    else if ( col > anchor + 10 && col < anchor + 12) ryu_data = `white;
                    else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;
                end
                else if (row > 28 && row < 30) begin
                    if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;
                    else if ( col > anchor + 4 && col < anchor + 8) ryu_data = `white;
                    else if ( col > anchor + 7 && col < anchor + 9) ryu_data = `black;
                    else if ( col > anchor + 8 && col < anchor + 10) ryu_data = `white;
                    else if ( col > anchor + 9 && col < anchor + 11) ryu_data = `black;
                    else if ( col > anchor + 10 && col < anchor + 12) ryu_data = `white;
                    else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;
                end
                else if (row > 29 && row < 31) begin
                    if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;
                    else if ( col > anchor + 4 && col < anchor + 12) ryu_data = `white;
                    else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;
                end
                else if (row > 30 && row < 32) begin
                    if ( col > anchor + 2 && col < anchor + 6) ryu_data = `black;
                    else if ( col > anchor + 5 && col < anchor + 11) ryu_data = `white;
                    else if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;
                end
                else if (row > 31 && row < 33) begin
                    if ( col > anchor + 3 && col < anchor + 7) ryu_data = `black;
                    else if ( col > anchor + 6 && col < anchor + 10) ryu_data = `white;
                    else if ( col > anchor + 9 && col < anchor + 13) ryu_data = `black;
                end
                else if (row > 32 && row < 34) begin
                    if ( col > anchor + 4 && col < anchor + 12) ryu_data = `black;
                end
                //head end, middle start
                else if ( col > anchor + 5 && col < anchor + 11 && row > 33 && row < 35) ryu_data = `black;
                else if ( col > anchor + 5 && col < anchor + 11 && row > 34 && row < 36) ryu_data = `black;
                else if ( col > anchor + 5 && col < anchor + 11 && row > 35 && row < 37) ryu_data = `black;
                else if ( col > anchor + 5 && col < anchor + 11 && row > 36 && row < 38) ryu_data = `black;
                else if ( col > anchor + 4 && col < anchor + 12 && row > 37 && row < 39) ryu_data = `black;
                else if ( col > anchor + 3 && col < anchor + 13 && row > 38 && row < 40) ryu_data = `black;
                else if ( col > anchor + 2 && col < anchor + 14 && row > 39 && row < 41) ryu_data = `black;
                else if (row > 40 && row < 42) begin
                    if ( col > anchor + 1 && col < anchor + 6) ryu_data = `black;
                    else if ( col > anchor + 6 && col < anchor + 10) ryu_data = `black;
                    else if ( col > anchor + 10 && col < anchor + 15) ryu_data = `black;
                end
                else if (row > 41 && row < 43) begin
                    if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;
                    else if ( col > anchor + 6 && col < anchor + 10) ryu_data = `black;
                    else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;
                end
                else if (row > 42 && row < 44) begin
                    if ( col > anchor + 1 && col < anchor + 6) ryu_data = `black;
                    else if ( col > anchor + 6 && col < anchor + 10) ryu_data = `black;
                    else if ( col > anchor + 10 && col < anchor + 15) ryu_data = `black;
                end
                else if (row > 43 && row < 45) begin
                    if ( col > anchor + 1 && col < anchor + 6) ryu_data = `black;
                    else if ( col > anchor + 6 && col < anchor + 10) ryu_data = `black;
                    else if ( col > anchor + 10 && col < anchor + 15) ryu_data = `black;
                end
                //middle end, lower start
                else if ( col > anchor + 6 && col < anchor + 10 && row > 44 && row < 46) ryu_data = `black;
                else if ( col > anchor + 6 && col < anchor + 10 && row > 45 && row < 47) ryu_data = `black;
                else if ( col > anchor + 5 && col < anchor + 11 && row > 46 && row < 48) ryu_data = `black;
                else if ( col > anchor + 4 && col < anchor + 12 && row > 47 && row < 49) ryu_data = `black;
                else if (row > 48 && row < 50) begin
                    if ( col > anchor + 4 && col < anchor + 7) ryu_data = `black;
                    else if ( col > anchor + 9 && col < anchor + 12) ryu_data = `black;
                end
                else if (row > 49 && row < 51) begin
                    if ( col > anchor + 4 && col < anchor + 7) ryu_data = `black;
                    else if ( col > anchor + 9 && col < anchor + 12) ryu_data = `black;
                end
                else if (row > 50 && row < 52) begin
                    if ( col > anchor + 3 && col < anchor + 6) ryu_data = `black;
                    else if ( col > anchor + 10 && col < anchor + 13) ryu_data = `black;
                end
                else if (row > 51 && row < 53) begin
                    if ( col > anchor + 3 && col < anchor + 6) ryu_data = `black;
                    else if ( col > anchor + 10 && col < anchor + 13) ryu_data = `black;
                end
                else if (row > 52 && row < 54) begin
                    if ( col > anchor + 3 && col < anchor + 6) ryu_data = `black;
                    else if ( col > anchor + 10 && col < anchor + 13) ryu_data = `black;
                end
                else if (row > 53 && row < 55) begin
                    if ( col > anchor + 3 && col < anchor + 6) ryu_data = `black;
                    else if ( col > anchor + 10 && col < anchor + 13) ryu_data = `black;
                end
                else if (row > 54 && row < 56) begin
                    if ( col > anchor + 3 && col < anchor + 6) ryu_data = `black;
                    else if ( col > anchor + 10 && col < anchor + 13) ryu_data = `black;
                end
                else if (row > 55 && row < 57) begin
                    if ( col > anchor + 3 && col < anchor + 6) ryu_data = `black;
                    else if ( col > anchor + 10 && col < anchor + 13) ryu_data = `black;
                end
                else if (row > 56 && row < 58) begin
                    if ( col > anchor + 3 && col < anchor + 6) ryu_data = `black;
                    else if ( col > anchor + 10 && col < anchor + 13) ryu_data = `black;
                end
                else if (row > 57 && row < 59) begin
                    if ( col > anchor + 3 && col < anchor + 6) ryu_data = `black;
                    else if ( col > anchor + 10 && col < anchor + 13) ryu_data = `black;
                end
                //lower end     
                    
                main_nextstate = (fd_trigger == 1) ? f1 : (bd_trigger == 1) ? b1 : (hk_trigger == 1) ? h1 : (right_splat == 1) ? w1 : stand;
                end
                f1: begin
                    //FRAME 1 OF FORWARD
                    //head start
                    if ( col > anchor + 5 && col < anchor + 11 && row > 21 && row < 23) ryu_data = `black;
                    else if ( col > anchor + 4 && col < anchor + 12 && row >  22 && row < 24) ryu_data = `black;
                    else if (row > 23 && row < 25) begin
                        if ( col > anchor + 3 && col < anchor + 7) ryu_data = `black;
                        else if ( col > anchor + 6 && col < anchor + 10) ryu_data = `white;
                        else if ( col > anchor + 9 && col < anchor + 13) ryu_data = `black;
                    end
                    else if (row > 24 && row < 26) begin
                        if ( col > anchor + 2 && col < anchor + 6) ryu_data = `black;
                        else if ( col > anchor + 5 && col < anchor + 11) ryu_data = `white;
                        else if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;
                    end
                    else if (row > 25 && row < 27) begin
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;
                        else if ( col > anchor + 4 && col < anchor + 12) ryu_data = `white;
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;
                    end
                    else if (row > 26 && row < 28) begin
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;
                        else if ( col > anchor + 4 && col < anchor + 8) ryu_data = `white;
                        else if ( col > anchor + 7 && col < anchor + 9) ryu_data = `black;
                        else if ( col > anchor + 8 && col < anchor + 10) ryu_data = `white;
                        else if ( col > anchor + 9 && col < anchor + 11) ryu_data = `black;
                        else if ( col > anchor + 10 && col < anchor + 12) ryu_data = `white;
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;
                    end
                    else if (row > 27 && row < 29) begin
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;
                        else if ( col > anchor + 4 && col < anchor + 8) ryu_data = `white;
                        else if ( col > anchor + 7 && col < anchor + 9) ryu_data = `black;
                        else if ( col > anchor + 8 && col < anchor + 10) ryu_data = `white;
                        else if ( col > anchor + 9 && col < anchor + 11) ryu_data = `black;
                        else if ( col > anchor + 10 && col < anchor + 12) ryu_data = `white;
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;
                    end
                    else if (row > 28 && row < 30) begin
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;
                        else if ( col > anchor + 4 && col < anchor + 8) ryu_data = `white;
                        else if ( col > anchor + 7 && col < anchor + 9) ryu_data = `black;
                        else if ( col > anchor + 8 && col < anchor + 10) ryu_data = `white;
                        else if ( col > anchor + 9 && col < anchor + 11) ryu_data = `black;
                        else if ( col > anchor + 10 && col < anchor + 12) ryu_data = `white;
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;
                    end
                    else if (row > 29 && row < 31) begin
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;
                        else if ( col > anchor + 4 && col < anchor + 12) ryu_data = `white;
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;
                    end
                    else if (row > 30 && row < 32) begin
                        if ( col > anchor + 2 && col < anchor + 6) ryu_data = `black;
                        else if ( col > anchor + 5 && col < anchor + 11) ryu_data = `white;
                        else if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;
                    end
                    else if (row > 31 && row < 33) begin
                        if ( col > anchor + 3 && col < anchor + 7) ryu_data = `black;
                        else if ( col > anchor + 6 && col < anchor + 10) ryu_data = `white;
                        else if ( col > anchor + 9 && col < anchor + 13) ryu_data = `black;
                    end
                    else if (row > 32 && row < 34) begin
                        if ( col > anchor + 4 && col < anchor + 12) ryu_data = `black;
                    end
                    //head end, middle start   
                    else if ( col > anchor + 4 && col < anchor + 11 && row > 33 && row < 35) ryu_data = `black;
                    else if ( col > anchor + 2 && col < anchor + 11 && row > 34 && row < 36) ryu_data = `black;
                    else if (row > 35 && row < 37) begin
                        if ( col > anchor + 2 && col < anchor + 11) ryu_data = `black;
                        else if ( col > anchor + 13 && col < anchor + 16) ryu_data = `black;
                    end
                    else if (row > 36 && row < 38) begin
                        if ( col > anchor + 1 && col < anchor + 4) ryu_data = `black;
                        else if ( col > anchor + 6 && col < anchor + 10) ryu_data = `black;
                        else if ( col > anchor + 10 && col < anchor + 16) ryu_data = `black;
                    end
                    else if (row > 37 && row < 39) begin
                        if ( col > anchor + 0 && col < anchor + 4) ryu_data = `black;
                        else if ( col > anchor + 6 && col < anchor + 10) ryu_data = `black;
                        else if ( col > anchor + 10 && col < anchor + 15) ryu_data = `black;
                    end
                    else if (row > 38 && row < 40) begin
                        if ( col > anchor + 0 && col < anchor + 3) ryu_data = `black;
                        else if ( col > anchor + 6 && col < anchor + 10) ryu_data = `black;
                    end
                    else if ( col > anchor + 6 && col < anchor + 10 && row > 39 && row < 41) ryu_data = `black;
                    else if ( col > anchor + 6 && col < anchor + 10 && row > 40 && row < 42) ryu_data = `black;
                    else if ( col > anchor + 6 && col < anchor + 11 && row > 41 && row < 43) ryu_data = `black;
                    else if ( col > anchor + 5 && col < anchor + 13 && row > 42 && row < 44) ryu_data = `black;
                    else if (row > 43 && row < 45) begin
                        if ( col > anchor + 5 && col < anchor + 8) ryu_data = `black;
                        else if ( col > anchor + 9 && col < anchor + 14) ryu_data = `black;
                    end
                    //middle end, lower start
                    else if (row > 44 && row < 46) begin                                    
                        if ( col > anchor + 5 && col < anchor + 8) ryu_data = `black;      
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;
                    end                                                                     
                    else if (row > 45 && row < 47) begin                                    
                        if ( col > anchor + 4 && col < anchor + 7) ryu_data = `black;      
                        else if ( col > anchor + 12 && col < anchor + 15) ryu_data = `black;
                    end                                                                     
                    else if (row > 46 && row < 48) begin                                    
                        if ( col > anchor + 4 && col < anchor + 7) ryu_data = `black;      
                        else if ( col > anchor + 13 && col < anchor + 15) ryu_data = `black;
                    end                                                                     
                    else if (row > 47 && row < 49) begin                                    
                        if ( col > anchor + 4 && col < anchor + 7) ryu_data = `black;      
                        else if ( col > anchor + 14 && col < anchor + 16) ryu_data = `black;
                    end                                                                     
                    else if (row > 48 && row < 50) begin                                    
                        if ( col > anchor + 3 && col < anchor + 7) ryu_data = `black;      
                        else if ( col > anchor + 14 && col < anchor + 16) ryu_data = `black;
                    end                                                                     
                    else if (row > 49 && row < 51) begin                                    
                        if ( col > anchor + 3 && col < anchor + 6) ryu_data = `black;      
                        else if ( col > anchor + 15 && col < anchor + 18) ryu_data = `black;
                    end                                                                     
                    else if (row > 50 && row < 52) begin                                    
                        if ( col > anchor + 3 && col < anchor + 6) ryu_data = `black;      
                        else if ( col > anchor + 15 && col < anchor + 19) ryu_data = `black;
                    end                                                                     
                    else if (row > 51 && row < 53) begin                                    
                        if ( col > anchor + 2 && col < anchor + 6) ryu_data = `black;      
                        else if ( col > anchor + 16 && col < anchor + 19) ryu_data = `black;
                    end                                                                     
                    else if (row > 52 && row < 54) begin                                    
                        if ( col > anchor + 2 && col < anchor + 5) ryu_data = `black;      
                        else if ( col > anchor + 16 && col < anchor + 19) ryu_data = `black;
                    end                                                                     
                    else if (row > 53 && row < 55) begin                                    
                        if ( col > anchor + 2 && col < anchor + 5) ryu_data = `black;      
                        else if ( col > anchor + 16 && col < anchor + 19) ryu_data = `black;
                    end
                    else if (row > 54 && row < 56) begin                                     
                        if ( col > anchor + 2 && col < anchor + 5) ryu_data = `black;       
                        else if ( col > anchor + 16 && col < anchor + 19) ryu_data = `black;
                    end                                                                                                                                         
                    //lower end                             
                    main_nextstate = (count_frame == frame_count) ? f2 : f1;
                end
                f2: begin
                    //FRAME 2 OF FORWARD
                    //head start                                                                                         
                    if ( col > anchor + 5 && col < anchor + 11 && row > 24 && row < 26) ryu_data = `black;              
                    else if ( col > anchor + 4 && col < anchor + 12 && row >  25 && row < 27) ryu_data = `black;        
                    else if (row > 26 && row < 28) begin                                                                 
                        if ( col > anchor + 3 && col < anchor + 7) ryu_data = `black;                                   
                        else if ( col > anchor + 6 && col < anchor + 10) ryu_data = `white;                             
                        else if ( col > anchor + 9 && col < anchor + 13) ryu_data = `black;                             
                    end                                                                                                  
                    else if (row > 27 && row < 29) begin                                                                 
                        if ( col > anchor + 2 && col < anchor + 6) ryu_data = `black;                                   
                        else if ( col > anchor + 5 && col < anchor + 11) ryu_data = `white;                             
                        else if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;                            
                    end                                                                                                  
                    else if (row > 28 && row < 30) begin                                                                 
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                   
                        else if ( col > anchor + 4 && col < anchor + 12) ryu_data = `white;                             
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                            
                    end                                                                                                  
                    else if (row > 29 && row < 31) begin                                                                 
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                   
                        else if ( col > anchor + 4 && col < anchor + 8) ryu_data = `white;                              
                        else if ( col > anchor + 7 && col < anchor + 9) ryu_data = `black;                              
                        else if ( col > anchor + 8 && col < anchor + 10) ryu_data = `white;                             
                        else if ( col > anchor + 9 && col < anchor + 11) ryu_data = `black;                             
                        else if ( col > anchor + 10 && col < anchor + 12) ryu_data = `white;                            
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                            
                    end                                                                                                  
                    else if (row > 30 && row < 32) begin                                                                 
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                   
                        else if ( col > anchor + 4 && col < anchor + 8) ryu_data = `white;                              
                        else if ( col > anchor + 7 && col < anchor + 9) ryu_data = `black;                              
                        else if ( col > anchor + 8 && col < anchor + 10) ryu_data = `white;                             
                        else if ( col > anchor + 9 && col < anchor + 11) ryu_data = `black;                             
                        else if ( col > anchor + 10 && col < anchor + 12) ryu_data = `white;                            
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                            
                    end                                                                                                  
                    else if (row > 31 && row < 33) begin                                                                 
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                   
                        else if ( col > anchor + 4 && col < anchor + 8) ryu_data = `white;                              
                        else if ( col > anchor + 7 && col < anchor + 9) ryu_data = `black;                              
                        else if ( col > anchor + 8 && col < anchor + 10) ryu_data = `white;                             
                        else if ( col > anchor + 9 && col < anchor + 11) ryu_data = `black;                             
                        else if ( col > anchor + 10 && col < anchor + 12) ryu_data = `white;                            
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                            
                    end                                                                                                  
                    else if (row > 32 && row < 34) begin                                                                 
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                   
                        else if ( col > anchor + 4 && col < anchor + 12) ryu_data = `white;                             
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                            
                    end                                                                                                  
                    else if (row > 33 && row < 35) begin                                                                 
                        if ( col > anchor + 2 && col < anchor + 6) ryu_data = `black;                                   
                        else if ( col > anchor + 5 && col < anchor + 11) ryu_data = `white;                             
                        else if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;                            
                    end                                                                                                  
                    else if (row > 34 && row < 36) begin                                                                 
                        if ( col > anchor + 3 && col < anchor + 7) ryu_data = `black;                                   
                        else if ( col > anchor + 6 && col < anchor + 10) ryu_data = `white;                             
                        else if ( col > anchor + 9 && col < anchor + 13) ryu_data = `black;                             
                    end                                                                                                  
                    else if (row > 35 && row < 37) begin                                                                 
                        if ( col > anchor + 4 && col < anchor + 12) ryu_data = `black;                                  
                    end                                                                                                  
                    //head end, middle start                                                                             
                    else if ( col > anchor + 4 && col < anchor + 11 && row > 36 && row < 38) ryu_data = `black;         
                    else if ( col > anchor + 2 && col < anchor + 11 && row > 37 && row < 39) ryu_data = `black;         
                    else if (row > 38 && row < 40) begin                                                                 
                        if ( col > anchor + 2 && col < anchor + 12) ryu_data = `black;                                                             
                    end                                                                                                  
                    else if (row > 39 && row < 41) begin                                                                 
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                   
                        else if ( col > anchor + 5 && col < anchor + 13) ryu_data = `black;                                                        
                    end                                                                                                  
                    else if (row > 40 && row < 42) begin                                                                 
                        if ( col > anchor + 1 && col < anchor + 4) ryu_data = `black;                                   
                        else if ( col > anchor + 5 && col < anchor + 14) ryu_data = `black;                                                        
                    end                                                                                                  
                    else if (row > 41 && row < 43) begin                                                                 
                        if ( col > anchor + 1 && col < anchor + 4) ryu_data = `black;                                   
                        else if ( col > anchor + 5 && col < anchor + 9) ryu_data = `black;  
                        else if ( col > anchor + 10 && col < anchor + 16) ryu_data = `black;                           
                    end
                    else if (row > 42 && row < 44) begin                                                                 
                        if ( col > anchor + 1 && col < anchor + 4) ryu_data = `black;                                   
                        else if ( col > anchor + 5 && col < anchor + 9) ryu_data = `black;  
                        else if ( col > anchor + 11 && col < anchor + 16) ryu_data = `black;                           
                    end     
                    else if (row > 43 && row < 45) begin                                                                 
                        if ( col > anchor + 1 && col < anchor + 4) ryu_data = `black;                                   
                        else if ( col > anchor + 5 && col < anchor + 9) ryu_data = `black;  
                        else if ( col > anchor + 12 && col < anchor + 16) ryu_data = `black;                           
                    end                                                                                                                                                                                                                                              
                    else if ( col > anchor + 5 && col < anchor + 11 && row > 44 && row < 46) ryu_data = `black;         
                    else if ( col > anchor + 5 && col < anchor + 12 && row > 45 && row < 47) ryu_data = `black;         
                    else if (row > 46 && row < 48) begin                                                                 
                        if ( col > anchor + 5 && col < anchor + 8) ryu_data = `black;                                   
                        else if ( col > anchor + 8 && col < anchor + 12) ryu_data = `black;                             
                    end                                                                                                  
                    //middle end, lower start                                                                            
                    else if (row > 47 && row < 49) begin                                                                 
                        if ( col > anchor + 5 && col < anchor + 8) ryu_data = `black;                                   
                        else if ( col > anchor + 8 && col < anchor + 13) ryu_data = `black;                            
                    end                                                                                                  
                    else if (row > 48 && row < 50) begin                                                                 
                        if ( col > anchor + 4 && col < anchor + 8) ryu_data = `black;                                   
                        else if ( col > anchor + 8 && col < anchor + 14) ryu_data = `black;                            
                    end                                                                                                  
                    else if (row > 49 && row < 51) begin                                                                 
                        if ( col > anchor + 4 && col < anchor + 8) ryu_data = `black;                                   
                        else if ( col > anchor + 9 && col < anchor + 14) ryu_data = `black;                            
                    end                                                                                                  
                    else if (row > 50 && row < 52) begin                                                                 
                        if ( col > anchor + 3 && col < anchor + 7) ryu_data = `black;                                   
                        else if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;                            
                    end                                                                                                  
                    else if (row > 51 && row < 53) begin                                                                 
                        if ( col > anchor + 3 && col < anchor + 7) ryu_data = `black;                                   
                        else if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;                            
                    end                                                                                                  
                    else if (row > 52 && row < 54) begin                                                                 
                        if ( col > anchor + 3 && col < anchor + 7) ryu_data = `black;                                   
                        else if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;                            
                    end                                                                                                  
                    else if (row > 53 && row < 55) begin                                                                 
                        if ( col > anchor + 3 && col < anchor + 7) ryu_data = `black;                                   
                        else if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;                            
                    end                                                                                                  
                    else if (row > 54 && row < 56) begin                                                                 
                        if ( col > anchor + 3 && col < anchor + 7) ryu_data = `black;                                   
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                            
                    end                                                                                                  
                    else if (row > 55 && row < 57) begin                                                                 
                        if ( col > anchor + 2 && col < anchor + 6) ryu_data = `black;                                   
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                            
                    end                                                                                                  
                    else if (row > 56 && row < 58) begin                                                                 
                        if ( col > anchor + 2 && col < anchor + 6) ryu_data = `black;                                   
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                            
                    end                                                                                                  
                    else if (row > 57 && row < 59) begin                                                                 
                        if ( col > anchor + 2 && col < anchor + 6) ryu_data = `black;                                   
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                            
                    end                                                                                                  
                    //lower end                                                                                          
                    main_nextstate = (count_frame == frame_count) ? stand : f2;    
                end
                b1: begin
                    //FRAME 1 OF BACKWARD
                    //head start                                                                                      
                    if ( col > anchor + 5 && col < anchor + 11 && row > 24 && row < 26) ryu_data = `black;           
                    else if ( col > anchor + 4 && col < anchor + 12 && row >  25 && row < 27) ryu_data = `black;     
                    else if (row > 26 && row < 28) begin                                                              
                        if ( col > anchor + 3 && col < anchor + 7) ryu_data = `black;                                
                        else if ( col > anchor + 6 && col < anchor + 10) ryu_data = `white;                          
                        else if ( col > anchor + 9 && col < anchor + 13) ryu_data = `black;                          
                    end                                                                                               
                    else if (row > 27 && row < 29) begin                                                              
                        if ( col > anchor + 2 && col < anchor + 6) ryu_data = `black;                                
                        else if ( col > anchor + 5 && col < anchor + 11) ryu_data = `white;                          
                        else if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 28 && row < 30) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                
                        else if ( col > anchor + 4 && col < anchor + 12) ryu_data = `white;                          
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 29 && row < 31) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                
                        else if ( col > anchor + 4 && col < anchor + 6) ryu_data = `white;                           
                        else if ( col > anchor + 5 && col < anchor + 7) ryu_data = `black;                           
                        else if ( col > anchor + 6 && col < anchor + 8) ryu_data = `white;                          
                        else if ( col > anchor + 7 && col < anchor + 9) ryu_data = `black;                          
                        else if ( col > anchor + 8 && col < anchor + 12) ryu_data = `white;                         
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 30 && row < 32) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                
                        else if ( col > anchor + 4 && col < anchor + 6) ryu_data = `white; 
                        else if ( col > anchor + 5 && col < anchor + 7) ryu_data = `black; 
                        else if ( col > anchor + 6 && col < anchor + 8) ryu_data = `white; 
                        else if ( col > anchor + 7 && col < anchor + 9) ryu_data = `black; 
                        else if ( col > anchor + 8 && col < anchor + 12) ryu_data = `white;                         
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 31 && row < 33) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                
                        else if ( col > anchor + 4 && col < anchor + 6) ryu_data = `white; 
                        else if ( col > anchor + 5 && col < anchor + 7) ryu_data = `black; 
                        else if ( col > anchor + 6 && col < anchor + 8) ryu_data = `white; 
                        else if ( col > anchor + 7 && col < anchor + 9) ryu_data = `black; 
                        else if ( col > anchor + 8 && col < anchor + 12) ryu_data = `white;                         
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 32 && row < 34) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                
                        else if ( col > anchor + 4 && col < anchor + 12) ryu_data = `white;                          
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 33 && row < 35) begin                                                              
                        if ( col > anchor + 2 && col < anchor + 6) ryu_data = `black;                                
                        else if ( col > anchor + 5 && col < anchor + 11) ryu_data = `white;                          
                        else if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 34 && row < 36) begin                                                              
                        if ( col > anchor + 3 && col < anchor + 7) ryu_data = `black;                                
                        else if ( col > anchor + 6 && col < anchor + 10) ryu_data = `white;                          
                        else if ( col > anchor + 9 && col < anchor + 13) ryu_data = `black;                          
                    end                                                                                               
                    else if (row > 35 && row < 37) begin                                                              
                        if ( col > anchor + 4 && col < anchor + 12) ryu_data = `black;                               
                    end                                                                                               
                    //head end, middle start                                                                          
                    else if ( col > anchor + 4 && col < anchor + 11 && row > 36 && row < 38) ryu_data = `black;      
                    else if ( col > anchor + 4 && col < anchor + 11 && row > 37 && row < 39) ryu_data = `black;      
                    else if (row > 38 && row < 40) begin                                                              
                        if ( col > anchor + 2 && col < anchor + 9) ryu_data = `black;                               
                    end                                                                                               
                    else if (row > 39 && row < 41) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 10) ryu_data = `black;                                                      
                    end                                                                                               
                    else if (row > 40 && row < 42) begin                                                              
                        if ( col > anchor && col < anchor + 5) ryu_data = `black;                                
                        else if ( col > anchor + 5 && col < anchor + 9) ryu_data = `black;  
                        else if ( col > anchor + 9 && col < anchor + 12) ryu_data = `black;                        
                    end                                                                                               
                    else if (row > 41 && row < 43) begin                                                              
                        if ( col > anchor && col < anchor + 4) ryu_data = `black;                                
                        else if ( col > anchor + 5 && col < anchor + 9) ryu_data = `black;                           
                        else if ( col > anchor + 9 && col < anchor + 13) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 42 && row < 44) begin                                                              
                        if ( col > anchor && col < anchor + 3) ryu_data = `black;                                
                        else if ( col > anchor + 5 && col < anchor + 9) ryu_data = `black;                           
                        else if ( col > anchor + 10 && col < anchor + 13) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 43 && row < 45) begin                                                              
                        if ( col > anchor && col < anchor + 3) ryu_data = `black;                                
                        else if ( col > anchor + 5 && col < anchor + 9) ryu_data = `black;                           
                        else if ( col > anchor + 10 && col < anchor + 13) ryu_data = `black;                         
                    end
                    else if (row > 44 && row < 46) begin                                                              
                        if ( col > anchor && col < anchor + 3) ryu_data = `black;                                
                        else if ( col > anchor + 5 && col < anchor + 9) ryu_data = `black;                                                
                    end                                                                                                          
                    else if ( col > anchor + 4 && col < anchor + 10 && row > 45 && row < 47) ryu_data = `black;      
                    else if (row > 46 && row < 48) begin                                                              
                        if ( col > anchor + 3 && col < anchor + 10) ryu_data = `black;                                                  
                    end                                                                                               
                    //middle end, lower start                                                                         
                    else if (row > 47 && row < 49) begin                                                              
                        if ( col > anchor + 3 && col < anchor + 11) ryu_data = `black;                                                         
                    end                                                                                               
                    else if (row > 48 && row < 50) begin                                                              
                        if ( col > anchor + 3 && col < anchor + 6) ryu_data = `black;                                
                        else if ( col > anchor + 7 && col < anchor + 12) ryu_data = `black;                          
                    end                                                                                               
                    else if (row > 49 && row < 51) begin                                                              
                        if ( col > anchor + 3 && col < anchor + 6) ryu_data = `black;                                
                        else if ( col > anchor + 8 && col < anchor + 12) ryu_data = `black;                          
                    end                                                                                              
                    else if (row > 50 && row < 52) begin                                                              
                        if ( col > anchor + 3 && col < anchor + 6) ryu_data = `black;                                
                        else if ( col > anchor + 9 && col < anchor + 13) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 51 && row < 53) begin                                                              
                        if ( col > anchor + 4 && col < anchor + 7) ryu_data = `black;                                
                        else if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 52 && row < 54) begin                                                              
                        if ( col > anchor + 4 && col < anchor + 7) ryu_data = `black;                                
                        else if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 53 && row < 55) begin                                                              
                        if ( col > anchor + 3 && col < anchor + 7) ryu_data = `black;                                
                        else if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 54 && row < 56) begin                                                              
                        if ( col > anchor + 2 && col < anchor + 6) ryu_data = `black;                                
                        else if ( col > anchor + 11 && col < anchor + 14) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 55 && row < 57) begin                                                              
                        if ( col > anchor + 2 && col < anchor + 6) ryu_data = `black;                                
                        else if ( col > anchor + 11 && col < anchor + 14) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 56 && row < 58) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                
                        else if ( col > anchor + 11 && col < anchor + 14) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 57 && row < 59) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                
                        else if ( col > anchor + 11 && col < anchor + 14) ryu_data = `black;                         
                    end   
                    //lower end                                                                                            
                    main_nextstate = (count_frame == frame_count) ? stand : b1;
                end
                h1: begin
                    //charging
                    if ( col > anchor + 10 && col < anchor + 13 && row > 21 && row < 23) ryu_data = `bandana;
                    else if (row > 22 && row < 24) begin                                                              
                        if ( col > anchor + 10 && col < anchor + 12) ryu_data = `bandana;                                                          
                        else if ( col > anchor + 13 && col < anchor + 17) ryu_data = `bandana;                          
                    end 
                    else if (row > 23 && row < 25) begin                                                              
                        if ( col > anchor + 5 && col < anchor + 11) ryu_data = `black;                                                          
                        else if ( col > anchor + 10 && col < anchor + 12) ryu_data = `bandana;  
                        else if ( col > anchor + 12 && col < anchor + 15) ryu_data = `bandana;                        
                    end           
                    else if (row > 24 && row < 26) begin                                                              
                        if ( col > anchor + 4 && col < anchor + 12) ryu_data = `black;                                                          
                        else if ( col > anchor + 11 && col < anchor + 14) ryu_data = `bandana;                         
                    end 
                    else if ( col > anchor + 3 && col < anchor + 13 && row >  25 && row < 27) ryu_data = `bandana;     
                    else if (row > 26 && row < 28) begin                                                              
                        if ( col > anchor + 2 && col < anchor + 6) ryu_data = `black;                                
                        else if ( col > anchor + 5 && col < anchor + 11) ryu_data = `white;                          
                        else if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;                          
                    end                                                                                               
                    else if (row > 27 && row < 29) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                
                        else if ( col > anchor + 4 && col < anchor + 12) ryu_data = `white;                          
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 28 && row < 30) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                
                        else if ( col > anchor + 4 && col < anchor + 6) ryu_data = `white;
                        else if ( col > anchor + 5 && col < anchor + 7) ryu_data = `black; 
                        else if ( col > anchor + 6 && col < anchor + 10) ryu_data = `white;
                        else if ( col > anchor + 9 && col < anchor + 11) ryu_data = `black;
                        else if ( col > anchor + 10 && col < anchor + 12) ryu_data = `white;                         
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 29 && row < 31) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                
                        else if ( col > anchor + 4 && col < anchor + 7) ryu_data = `white;                           
                        else if ( col > anchor + 6 && col < anchor + 8) ryu_data = `black;                           
                        else if ( col > anchor + 7 && col < anchor + 9) ryu_data = `white;                          
                        else if ( col > anchor + 8 && col < anchor + 10) ryu_data = `black;                          
                        else if ( col > anchor + 9 && col < anchor + 12) ryu_data = `white;                         
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 30 && row < 32) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                
                        else if ( col > anchor + 4 && col < anchor + 12) ryu_data = `white;                         
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 31 && row < 33) begin                                                              
                        if ( col > anchor + 2 && col < anchor + 6) ryu_data = `black;                                
                        else if ( col > anchor + 5 && col < anchor + 8) ryu_data = `white; 
                        else if ( col > anchor + 7 && col < anchor + 9) ryu_data = `black; 
                        else if ( col > anchor + 8 && col < anchor + 11) ryu_data = `white;                        
                        else if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 32 && row < 34) begin                                                              
                        if ( col > anchor + 3 && col < anchor + 7) ryu_data = `black;
                        else if ( col > anchor + 6 && col < anchor + 10) ryu_data = `white;                        
                        else if ( col > anchor + 9 && col < anchor + 13) ryu_data = `black;                                                        
                    end                                                                                               
                    else if (row > 33 && row < 35) begin                                                              
                        if ( col > anchor + 4 && col < anchor + 12) ryu_data = `black;                                                        
                    end                                                                                               
                    else if (row > 34 && row < 36) begin                                                              
                        if ( col > anchor + 5 && col < anchor + 11) ryu_data = `black;                                                         
                    end                                                                                               
                    else if (row > 35 && row < 37) begin                                                              
                        if ( col > anchor + 5 && col < anchor + 11) ryu_data = `black;                               
                    end                                                                                               
                    //head end, middle start                                                                          
                    else if ( col > anchor + 5 && col < anchor + 11 && row > 36 && row < 38) ryu_data = `black;      
                    else if ( col > anchor + 4 && col < anchor + 12 && row > 37 && row < 39) ryu_data = `black;      
                    else if (row > 38 && row < 40) begin                                                              
                        if ( col > anchor + 3 && col < anchor + 13) ryu_data = `black;                               
                    end                                                                                               
                    else if (row > 39 && row < 41) begin                                                              
                        if ( col > anchor + 2 && col < anchor + 14) ryu_data = `black;                                                      
                    end                                                                                               
                    else if (row > 40 && row < 42) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 6) ryu_data = `black;                                
                        else if ( col > anchor + 6 && col < anchor + 8) ryu_data = `black;  
                        else if ( col > anchor + 7 && col < anchor + 9) ryu_data = `orange;  
                        else if ( col > anchor + 9 && col < anchor + 10) ryu_data = `black;
                        else if ( col > anchor + 10 && col < anchor + 15) ryu_data = `black;                        
                    end                                                                                               
                    else if (row > 41 && row < 43) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                
                        else if ( col > anchor + 6 && col < anchor + 10) ryu_data = `orange;                           
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 42 && row < 44) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                
                        else if ( col > anchor + 5 && col < anchor + 8) ryu_data = `orange;  
                        else if ( col > anchor + 7 && col < anchor + 9) ryu_data = `yellow;                          
                        else if ( col > anchor + 8 && col < anchor + 11) ryu_data = `orange;   
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                       
                    end                                                                                               
                    else if (row > 43 && row < 45) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 6 ) ryu_data = `black;                                
                        else if ( col > anchor + 5 && col < anchor + 7) ryu_data = `orange;                           
                        else if ( col > anchor + 6 && col < anchor + 10) ryu_data = `yellow;  
                        else if ( col > anchor + 9 && col < anchor + 11) ryu_data = `orange;  
                        else if ( col > anchor + 10 && col < anchor + 15) ryu_data = `black;                       
                    end
                    else if (row > 44 && row < 46) begin                                                              
                        if ( col > anchor + 2 && col < anchor + 6) ryu_data = `black;                                
                        else if ( col > anchor + 5 && col < anchor + 7) ryu_data = `orange;    
                        else if ( col > anchor + 6 && col < anchor + 8) ryu_data = `yellow;           
                        else if ( col > anchor + 7 && col < anchor + 9) ryu_data = `beige;
                        else if ( col > anchor + 8 && col < anchor + 10) ryu_data = `yellow; 
                        else if ( col > anchor + 9 && col < anchor + 11) ryu_data = `orange;   
                        else if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;                                  
                    end 
                    else if (row > 45 && row < 47) begin                                                              
                        if ( col > anchor + 3 && col < anchor + 6) ryu_data = `black;                                
                        else if ( col > anchor + 5 && col < anchor + 7) ryu_data = `orange;    
                        else if ( col > anchor + 6 && col < anchor + 8) ryu_data = `yellow;           
                        else if ( col > anchor + 7 && col < anchor + 9) ryu_data = `beige;
                        else if ( col > anchor + 8 && col < anchor + 10) ryu_data = `yellow; 
                        else if ( col > anchor + 9 && col < anchor + 11) ryu_data = `orange;   
                        else if ( col > anchor + 10 && col < anchor + 13) ryu_data = `black;                                  
                    end                                                                                                               
                    else if (row > 46 && row < 48) begin                                                              
                        if ( col > anchor + 5 && col < anchor + 7) ryu_data = `orange; 
                        else if ( col > anchor + 6 && col < anchor + 8) ryu_data = `yellow; 
                        else if ( col > anchor + 7 && col < anchor + 9) ryu_data = `beige;  
                        else if ( col > anchor + 8 && col < anchor + 10) ryu_data = `yellow;
                        else if ( col > anchor + 9 && col < anchor + 11) ryu_data = `orange;                                                  
                    end                                                                                               
                    //middle end, lower start                                                                         
                    else if (row > 47 && row < 49) begin
                        if ( col > anchor + 5 && col < anchor + 8) ryu_data = `orange; 
                        else if ( col > anchor + 7 && col < anchor + 9) ryu_data = `yellow; 
                        else if ( col > anchor + 8 && col < anchor + 11) ryu_data = `orange;                                                        
                    end                                                                                               
                    else if (row > 48 && row < 50) begin                                                              
                        if ( col > anchor + 4 && col < anchor + 7) ryu_data = `black;                                
                        else if ( col > anchor + 6 && col < anchor + 10) ryu_data = `orange; 
                        if ( col > anchor + 9 && col < anchor + 12) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 49 && row < 51) begin                                                              
                        if ( col > anchor + 3 && col < anchor + 8) ryu_data = `black;                                
                        else if ( col > anchor + 7 && col < anchor + 9) ryu_data = `orange;  
                        if ( col > anchor + 8 && col < anchor + 13) ryu_data = `black;                        
                    end                                                                                              
                    else if (row > 50 && row < 52) begin                                                              
                        if ( col > anchor + 2 && col < anchor + 7) ryu_data = `black;                                
                        else if ( col > anchor + 9 && col < anchor + 14) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 51 && row < 53) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 6) ryu_data = `black;                                
                        else if ( col > anchor + 10 && col < anchor + 15) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 52 && row < 54) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 53 && row < 55) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 54 && row < 56) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 55 && row < 57) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 56 && row < 58) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 57 && row < 59) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                
                        else if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;                         
                    end   
                    //lower end
                    
                    
                    main_nextstate = (count_frame == charge_count) ? h2 : h1;
                end
                h2: begin
                    //release
                    if ( col > anchor + 4 && col < anchor + 7 && row > 21 && row < 23) ryu_data = `bandana;
                    else if (row > 22 && row < 24) begin                                                              
                        if ( col > anchor + 5 && col < anchor + 9) ryu_data = `bandana;                                                                                  
                    end 
                    else if (row > 23 && row < 25) begin                                                              
                        if ( col > anchor + 7 && col < anchor + 11) ryu_data = `bandana;                                                          
                        else if ( col > anchor + 13 && col < anchor + 19) ryu_data = `black;                         
                    end           
                    else if (row > 24 && row < 26) begin                                                              
                        if ( col > anchor + 12 && col < anchor + 20) ryu_data = `black;                                                          
                        else if ( col > anchor + 9 && col < anchor + 13) ryu_data = `bandana;                         
                    end 
                    else if ( col > anchor + 8 && col < anchor + 21 && row >  25 && row < 27) ryu_data = `bandana;     
                    else if (row > 26 && row < 28) begin                                                              
                        if ( col > anchor + 6 && col < anchor + 10) ryu_data = `bandana;                                
                        else if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;                          
                        else if ( col > anchor + 18 && col < anchor + 22) ryu_data = `black;
                        else if ( col > anchor + 13 && col < anchor + 19) ryu_data = `white;                          
                    end                                                                                               
                    else if (row > 27 && row < 29) begin                                                              
                        if ( col > anchor + 4 && col < anchor + 8) ryu_data = `bandana;                                
                        else if ( col > anchor + 9 && col < anchor + 13) ryu_data = `black;                          
                        else if ( col > anchor + 12 && col < anchor + 16) ryu_data = `white;  
                        else if ( col > anchor + 15 && col < anchor + 17) ryu_data = `black;   
                        else if ( col > anchor + 16 && col < anchor + 20) ryu_data = `white;  
                        else if ( col > anchor + 19 && col < anchor + 23) ryu_data = `black;                  
                    end                                                                                               
                    else if (row > 28 && row < 30) begin                                                              
                        if ( col > anchor + 2 && col < anchor + 6) ryu_data = `bandana;                                
                        else if ( col > anchor + 9 && col < anchor + 13) ryu_data = `black;                          
                        else if ( col > anchor + 12 && col < anchor + 17) ryu_data = `white;  
                        else if ( col > anchor + 16 && col < anchor + 18) ryu_data = `black;   
                        else if ( col > anchor + 17 && col < anchor + 20) ryu_data = `white;  
                        else if ( col > anchor + 19 && col < anchor + 23) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 29 && row < 31) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 4) ryu_data = `bandana;                                
                        else if ( col > anchor + 9 && col < anchor + 13) ryu_data = `black;                          
                        else if ( col > anchor + 12 && col < anchor + 20) ryu_data = `white;      
                        else if ( col > anchor + 19 && col < anchor + 23) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 30 && row < 32) begin                                                              
                        if ( col > anchor + 9 && col < anchor + 13) ryu_data = `black;                                
                        else if ( col > anchor + 12 && col < anchor + 17) ryu_data = `white;                         
                        else if ( col > anchor + 16 && col < anchor + 23) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 31 && row < 33) begin                                                              
                        if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;                                
                        else if ( col > anchor + 13 && col < anchor + 19) ryu_data = `white; 
                        else if ( col > anchor + 18 && col < anchor + 22) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 32 && row < 34) begin                                                              
                        if ( col > anchor + 11 && col < anchor + 15) ryu_data = `black;
                        else if ( col > anchor + 14 && col < anchor + 18) ryu_data = `white;                        
                        else if ( col > anchor + 17 && col < anchor + 21) ryu_data = `black;                                                        
                    end                                                                                               
                    else if (row > 33 && row < 35) begin                                                              
                        if ( col > anchor + 12 && col < anchor + 20) ryu_data = `black;                                                        
                    end                                                                                               
                    else if (row > 34 && row < 36) begin                                                              
                        if ( col > anchor + 13 && col < anchor + 19) ryu_data = `black;
                        else if ( col > anchor + 28 && col < anchor + 30) ryu_data = `black;                                                         
                    end                                                                                               
                    else if (row > 35 && row < 37) begin                                                              
                        if ( col > anchor + 13 && col < anchor + 19) ryu_data = `black;
                        else if ( col > anchor + 27 && col < anchor + 30) ryu_data = `black;                                
                    end                                                                                               
                    //head end, middle start 
                    else if (row > 36 && row < 38) begin                                                              
                        if ( col > anchor + 13 && col < anchor + 19) ryu_data = `black;
                        else if ( col > anchor + 19 && col < anchor + 30) ryu_data = `black;                                
                    end 
                    else if (row > 37 && row < 39) begin                                                              
                        if ( col > anchor + 13 && col < anchor + 30) ryu_data = `black;                               
                    end
                    else if (row > 38 && row < 40) begin                                                              
                        if ( col > anchor + 13 && col < anchor + 22) ryu_data = `black;                               
                    end                                                                                          
                    else if (row > 39 && row < 41) begin                                                              
                        if ( col > anchor + 13 && col < anchor + 30) ryu_data = `black;                                                      
                    end                                                                                               
                    else if (row > 40 && row < 42) begin                                                              
                        if ( col > anchor + 13 && col < anchor + 30) ryu_data = `black;                                                     
                    end                                                                                               
                    else if (row > 41 && row < 43) begin                                                              
                        if ( col > anchor + 13 && col < anchor + 18) ryu_data = `black;                                
                        else if ( col > anchor + 27 && col < anchor + 30) ryu_data = `black;                                                   
                    end                                                                                               
                    else if (row > 42 && row < 44) begin                                                              
                        if ( col > anchor + 13 && col < anchor + 18) ryu_data = `black;                                
                        else if ( col > anchor + 28 && col < anchor + 30) ryu_data = `black;                       
                    end                                                                                               
                    else if (row > 43 && row < 45) begin                                                              
                        if ( col > anchor + 13 && col < anchor + 18 ) ryu_data = `black;                                                       
                    end
                    else if (row > 44 && row < 46) begin                                                              
                        if ( col > anchor + 12 && col < anchor + 18) ryu_data = `black;                                                               
                    end 
                    else if (row > 45 && row < 47) begin                                                              
                        if ( col > anchor + 12 && col < anchor + 18) ryu_data = `black;                                                                  
                    end                                                                                                               
                    else if (row > 46 && row < 48) begin                                                              
                        if ( col > anchor + 11 && col < anchor + 19) ryu_data = `black;                                                 
                    end                                                                                               
                    //middle end, lower start                                                                         
                    else if (row > 47 && row < 49) begin
                        if ( col > anchor + 11 && col < anchor + 20) ryu_data = `black;                                                      
                    end                                                                                               
                    else if (row > 48 && row < 50) begin                                                              
                        if ( col > anchor + 10 && col < anchor + 15) ryu_data = `black;                                
                        if ( col > anchor + 15 && col < anchor + 21) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 49 && row < 51) begin                                                              
                        if ( col > anchor + 10 && col < anchor + 15) ryu_data = `black;                                 
                        if ( col > anchor + 16 && col < anchor + 21) ryu_data = `black;                        
                    end                                                                                              
                    else if (row > 50 && row < 52) begin                                                              
                        if ( col > anchor + 9 && col < anchor + 14) ryu_data = `black;                                
                        else if ( col > anchor + 16 && col < anchor + 22) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 51 && row < 53) begin                                                              
                        if ( col > anchor + 7 && col < anchor + 13) ryu_data = `black;                                
                        else if ( col > anchor + 17 && col < anchor + 23) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 52 && row < 54) begin                                                              
                        if ( col > anchor + 5 && col < anchor + 13) ryu_data = `black;                                
                        else if ( col > anchor + 18 && col < anchor + 23) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 53 && row < 55) begin                                                              
                        if ( col > anchor + 3 && col < anchor + 12) ryu_data = `black;                                
                        else if ( col > anchor + 18 && col < anchor + 23) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 54 && row < 56) begin                                                              
                        if ( col > anchor + 2 && col < anchor + 10) ryu_data = `black;                                
                        else if ( col > anchor + 17 && col < anchor + 23) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 55 && row < 57) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 8) ryu_data = `black;                                
                        else if ( col > anchor + 16 && col < anchor + 22) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 56 && row < 58) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 6) ryu_data = `black;                                
                        else if ( col > anchor + 15 && col < anchor + 21) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 57 && row < 59) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                
                        else if ( col > anchor + 15 && col < anchor + 21) ryu_data = `black;                         
                    end   
                    //lower end
                    main_nextstate = (shot_frame == shot_count) ? h3 : h2;
                end
                h3: begin
                    //tired
                    if (row > 23 && row < 25) begin                                                              
                        if ( col > anchor + 8 && col < anchor + 14) ryu_data = `black;                                                                            
                    end     
                    else if (row > 24 && row < 26) begin                                                              
                        if ( col > anchor + 7 && col < anchor + 15) ryu_data = `black;                                                                                 
                    end
                    else if (row >  25 && row < 27) begin                                                              
                        if ( col > anchor + 6 && col < anchor + 10) ryu_data = `black;   
                        else if ( col > anchor + 9 && col < anchor + 13) ryu_data = `white; 
                        else if ( col > anchor + 12 && col < anchor + 16) ryu_data = `black;                                                                             
                    end      
                    else if (row > 26 && row < 28) begin                                                              
                        if ( col > anchor + 5 && col < anchor + 9) ryu_data = `black;                                
                        else if ( col > anchor + 8 && col < anchor + 14) ryu_data = `white;                          
                        else if ( col > anchor + 13 && col < anchor + 17) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 27 && row < 29) begin                                                                                             
                        if ( col > anchor + 4 && col < anchor + 8) ryu_data = `black;                          
                        else if ( col > anchor + 7 && col < anchor + 11) ryu_data = `white;  
                        else if ( col > anchor + 10 && col < anchor + 12) ryu_data = `black;   
                        else if ( col > anchor + 11 && col < anchor + 13) ryu_data = `white;  
                        else if ( col > anchor + 12 && col < anchor + 14) ryu_data = `black; 
                        else if ( col > anchor + 13 && col < anchor + 15) ryu_data = `white;  
                        else if ( col > anchor + 14 && col < anchor + 18) ryu_data = `black;               
                    end                                                                                               
                    else if (row > 28 && row < 30) begin                                                              
                        if ( col > anchor + 4 && col < anchor + 8) ryu_data = `black;                          
                        else if ( col > anchor + 7 && col < anchor + 10) ryu_data = `white;  
                        else if ( col > anchor + 9 && col < anchor + 11) ryu_data = `black;   
                        else if ( col > anchor + 10 && col < anchor + 15) ryu_data = `white;  
                        else if ( col > anchor + 14 && col < anchor + 18) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 29 && row < 31) begin                                                              
                        if ( col > anchor + 4 && col < anchor + 8) ryu_data = `black;                             
                        else if ( col > anchor + 7 && col < anchor + 15) ryu_data = `white;  
                        else if ( col > anchor + 14 && col < anchor + 18) ryu_data = `black;                          
                    end                                                                                               
                    else if (row > 30 && row < 32) begin                                                              
                        if ( col > anchor + 4 && col < anchor + 8) ryu_data = `black;                             
                        else if ( col > anchor + 7 && col < anchor + 11) ryu_data = `white;  
                        else if ( col > anchor + 10 && col < anchor + 13) ryu_data = `black;
                        else if ( col > anchor + 12 && col < anchor + 15) ryu_data = `white;
                        else if ( col > anchor + 14 && col < anchor + 18) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 31 && row < 33) begin                                                              
                        if ( col > anchor + 5 && col < anchor + 9) ryu_data = `black;                                
                        else if ( col > anchor + 8 && col < anchor + 14) ryu_data = `white;                          
                        else if ( col > anchor + 13 && col < anchor + 17) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 32 && row < 34) begin                                                              
                        if ( col > anchor + 6 && col < anchor + 10) ryu_data = `black;   
                        else if ( col > anchor + 9 && col < anchor + 13) ryu_data = `white; 
                        else if ( col > anchor + 12 && col < anchor + 16) ryu_data = `black;                                                        
                    end                                                                                               
                    else if (row > 33 && row < 35) begin                                                              
                        if ( col > anchor + 7 && col < anchor + 15) ryu_data = `black;                                                        
                    end                                                                                               
                    else if (row > 34 && row < 36) begin                                                              
                        if ( col > anchor + 6 && col < anchor + 14) ryu_data = `black;                                                       
                    end                                                                                               
                    else if (row > 35 && row < 37) begin                                                              
                        if ( col > anchor + 5 && col < anchor + 14) ryu_data = `black;                               
                    end                                                                                               
                    //head end, middle start 
                    else if (row > 36 && row < 38) begin                                                              
                        if ( col > anchor + 5 && col < anchor + 14) ryu_data = `black;                                
                    end 
                    else if (row > 37 && row < 39) begin                                                              
                        if ( col > anchor + 5 && col < anchor + 14) ryu_data = `black;                               
                    end
                    else if (row > 38 && row < 40) begin                                                              
                        if ( col > anchor + 4 && col < anchor + 11) ryu_data = `black;
                        else if ( col > anchor + 11 && col < anchor + 14) ryu_data = `black;                               
                    end                                                                                          
                    else if (row > 39 && row < 41) begin                                                              
                        if ( col > anchor + 4 && col < anchor + 11) ryu_data = `black;
                        else if ( col > anchor + 11 && col < anchor + 14) ryu_data = `black;                                                      
                    end                                                                                               
                    else if (row > 40 && row < 42) begin                                                              
                        if ( col > anchor + 4 && col < anchor + 11) ryu_data = `black;
                        else if ( col > anchor + 11 && col < anchor + 14) ryu_data = `black;                                                     
                    end                                                                                               
                    else if (row > 41 && row < 43) begin                                                              
                        if ( col > anchor + 4 && col < anchor + 11) ryu_data = `black;
                        else if ( col > anchor + 11 && col < anchor + 14) ryu_data = `black;                                                   
                    end                                                                                               
                    else if (row > 42 && row < 44) begin                                                              
                        if ( col > anchor + 4 && col < anchor + 11) ryu_data = `black;
                        else if ( col > anchor + 11 && col < anchor + 14) ryu_data = `black;                       
                    end                                                                                               
                    else if (row > 43 && row < 45) begin                                                              
                        if ( col > anchor + 4 && col < anchor + 11) ryu_data = `black;
                        else if ( col > anchor + 11 && col < anchor + 14) ryu_data = `black;                                                       
                    end
                    else if (row > 44 && row < 46) begin                                                              
                        if ( col > anchor + 5 && col < anchor + 12) ryu_data = `black;                                                               
                    end 
                    else if (row > 45 && row < 47) begin                                                              
                        if ( col > anchor + 5 && col < anchor + 13) ryu_data = `black;                                                                  
                    end                                                                                                               
                    else if (row > 46 && row < 48) begin                                                              
                        if ( col > anchor + 5 && col < anchor + 14) ryu_data = `black;                                                 
                    end                                                                                               
                    //middle end, lower start                                                                         
                    else if (row > 47 && row < 49) begin
                        if ( col > anchor + 6 && col < anchor + 14) ryu_data = `black;                                                      
                    end                                                                                               
                    else if (row > 48 && row < 50) begin                                                              
                        if ( col > anchor + 6 && col < anchor + 14) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 49 && row < 51) begin                                                              
                        if ( col > anchor + 6 && col < anchor + 10) ryu_data = `black;                                 
                        else if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;                        
                    end                                                                                              
                    else if (row > 50 && row < 52) begin                                                              
                        if ( col > anchor + 6 && col < anchor + 10) ryu_data = `black;                                 
                        else if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 51 && row < 53) begin                                                              
                        if ( col > anchor + 6 && col < anchor + 10) ryu_data = `black;                                 
                        else if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 52 && row < 54) begin                                                              
                        if ( col > anchor + 5 && col < anchor + 10) ryu_data = `black;                                 
                        else if ( col > anchor + 10 && col < anchor + 14) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 53 && row < 55) begin                                                              
                        if ( col > anchor + 4 && col < anchor + 9) ryu_data = `black;                                
                        else if ( col > anchor + 9 && col < anchor + 13) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 54 && row < 56) begin                                                              
                        if ( col > anchor + 4 && col < anchor + 8) ryu_data = `black;                                
                        else if ( col > anchor + 9 && col < anchor + 13) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 55 && row < 57) begin                                                              
                        if ( col > anchor + 3 && col < anchor + 7) ryu_data = `black;                                
                        else if ( col > anchor + 8 && col < anchor + 12) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 56 && row < 58) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 6) ryu_data = `black;                                
                        else if ( col > anchor + 8 && col < anchor + 12) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 57 && row < 59) begin                                                              
                        if ( col > anchor + 1 && col < anchor + 5) ryu_data = `black;                                
                        else if ( col > anchor + 7 && col < anchor + 11) ryu_data = `black;                         
                    end   
                    //lower end
                    main_nextstate = (tired == tired_t) ? stand : h3;
                    end
                w1: begin
                    //right splat
                    if (row >  25 && row < 27) begin                                                              
                        if ( col >   89 && col <   95) ryu_data = `black;                                                                                
                    end      
                    else if (row > 26 && row < 28) begin                                                              
                        if ( col >   88 && col <   96) ryu_data = `black;                                                       
                    end                                                                                               
                    else if (row > 27 && row < 29) begin                                                                                             
                        if ( col >   87 && col <   91) ryu_data = `black;                          
                        else if ( col >   90 && col <   94) ryu_data = `white;  
                        else if ( col >   93 && col <   96) ryu_data = `black;                 
                    end                                                                                               
                    else if (row > 28 && row < 30) begin                                                              
                        if ( col >   86 && col <   90) ryu_data = `black;                          
                        else if ( col >   89 && col <   95) ryu_data = `white;  
                        else if ( col >   94 && col <   96) ryu_data = `black;                          
                    end                                                                                               
                    else if (row > 29 && row < 31) begin                                                              
                        if ( col >   85 && col <   89) ryu_data = `black;                             
                        else if ( col >   88 && col <   90) ryu_data = `white;  
                        else if ( col >   89 && col <   91) ryu_data = `black;  
                        else if ( col >   90 && col <   92) ryu_data = `white; 
                        else if ( col >   91 && col <   93) ryu_data = `black;  
                        else if ( col >   92 && col <   96) ryu_data = `white;                      
                    end                                                                                               
                    else if (row > 30 && row < 32) begin                                                              
                        if ( col >   85 && col <   89) ryu_data = `black;                             
                        else if ( col >   88 && col <   90) ryu_data = `white;  
                        else if ( col >   89 && col <   91) ryu_data = `black;  
                        else if ( col >   90 && col <   92) ryu_data = `white; 
                        else if ( col >   91 && col <   93) ryu_data = `black;  
                        else if ( col >   92 && col <   96) ryu_data = `white;                         
                    end                                                                                               
                    else if (row > 31 && row < 33) begin                                                              
                        if ( col >   85 && col <   89) ryu_data = `black;                             
                        else if ( col >   88 && col <   93) ryu_data = `white;  
                        else if ( col >   92 && col <   94) ryu_data = `black;   
                        else if ( col >   93 && col <   96) ryu_data = `white;                         
                    end                                                                                               
                    else if (row > 32 && row < 34) begin                                                              
                        if ( col >   85 && col <   89) ryu_data = `black;                             
                        else if ( col >   88 && col <   91) ryu_data = `white;  
                        else if ( col >   90 && col <   92) ryu_data = `black;   
                        else if ( col >   91 && col <   96) ryu_data = `white;                                                        
                    end                                                                                               
                    else if (row > 33 && row < 35) begin                                                              
                        if ( col >   86 && col <   90) ryu_data = `black;                          
                        else if ( col >   89 && col <   95) ryu_data = `white;  
                        else if ( col >   94 && col <   96) ryu_data = `black;                                                        
                    end                                                                                               
                    else if (row > 34 && row < 36) begin                                                              
                        if ( col >   87 && col <   91) ryu_data = `black;                          
                        else if ( col >   90 && col <   94) ryu_data = `white;  
                        else if ( col >   93 && col <   96) ryu_data = `black;                                                       
                    end                                                                                               
                    else if (row > 35 && row < 37) begin                                                              
                        if ( col >   88 && col <   96) ryu_data = `black;                              
                    end                                                                                               
                    //head end, middle start 
                    else if (row > 36 && row < 38) begin                                                              
                        if ( col >   89 && col <   96) ryu_data = `black;                                
                    end 
                    else if (row > 37 && row < 39) begin                                                              
                        if ( col >   87 && col <   96) ryu_data = `black;                               
                    end
                    else if (row > 38 && row < 40) begin                                                              
                        if ( col >   81 && col <   96) ryu_data = `black;                              
                    end                                                                                          
                    else if (row > 39 && row < 41) begin                                                              
                        if ( col >   81 && col <   89) ryu_data = `black;
                        else if ( col >   91 && col <   96) ryu_data = `black;                                                      
                    end                                                                                               
                    else if (row > 40 && row < 42) begin                                                              
                        if ( col >   90 && col <   96) ryu_data = `black;                                                    
                    end                                                                                               
                    else if (row > 41 && row < 43) begin                                                              
                        if ( col >   85 && col <   93) ryu_data = `black;
                        else if ( col >   93 && col <   96) ryu_data = `black;                                                   
                    end                                                                                               
                    else if (row > 42 && row < 44) begin                                                              
                        if ( col >   85 && col <   92) ryu_data = `black;
                        else if ( col >   93 && col <   96) ryu_data = `black;                       
                    end                                                                                               
                    else if (row > 43 && row < 45) begin                                                              
                        if ( col >   93 && col <   96) ryu_data = `black;                                                      
                    end
                    else if (row > 44 && row < 46) begin                                                              
                        if ( col >   93 && col <   96) ryu_data = `black;                                                               
                    end 
                    else if (row > 45 && row < 47) begin                                                              
                        if ( col >   92 && col <   96) ryu_data = `black;                                                                  
                    end                                                                                                               
                    else if (row > 46 && row < 48) begin                                                              
                        if ( col >   92 && col <   96) ryu_data = `black;                                                 
                    end                                                                                               
                    //middle end, lower start                                                                         
                    else if (row > 47 && row < 49) begin
                        if ( col >   91 && col <   96) ryu_data = `black;                                                      
                    end                                                                                               
                    else if (row > 48 && row < 50) begin                                                              
                        if ( col >   91 && col <   96) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 49 && row < 51) begin                                                              
                        if ( col >   90 && col <   96) ryu_data = `black;                                                       
                    end                                                                                              
                    else if (row > 50 && row < 52) begin                                                              
                        if ( col >   90 && col <   93) ryu_data = `black;                                 
                        else if ( col >   93 && col <   96) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 51 && row < 53) begin                                                              
                        if ( col >   89 && col <   92) ryu_data = `black;                                 
                        else if ( col >   92 && col <   96) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 52 && row < 54) begin                                                              
                        if ( col >   88 && col <   92) ryu_data = `black;                                 
                        else if ( col >   92 && col <   95) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 53 && row < 55) begin                                                              
                        if ( col >   87 && col <   91) ryu_data = `black;                                
                        else if ( col >   91 && col <   95) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 54 && row < 56) begin                                                              
                        if ( col >   86 && col <   90) ryu_data = `black;                                
                        else if ( col >   91 && col <   94) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 55 && row < 57) begin                                                              
                        if ( col >   85 && col <   89) ryu_data = `black;                                
                        else if ( col >   90 && col <   94) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 56 && row < 58) begin                                                              
                        if ( col >   85 && col <   89) ryu_data = `black;                                
                        else if ( col >   89 && col <   93) ryu_data = `black;                         
                    end                                                                                               
                    else if (row > 57 && row < 59) begin                                                              
                        if ( col >   89 && col <   93) ryu_data = `black;                                                        
                    end   
                    //lower end
                    
                    main_nextstate = (count_frame == charge_count) ? stand : w1;
                end
            endcase
        end
    end
    


endmodule
