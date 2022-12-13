`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/14 01:22:32
// Design Name: 
// Module Name: throttleDetect
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


module clutchDetect(input sys_clk, input clutch, input engine_power_signal, output reg clutch_signal);
    always @(posedge sys_clk)
    begin
        if (engine_power_signal) begin
           clutch_signal <= clutch;
        end else begin
           clutch_signal <= 1'b0;
        end
    end
endmodule
