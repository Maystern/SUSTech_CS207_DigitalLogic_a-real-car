`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/26 22:10:40
// Design Name: 
// Module Name: dev_top
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


module SimulatedDevice(
    input sys_clk, //bind to P17 pin (100MHz system clock)
    input rx, //bind to N5 pin
    output tx, //bind to T4 pin
    input turn_left_signal,
    input turn_right_signal, 
    input stop_engine_signal,
    input start_engine_signal,
    input reverse_signal,
    input clutch_signal,
    input brake_signal,
    input throttle_signal,
    output reg engine_power,
    output turn_left,
    output turn_right,
    output [7: 0] seg1,
    output [7: 0] seg0,
    output [7: 0] seg_en,
    input go_straight_signal,
    input reverse_signal_button,
    input enable_manual_signal,
    input enable_semiauto_signal,
    input enable_auto_signal,
    output reg manual_state,
    output reg semiauto_state,
    output reg auto_state, 
    output[3:0] red, 
    output[3:0] green, 
    output[3:0] blue, 
    output hs, 
    output vs  
    );
    wire[31:0] mileage;
    reg [7:0] in;
    wire [3:0] tmp_in1, tmp_in2; 
    wire engine_power1, engine_power2, engine_power3;
    wire [7:0] rec;
    wire place_barrier_signal1, place_barrier_signal2;
    wire destroy_barrier_signal1, destroy_barrier_signal2;
    reg place_barrier_signal, destroy_barrier_signal;
    reg [2: 0] enable = 3'b000;
    reg total_engine_power = 1'b0;
    reg [31: 0] total_engine_power_cnt = 32'b0;
    parameter total_engine_power_time = 32'd100000000; 
    wire manual_not_starting, manual_starting, manual_moving;
    wire[2:0] m_state;
    wire[7:0] state;
    //assign state = {m_state,enable[0], enable[1],engine_power,enable[2]};
    assign state = {enable[2], engine_power, enable[1:0], m_state};
    always @(posedge sys_clk) begin
        case ({enable_manual_signal, enable_semiauto_signal, enable_auto_signal})
               3'b100: begin 
                    engine_power <= engine_power1;
                    place_barrier_signal <= 1'b0; destroy_barrier_signal <= 1'b0;
                    in <= {2'b10, destroy_barrier_signal, place_barrier_signal, (turn_right_signal ^ reverse_signal) && (manual_starting || manual_moving) && ~(turn_left_signal ^ reverse_signal), (turn_left_signal ^ reverse_signal) && (manual_starting || manual_moving) && ~(turn_right_signal ^ reverse_signal), reverse_signal && manual_moving, ~reverse_signal && manual_moving};
                    enable <= 3'b001;
                    if (total_engine_power)
                        {manual_state, semiauto_state, auto_state} <= 3'b100;
                    else 
                        {manual_state, semiauto_state, auto_state} <= 3'b000;
               end
               3'b010: begin 
                    engine_power <= engine_power2;
                    place_barrier_signal <= place_barrier_signal1; destroy_barrier_signal <= destroy_barrier_signal1;
                    in <= {2'b10, destroy_barrier_signal, place_barrier_signal,tmp_in1};
                    enable <= 3'b010; 
                    if (total_engine_power)
                        {manual_state, semiauto_state, auto_state} <= 3'b010;
                    else 
                        {manual_state, semiauto_state, auto_state} <= 3'b000;
               end
               3'b001: begin 
                    engine_power <= engine_power3;
                    place_barrier_signal <= place_barrier_signal2; destroy_barrier_signal <= destroy_barrier_signal2;
                    in <= {2'b10, destroy_barrier_signal, place_barrier_signal,tmp_in2};
                    enable <= 3'b100;
                    if (total_engine_power)
                        {manual_state, semiauto_state, auto_state} <= 3'b001;
                    else 
                        {manual_state, semiauto_state, auto_state} <= 3'b000;
               end
               default: begin 
                    engine_power <= total_engine_power;
                    place_barrier_signal <= 1'b0; destroy_barrier_signal <= 1'b0;
                    in <= 8'b0;
                    enable <= 3'b000;
                    {manual_state, semiauto_state, auto_state} <= 3'b000;
               end
        endcase
    end
    

    
    always @(posedge sys_clk) begin
          case (enable)
            3'b000: begin
                if ((total_engine_power == 1'b0) && (start_engine_signal == 1'b1)) begin
                    total_engine_power_cnt <= total_engine_power_cnt + 32'b1;
                    if (total_engine_power_cnt == total_engine_power_time) begin
                        total_engine_power_cnt <= 32'b0;
                        total_engine_power <= 1'b1;
                    end
                end else if ((total_engine_power == 1'b1) && (stop_engine_signal == 1'b0)) begin
                    total_engine_power_cnt <= 32'b0;
                    total_engine_power <= 1'b0;
                end else begin
                    total_engine_power_cnt <= 32'b0;
                end
            end
            3'b100: begin
                total_engine_power <= engine_power1;
                total_engine_power_cnt <= 32'b0;
            end
            3'b010: begin
                total_engine_power_cnt <= 32'b0;  
            end
            3'b001: begin
                total_engine_power_cnt <= 32'b0;
            end
          endcase
    end
    
    
    uart_top md(.clk(sys_clk), .rst(0), .data_in(in), .data_rec(rec), .rxd(rx), .txd(tx));
    vga_top vga(sys_clk, stop_engine_signal, mileage, state, red, green, blue, hs, vs);
    manual_top manual_device(enable[0], sys_clk, ~stop_engine_signal, start_engine_signal, reverse_signal,clutch_signal,brake_signal,throttle_signal, turn_left_signal,turn_right_signal,engine_power1, manual_not_starting, manual_starting, manual_moving, turn_left, turn_right, seg1, seg0, seg_en, total_engine_power, mileage, m_state);
    semiauto_top semiauto_device(enable[1], sys_clk, ~stop_engine_signal, start_engine_signal,tmp_in1[3], tmp_in1[2], tmp_in1[0], tmp_in1[1], engine_power2, destroy_barrier_signal1, place_barrier_signal1, rec[0] , rec[3], rec[1], rec[2], go_straight_signal, turn_right_signal, turn_left_signal, reverse_signal_button, total_engine_power);
    auto_top auto_device(enable[2], sys_clk, ~stop_engine_signal, start_engine_signal,tmp_in2[3], tmp_in2[2], tmp_in2[0], tmp_in2[1], engine_power3, destroy_barrier_signal2, place_barrier_signal2, rec[0] , rec[3], rec[1], rec[2], total_engine_power);
endmodule
