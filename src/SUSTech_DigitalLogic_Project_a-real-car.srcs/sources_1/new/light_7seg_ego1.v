`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/15 02:27:21
// Design Name: 
// Module Name: light_7seg_ego1
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


module light_7seg_ego1 (
    input [3:0] sw,
    input encounter,
    output reg [7:0] seg_out
);
  always @(*) begin
    if (encounter == 1'b0) begin
      seg_out = 8'b00000010;
    end else begin
      case (sw)
        4'h0: seg_out = 8'b11111100;
        4'h1: seg_out = 8'b01100000;
        4'h2: seg_out = 8'b11011010;
        4'h3: seg_out = 8'b11110010;
        4'h4: seg_out = 8'b01100110;
        4'h5: seg_out = 8'b10110110;
        4'h6: seg_out = 8'b10111110;
        4'h7: seg_out = 8'b11100000;
        4'h8: seg_out = 8'b11111110;
        4'h9: seg_out = 8'b11110110;
        4'ha: seg_out = 8'b11101110;
        4'hb: seg_out = 8'b00111110;
        4'hc: seg_out = 8'b10011100;
        4'hd: seg_out = 8'b01111010;
        4'he: seg_out = 8'b10011110;
        4'hf: seg_out = 8'b00000001;
        default: seg_out = 8'b00000001;
      endcase
    end
  end
endmodule
