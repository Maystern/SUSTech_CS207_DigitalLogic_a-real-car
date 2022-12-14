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
//    input move_forward_signal,
//    input move_backward_signal,
    input place_barrier_signal,
    input destroy_barrier_signal,
    output front_detector,
    output back_detector,
    output left_detector,
    output right_detector,
    input stop_engine_signal,
    input start_engine_signal,
    input reverse_signal,
    input clutch_signal,
    input brake_signal,
    input throttle_signal,
    output engine_power,
    output manual_not_starting,
    output manual_starting,
    output manual_moving,
    output turn_left,
    output turn_right,
    output [7: 0] seg1,
    output [7: 0] seg0,
    output [7: 0] seg_en
    );
    
//    wire [7:0] in = {2'b10, destroy_barrier_signal, place_barrier_signal, turn_right_signal, turn_left_signal, move_backward_signal, move_forward_signal};
    reg [7:0] in;
    wire [7:0] rec;
    assign front_detector = rec[0];
    assign back_detector = rec[1];
    assign left_detector = rec[2];
    assign right_detector = rec[3];
    always @(posedge sys_clk) begin
        in <= {2'b10, destroy_barrier_signal, place_barrier_signal, turn_right_signal && (manual_starting || manual_moving), turn_left_signal && (manual_starting || manual_moving), reverse_signal && manual_moving, ~reverse_signal && manual_moving};
    end
    uart_top md(.clk(sys_clk), .rst(0), .data_in(in), .data_rec(rec), .rxd(rx), .txd(tx));
    manual_top manual_device(sys_clk, stop_engine_signal, start_engine_signal, reverse_signal,clutch_signal,brake_signal,throttle_signal, turn_left_signal,turn_right_signal,engine_power, manual_not_starting, manual_starting, manual_moving, turn_left, turn_right, seg1, seg0, seg_en);
endmodule
