`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/29 17:10:31
// Design Name: 
// Module Name: auto_top
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


module auto_top(
   input enable,
   input sys_clk,
   input stop_engine,
   input start_engine,
   output reg car_turn_right,
   output reg car_turn_left,
   output reg car_go_forward,
   output reg car_go_back,
   output reg engine_power_signal,
   output reg destroy_barrier_signal,
   output reg place_barrier_signal,
   input front_detector,
   input back_detector,
   input left_detector,
   input right_detector,
   input total_engine_power
);
parameter poweron = 4'b0000, poweroff = 4'b0001, going = 4'b0010;
parameter turning_left = 4'b0011, turning_right = 4'b0100, turning_back = 4'b0101;
parameter place_beacon = 4'b0110, destroy_beacon = 4'b0111;
parameter straight = 4'b1000, place_going = 4'b1001,place_beacon_straight = 4'b1010, left_right_place_beacon = 4'b1011;
reg [3: 0] state = poweroff, next_state = poweroff;
reg [31: 0] cnt = 32'b0;
reg time_up = 1'b0;
reg flag_stop_engine = 1'b0;
parameter period = 32'd100000000;

always @(posedge sys_clk) begin
    if (enable == 1'b1) begin
         if (stop_engine) begin
            cnt <= 32'd0;
            time_up <= 1'b0;
       end else if (cnt == period) begin
           cnt <= 32'd0;
           time_up = 1'b1;
       end else if (start_engine) begin
           cnt <= cnt + 1;
       end else if (flag_stop_engine) begin
           cnt <= 32'd0;
           time_up <= 1'b0;  
       end else begin
           cnt <= 32'd0;
       end
   end else begin
       if (total_engine_power) begin
           time_up <= 1'b1; cnt <= 32'd0;
       end else begin
           time_up <= 1'b0; cnt <= 32'd0; 
       end
   end
end

reg [3: 0] now_detector_state = 4'b0011;
reg [3: 0] tmp_detector_state = 4'b0011;
reg [31: 0] detector_cnt = 32'b0;
parameter detector_time = 32'd8000000;



reg [31: 0] turning_cnt = 32'b0;
parameter turning_left_right_time = 32'd90000000;
parameter turning_back_time = 32'd180000000;

reg [31: 0] straight_cnt = 32'b0;
parameter straight_time = 32'd90000000;

reg [31: 0] place_beacon_straight_cnt = 32'b0;
reg [31: 0] place_beacon_straight_time = 32'd10000000;

reg [31: 0] place_going_cnt = 32'b0;
parameter place_going_time = 32'd80000000;

reg [31: 0] place_beacon_cnt = 32'b0;
parameter place_beacon_time = 32'd3000000;

reg [31: 0] destroy_beacon_cnt = 32'b0;
parameter destroy_beacon_time = 32'd3000000;

reg [31: 0] left_right_place_beacon_cnt = 32'b0;
parameter left_right_place_beacon_time = 32'd3000000;

always @(posedge sys_clk) begin
    if (enable == 1'b1) begin
    case (state)
        poweroff: begin
           engine_power_signal <= 1'b0;
           car_turn_right <= 1'b0; car_turn_left <= 1'b0; car_go_forward <= 1'b0; car_go_back <= 1'b0;
           destroy_barrier_signal <= 1'b0; place_barrier_signal <= 1'b0;
        end
        poweron: begin
            engine_power_signal <= 1'b1;
            car_turn_right <= 1'b0; car_turn_left <= 1'b0; car_go_forward <= 1'b0; car_go_back <= 1'b0;
            destroy_barrier_signal <= 1'b0; place_barrier_signal <= 1'b0;
        end
        going: begin
            engine_power_signal <= 1'b1;
            car_turn_right <= 1'b0; car_turn_left <= 1'b0; car_go_forward <= 1'b1; car_go_back <= 1'b0;
            destroy_barrier_signal <= 1'b0; place_barrier_signal <= 1'b0;
        end
        turning_left: begin
            engine_power_signal <= 1'b1;
            car_turn_right <= 1'b0; car_turn_left <= 1'b1; car_go_forward <= 1'b0; car_go_back <= 1'b0;
            destroy_barrier_signal <= 1'b0; place_barrier_signal <= 1'b0;
        end
        turning_right: begin
            engine_power_signal <= 1'b1;
            car_turn_right <= 1'b1; car_turn_left <= 1'b0; car_go_forward <= 1'b0; car_go_back <= 1'b0;
            destroy_barrier_signal <= 1'b0; place_barrier_signal <= 1'b0;
        end
        turning_back: begin
            engine_power_signal <= 1'b1;
            car_turn_right <= 1'b1; car_turn_left <= 1'b0; car_go_forward <= 1'b0; car_go_back <= 1'b0;
            destroy_barrier_signal <= 1'b0; place_barrier_signal <= 1'b0;
        end
        straight: begin
            engine_power_signal <= 1'b1;
            car_turn_right <= 1'b0; car_turn_left <= 1'b0; car_go_forward <= 1'b1; car_go_back <= 1'b0;
            destroy_barrier_signal <= 1'b0; place_barrier_signal <= 1'b0;
        end
        place_going: begin
            engine_power_signal <= 1'b1;
            car_turn_right <= 1'b0; car_turn_left <= 1'b0; car_go_forward <= 1'b1; car_go_back <= 1'b0;
            destroy_barrier_signal <= 1'b0; place_barrier_signal <= 1'b0;
        end
        place_beacon: begin
            engine_power_signal <= 1'b1;
            car_turn_right <= 1'b0; car_turn_left <= 1'b0; car_go_forward <= 1'b0; car_go_back <= 1'b0;
            destroy_barrier_signal <= 1'b0; place_barrier_signal <= 1'b1;
        end
        place_beacon_straight: begin
            engine_power_signal <= 1'b1;
            car_turn_right <= 1'b0; car_turn_left <= 1'b0; car_go_forward <= 1'b1; car_go_back <= 1'b0;
            destroy_barrier_signal <= 1'b0; place_barrier_signal <= 1'b0;
        end
        destroy_beacon: begin
            engine_power_signal <= 1'b1;
            car_turn_right <= 1'b0; car_turn_left <= 1'b0; car_go_forward <= 1'b0; car_go_back <= 1'b0;
            destroy_barrier_signal <= 1'b1; place_barrier_signal <= 1'b0;    
        end
        left_right_place_beacon: begin
            engine_power_signal <= 1'b1;
            car_turn_right <= 1'b0; car_turn_left <= 1'b0; car_go_forward <= 1'b0; car_go_back <= 1'b0;
            destroy_barrier_signal <= 1'b0; place_barrier_signal <= 1'b1;   
        end
    endcase
    end
end

always @(posedge sys_clk) begin
    if (enable == 1'b1) begin
    case (state)
       poweron:begin
          next_state <= going;
          flag_stop_engine <= 1'b0;
        end
       poweroff: begin
           now_detector_state <= 4'b0011; tmp_detector_state <= 4'b0011;
           detector_cnt <= 32'b0; turning_cnt <= 32'b0;
           if (start_engine && time_up == 1'b1) next_state <= poweron;
           else begin 
                  next_state <= poweroff;
               end
        end
        going: begin
            if ({front_detector, back_detector, left_detector, right_detector} != tmp_detector_state) begin
                tmp_detector_state <= {front_detector, back_detector,left_detector, right_detector};
                detector_cnt <= 32'b0;
            end else begin
                detector_cnt <= detector_cnt + 32'b1;
                if (detector_cnt == detector_time) begin
                    detector_cnt <= 32'b0;
                    now_detector_state <= tmp_detector_state;
                end
            end
            case ({now_detector_state[3], now_detector_state[1], now_detector_state[0]})
                3'b000: next_state <= turning_right;
                3'b001: next_state <= place_going;
                3'b010: next_state <= turning_right;
                3'b011: next_state <= going;
                3'b100: next_state <= left_right_place_beacon;
                3'b101: next_state <= turning_left;
                3'b110: next_state <= turning_right;
                3'b111: next_state <= destroy_beacon;
            endcase 
        end
        turning_left: begin
            turning_cnt <= turning_cnt + 32'b1;
            if (turning_cnt == turning_left_right_time) begin
                turning_cnt <= 32'b0;
                next_state <= straight;
            end
        end
        turning_right: begin
            turning_cnt = turning_cnt + 32'b1;
            if (turning_cnt == turning_left_right_time) begin
                turning_cnt <= 32'b0;
                next_state <= straight;
            end
        end
        turning_back: begin
            turning_cnt = turning_cnt + 32'b1;
            if (turning_cnt == turning_back_time) begin
                turning_cnt <= 32'b0;
                now_detector_state <= {front_detector, back_detector,left_detector, right_detector};
                next_state <= going;
            end 
        end
        straight: begin
            straight_cnt <= straight_cnt + 32'b1;
            if (straight_cnt == straight_time) begin
                straight_cnt <= 32'b0;
                now_detector_state <= {front_detector, back_detector,left_detector, right_detector};
                next_state <= going;
            end
        end
        place_going: begin
            place_going_cnt <= place_going_cnt + 32'b1;
            if (place_going_cnt == place_going_time) begin
                place_going_cnt <= 32'b0;
                next_state <= place_beacon;
            end
        end
        place_beacon: begin
            place_beacon_cnt <= place_beacon_cnt + 32'b1;
            if (place_beacon_cnt == place_beacon_time) begin
                place_beacon_cnt <= 32'b0;
                next_state <= place_beacon_straight;
            end
        end
        place_beacon_straight: begin
            place_beacon_straight_cnt <= place_beacon_straight_cnt + 32'b1;
            if (place_beacon_straight_cnt == place_beacon_straight_time) begin
                place_beacon_straight_cnt <= 32'b0;
                now_detector_state <= {front_detector, back_detector,left_detector, right_detector};
                next_state <= going;
            end
        end
        destroy_beacon: begin
            destroy_beacon_cnt <= destroy_beacon_cnt + 32'b1;
            if (destroy_beacon_cnt == destroy_beacon_time) begin
                destroy_beacon_cnt <= 32'b0;
                next_state <= turning_back;
            end
        end
        left_right_place_beacon: begin
            left_right_place_beacon_cnt <= left_right_place_beacon_cnt + 32'b1;
            if (left_right_place_beacon_cnt == left_right_place_beacon_time) begin
                left_right_place_beacon_cnt <= 32'b0;
                next_state <= turning_right;
            end
        end
    endcase
    if (time_up == 1'b0) next_state <= poweroff;
    state <= next_state;
    end else begin
        if (total_engine_power == 1'b1) begin 
            state <= going;
            flag_stop_engine <= 1'b0;
         end
        else begin 
            state <= poweroff;
            flag_stop_engine <= 1'b1;
        end
    end
end

endmodule
