`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/14 12:42:34
// Design Name: 
// Module Name: manual_top
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


module manual_top (
    input enable,
    input sys_clk,
    input stop_engine,
    input start_engine,
    input reverse,
    input clutch,
    input brake,
    input throttle,
    input turn_left_signal,
    input turn_right_signal,
    output reg engine_power_signal,
    output reg manual_not_starting,
    output reg manual_starting,
    output reg manual_moving,
    output reg turn_left,
    output reg turn_right,
    output [7:0] seg1,
    output [7:0] seg0,
    output [7:0] seg_en,
    input total_engine_power,
    output [31:0] mileage,
    output reg [2:0] state
);
  parameter poweron = 3'b000, poweroff = 3'b001;
  parameter not_starting = 3'b010, starting = 3'b011, moving = 3'b100;
  reg [2:0] next_state = poweroff;
  reg [31:0] cnt = 32'b0;
  reg time_up = 1'b0;
  reg flag_stop_engine = 1'b0;
  parameter period = 32'd100000000;
  wire rst;
  assign rst = ~stop_engine;
  odometer om (
      sys_clk,
      (state == poweroff) || (enable == 1'b0),
      (state == moving) && (enable == 1'b1),
      seg1,
      seg0,
      seg_en,
      mileage
  );
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
        time_up <= 1'b1;
        cnt <= 32'd0;
      end else begin
        time_up <= 1'b0;
        cnt <= 32'd0;
      end
    end
  end
  always @(posedge sys_clk) begin
    if (enable == 1'b1) begin
      if (state == poweroff) begin
        engine_power_signal <= 1'b0;
        manual_not_starting <= 1'b0;
        manual_starting <= 1'b0;
        manual_moving <= 1'b0;
      end else begin
        engine_power_signal <= 1'b1;
        if (state == not_starting) begin
          manual_not_starting <= 1'b1;
          manual_starting <= 1'b0;
          manual_moving <= 1'b0;
        end else if (state == starting) begin
          manual_not_starting <= 1'b0;
          manual_starting <= 1'b1;
          manual_moving <= 1'b0;
        end else if (state == moving) begin
          manual_not_starting <= 1'b0;
          manual_starting <= 1'b0;
          manual_moving <= 1'b1;
        end
      end
    end
  end
  reg reverse_shutdown = 1'b0;
  reg last_reverse = 1'b0;
  reg [31:0] res = 32'b0;
  always @(posedge sys_clk) begin
    if (enable == 1'b1) begin
      if (res == 32'd2000000) begin
        res <= 32'b0;
        if (reverse == last_reverse) reverse_shutdown = 1'b0;
        else reverse_shutdown = 1'b1;
        last_reverse <= reverse;
      end else begin
        res = res + 1;
      end
    end
  end
  always @(posedge sys_clk or negedge rst) begin
    if (!rst) begin
      state <= poweroff;
      next_state <= poweroff;
    end else if (enable == 1'b1) begin
      case (state)
        poweron: begin
          next_state <= not_starting;
          flag_stop_engine <= 1'b0;
        end
        poweroff: begin
          if (start_engine && time_up == 1'b1) next_state <= poweron;
          else begin
            next_state <= poweroff;
            flag_stop_engine <= 1'b1;
          end
        end
        not_starting: begin
          if (throttle && clutch && !brake) next_state <= starting;
          else if (throttle && !clutch && !brake) next_state <= poweroff;
          else next_state <= state;
        end
        starting: begin
          if (brake) next_state <= not_starting;
          else if (throttle && !brake && !clutch) next_state <= moving;
          else next_state <= state;
        end
        moving: begin
          if (brake) next_state <= not_starting;
          else if (!throttle) next_state <= starting;
          else if (clutch) next_state <= starting;
          else if (reverse_shutdown) next_state <= poweroff;
          else next_state <= state;
        end
        default next_state <= poweroff;
      endcase
      if (time_up == 1'b0) next_state <= poweroff;
      state <= next_state;
    end else begin
      if (total_engine_power == 1'b1) begin
        state <= not_starting;
        flag_stop_engine <= 1'b0;
      end else begin
        state <= poweroff;
        flag_stop_engine <= 1'b1;
      end
    end
  end
  reg [31:0] www = 32'd0;
  always @(posedge sys_clk) begin
    if (enable == 1'b1) begin
      www = www + 1;
      if (state == not_starting) begin
        turn_left <= 1'b1;
        turn_right <= 1'b1;
        www <= 32'b0;
      end else if (state == starting || state == moving) begin
        if (www <= 32'd50000000) begin
          if (turn_left_signal && ~turn_right_signal) begin
            turn_left  <= 1'b1;
            turn_right <= 1'b0;
          end else if (turn_right_signal && ~turn_left_signal) begin
            turn_left  <= 1'b0;
            turn_right <= 1'b1;
          end else begin
            turn_left  <= 1'b0;
            turn_right <= 1'b0;
          end
        end else begin
          turn_left  <= 1'b0;
          turn_right <= 1'b0;
        end
      end else begin
        turn_left <= 1'b0;
        turn_right <= 1'b0;
        www <= 32'b0;
      end
      if (www == 32'd100000000) www = 32'd0;
    end else begin
      turn_left  <= 1'b0;
      turn_right <= 1'b0;
    end
  end

endmodule
