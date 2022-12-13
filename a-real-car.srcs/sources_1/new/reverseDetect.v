`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/14 02:52:28
// Design Name: 
// Module Name: reverseDetect
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


module reverseDetect(input sys_clk, input reverse, input engine_power_signal, output reg reverse_signal);
  always @(posedge sys_clk)
  begin
      if (engine_power_signal) begin
          reverse_signal <= reverse;
      end else begin
          reverse_signal <= 1'b0;
      end
  end
endmodule