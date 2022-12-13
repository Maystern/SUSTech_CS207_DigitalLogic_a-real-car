`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/12 22:09:29
// Design Name: 
// Module Name: powerDetect
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


module powerDetect(sys_clk, stop_engine, start_engine, led7);
input sys_clk;
input stop_engine;
input start_engine;
output reg led7;
reg [31: 0] cnt = 32'b0;
reg time_up;
parameter period = 32'd100000000;

always @(posedge sys_clk)
begin
    if (time_up) begin
        led7 <= 1'b1;
    end else begin
        led7 <= 1'b0;
    end
end

always @(posedge sys_clk) 
begin
    if (stop_engine) begin
        time_up <= 1'b0;
        cnt <= 32'd0;
    end else if (cnt == period) begin
        cnt <= 32'd0;
        time_up = 1'b1;
    end else if (start_engine) begin
        cnt <= cnt + 1;
    end
end
endmodule
