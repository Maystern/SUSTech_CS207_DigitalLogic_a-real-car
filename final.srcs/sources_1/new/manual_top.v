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


module manual_top(
    input sys_clk,
    input stop_engine,
    input start_engine,
    input reverse,
    input clutch,
    input brake,
    input throttle,
    output reg engine_power_signal,
    output reg manual_not_starting,
    output reg manual_starting,
    output reg manual_moving
);
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

reg reverse_shutdown = 1'b0;
reg last_reverse = 1'b0;
reg [31: 0] res = 32'b0;
always @(posedge sys_clk) begin
    if (res == 32'd2000000) begin
        res <= 32'b0;
        if (reverse == last_reverse) reverse_shutdown = 1'b0;
        else reverse_shutdown = 1'b1;
        last_reverse <= reverse;
    end else begin
        res = res + 1;
    end
end

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
            if(throttle && clutch && !brake) next_state <= starting;
            else if(throttle && !clutch) next_state <= poweroff;
            else next_state <= state;
        end
        starting: begin
            if(brake) next_state <= not_starting;
            else if(throttle && !brake && !clutch) next_state <= moving;
            else next_state <= state;
        end
        moving: begin
            if(brake) next_state <= not_starting;
            else if(!throttle) next_state <= starting;
            else if(clutch) next_state <= starting;
            else if (reverse_shutdown) next_state <= poweroff;
            else next_state <= state;
        end
        default next_state <= poweroff;
    endcase
        if (time_up == 1'b0) next_state <= poweroff;
end

endmodule
