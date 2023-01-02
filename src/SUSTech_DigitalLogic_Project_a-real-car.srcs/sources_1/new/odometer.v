`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/15 02:25:50
// Design Name: 
// Module Name: odometer
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


module odometer(
    input sys_clk,
    input reset,
    input encounter,
    output [7: 0] seg1,
    output [7: 0] seg0,
    output reg [7: 0] seg_en,
    output reg[31:0] nums
);
reg [2: 0] cnt = 3'b000;
reg [2: 0] next_cnt = 3'b001;
reg [3: 0] sw1;
reg [3: 0] sw0;

light_7seg_ego1 light1(sw1, ~reset, seg1);
light_7seg_ego1 light2(sw0, ~reset, seg0);

reg [31: 0] ttt = 32'd0; 
reg [31: 0] cntt = 32'b0;
reg [31: 0] nums = 32'd0;

always @ (posedge sys_clk) begin
    if (reset == 1'b1) begin
        cntt <= 32'b0;
        nums = 32'd0;
    end else if (encounter ==  1'b1) begin
        if (cntt == 32'd100000000) begin
            if (nums[3: 0] == 4'd9) begin
                nums[3: 0] <= 4'b0000;
                if (nums[7: 4] == 4'd9) begin
                    nums[7: 4] <= 4'b0000;
                    if(nums[11: 8] == 4'd9) begin
                        nums[11:8] <= 4'b0000;
                        if (nums[15: 12] == 4'd9) begin
                            nums[15: 12] <= 4'b0000;
                            if (nums[19: 16] == 4'd9) begin
                                nums[19: 16] <= 4'b0000;
                                if (nums[23: 20] == 4'd9) begin
                                    nums[23: 20] <= 4'b0000;
                                    if (nums[27: 24] == 4'd9) begin
                                        nums[27: 24] <= 4'b0000;
                                        if (nums[31: 28] == 4'd9) begin
                                            nums[31: 28] <= 4'b0000;
                                        end else begin
                                            nums[31: 28] <= nums[31: 28] + 4'b0001;
                                        end
                                    end else begin
                                        nums[27: 24] <= nums[27: 24] + 4'b0001;
                                    end
                                end else begin
                                    nums[23: 20] <= nums[23: 20] + 4'b0001;
                                end
                            end else begin
                                nums[19: 16] = nums[19: 16] + 4'b0001;
                            end
                        end else begin
                            nums[15: 12] <= nums[15: 12] + 4'b0001;
                        end
                    end else begin
                        nums[11:8] <= nums[11:8] + 1;
                    end
                end else begin
                    nums[7: 4] <= nums[7: 4] + 4'b0001;
                end
            end else begin
                nums[3: 0] <= nums[3: 0] + 4'b0001;
            end
            cntt = 32'd0;
        end else begin
            cntt = cntt + 32'b1;
        end
    end
end 



always @(posedge sys_clk) begin
    if (ttt == 32'd30000) begin
    if (cnt == 3'b111) next_cnt <= 3'b000;
    else next_cnt <= cnt + 1'b001;
    case (cnt)
        3'b000: begin 
            seg_en <= 8'b00000001;
            sw0 <= nums[3: 0];
        end
        3'b001: begin 
            seg_en <= 8'b00000010;
            sw0 <= nums[7: 4];
        end
        3'b010: begin 
            seg_en <= 8'b00000100;
            sw0 <= nums[11: 8];
        end
        3'b011: begin 
            seg_en <= 8'b00001000;
            sw0 <= nums[15: 12];
        end
        3'b100: begin 
            seg_en <= 8'b00010000;
            sw1 <= nums[19: 16];
        end
        3'b101: begin 
            seg_en <= 8'b00100000;
            sw1 <= nums[23: 20];
        end
        3'b110: begin 
            seg_en <= 8'b01000000;
            sw1 <= nums[27: 24];
        end
        3'b111: begin 
            seg_en <= 8'b10000000;
            sw1 <= nums[31 : 28];
        end
    endcase
    cnt = next_cnt;
    ttt = 32'd0;
    end else begin
    ttt = ttt + 32'd1;
    end
end
endmodule
