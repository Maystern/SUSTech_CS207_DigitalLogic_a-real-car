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


module brakeDetect(input sys_clk, input brake, input engine_power_signal, output reg brake_signal);
    always @(posedge sys_clk)
    begin
        if (engine_power_signal) begin
            brake_signal <= brake;
        end else begin
            brake_signal <= 1'b0;
        end
    end
endmodule
