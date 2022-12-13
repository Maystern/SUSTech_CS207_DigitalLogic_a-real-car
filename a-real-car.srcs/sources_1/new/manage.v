`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/14 01:41:25
// Design Name: 
// Module Name: manage
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


module manage(sys_clk, stop_engine, start_engine, reverse, brake, clutch, throttle, reverse_signal, engine_power_signal, brake_signal, clutch_signal, throttle_signal, manual_not_starting, manual_starting, manual_moving);
input sys_clk;
input stop_engine;
input start_engine;
input reverse;
input brake;
input clutch;
input throttle;
output reverse_signal;
output reg engine_power_signal;
output brake_signal;
output clutch_signal;
output throttle_signal;
output reg manual_not_starting;
output reg manual_starting;
output reg manual_moving;

parameter poweron = 3'b000, poweroff = 3'b001;
parameter not_starting = 3'b010, starting = 3'b011, moving = 3'b100;
reg[2: 0] state = poweroff, next_state = poweroff;
reg [31: 0] cnt = 32'b0;
reg time_up = 1'b0;
reg flag_stop_engine = 1'b0;
parameter period = 32'd100000000;

always @(posedge sys_clk) begin
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
end

always @(posedge sys_clk) begin
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
    state <= next_state;
end


reverseDetect reverse_detect(sys_clk, reverse, engine_power_signal, reverse_signal);
brakeDetect brake_detect(sys_clk, brake, engine_power_signal, brake_signal);
clutchDetect clutch_detect(sys_clk, clutch, engine_power_signal, clutch_signal);
throttleDetect throttle_detect(sys_clk, throttle, engine_power_signal, throttle_signal);


always @(posedge sys_clk) begin
    case (state)
        poweron:begin
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
            if(throttle_signal && clutch_signal && !brake_signal) next_state <= starting;
            else if(throttle_signal && !clutch_signal) next_state <= poweroff;
            else next_state <= state;
        end
        starting: begin
            if(brake_signal) next_state <= not_starting;
            else if(throttle_signal && !brake_signal && !clutch_signal) next_state <= moving;
            else next_state <= state;
        end
        moving: begin
            if(brake_signal) next_state <= not_starting;
            else if(!throttle_signal) next_state <= starting;
            else if(clutch_signal) next_state <= starting;
            else if(reverse_signal && !clutch_signal) next_state <= poweroff;
            else next_state <= state;
        end
        default next_state <= poweroff;
    endcase
        if (time_up == 1'b0) next_state <= poweroff;
end
endmodule
