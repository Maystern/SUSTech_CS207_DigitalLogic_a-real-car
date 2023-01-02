`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/29 14:18:41
// Design Name: 
// Module Name: vga_top
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


module vga_top
(
    input                   clk   , 
    input                   rst ,
    input [31:0] record,
    input[6:0] state, 
    output reg[3:0] red, 
    output reg[3:0] green, 
    output reg[3:0] blue, 
    output hs, 
    output vs     
);


parameter       C_H_SYNC_PULSE      =   96  , 
                C_H_BACK_PORCH      =   148  ,
                C_H_ACTIVE_TIME     =   640 ,
                C_H_FRONT_PORCH     =   16  ,
                C_H_LINE_PERIOD     =   800 ;

              
parameter       C_V_SYNC_PULSE      =   2   , 
                C_V_BACK_PORCH      =   33  ,
                C_V_ACTIVE_TIME     =   480 ,
                C_V_FRONT_PORCH     =   10  ,
                C_V_FRAME_PERIOD    =   525 ;

parameter       C_IMAGE_WIDTH       =   140 ,
                C_IMAGE_HEIGHT      =   8;                 

reg [11:0]      R_h_cnt         ; 
reg [11:0]      R_v_cnt         ; 
reg             R_clk_25M       ;

wire            W_active_flag   ;
parameter NUM_DIV = 4;
reg [3:0]cnt;

wire[7:0] p [139:0];
reg[59:0] state_spell;
    RAM_set u_ram_1 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, record[31:28]}),
		.c0(p[0]),
		.c1(p[1]),
		.c2(p[2]),
		.c3(p[3]),
		.c4(p[4]),
		.c5(p[5]),
		.c6(p[6])
	);
	RAM_set u_ram_2 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, record[27:24]}),
		.c0(p[7]),
		.c1(p[8]),
		.c2(p[9]),
		.c3(p[10]),
		.c4(p[11]),
		.c5(p[12]),
		.c6(p[13])
	);
    RAM_set u_ram_3 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, record[23:20]}),
		.c0(p[14]),
		.c1(p[15]),
		.c2(p[16]),
		.c3(p[17]),
		.c4(p[18]),
		.c5(p[19]),
		.c6(p[20])
	);
    RAM_set u_ram_4 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, record[19:16]}),
		.c0(p[21]),
		.c1(p[22]),
		.c2(p[23]),
		.c3(p[24]),
		.c4(p[25]),
		.c5(p[26]),
		.c6(p[27])
	);
    RAM_set u_ram_5 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, record[15:12]}),
		.c0(p[28]),
		.c1(p[29]),
		.c2(p[30]),
		.c3(p[31]),
		.c4(p[32]),
		.c5(p[33]),
		.c6(p[34])
	);
    RAM_set u_ram_6 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, record[11:8]}),
		.c0(p[35]),
		.c1(p[36]),
		.c2(p[37]),
		.c3(p[38]),
		.c4(p[39]),
		.c5(p[40]),
		.c6(p[41])
	);
    RAM_set u_ram_7 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, record[7:4]}),
		.c0(p[42]),
		.c1(p[43]),
		.c2(p[44]),
		.c3(p[45]),
		.c4(p[46]),
		.c5(p[47]),
		.c6(p[48])
	);
    RAM_set u_ram_8 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, record[3:0]}),
		.c0(p[49]),
		.c1(p[50]),
		.c2(p[51]),
		.c3(p[52]),
		.c4(p[53]),
		.c5(p[54]),
		.c6(p[55])
	);
    RAM_set u_ram_9 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1111),
		.c0(p[56]),
		.c1(p[57]),
		.c2(p[58]),
		.c3(p[59]),
		.c4(p[60]),
		.c5(p[61]),
		.c6(p[62])
	);
    RAM_set u_ram_10 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1111),
		.c0(p[63]),
		.c1(p[64]),
		.c2(p[65]),
		.c3(p[66]),
		.c4(p[67]),
		.c5(p[68]),
		.c6(p[69])
	);
    RAM_set u_ram_11 (
		.clk(clk),
		.rst(rst),
		.data(state_spell[59:54]),
		.c0(p[70]),
		.c1(p[71]),
		.c2(p[72]),
		.c3(p[73]),
		.c4(p[74]),
		.c5(p[75]),
		.c6(p[76])
	);
    RAM_set u_ram_12 (
		.clk(clk),
		.rst(rst),
		.data(state_spell[53:48]),
		.c0(p[77]),
		.c1(p[78]),
		.c2(p[79]),
		.c3(p[80]),
		.c4(p[81]),
		.c5(p[82]),
		.c6(p[83])
	);
    RAM_set u_ram_13 (
		.clk(clk),
		.rst(rst),
		.data(state_spell[47:42]),
		.c0(p[84]),
		.c1(p[85]),
		.c2(p[86]),
		.c3(p[87]),
		.c4(p[88]),
		.c5(p[89]),
		.c6(p[90])
	);
    RAM_set u_ram_14 (
		.clk(clk),
		.rst(rst),
		.data(state_spell[41:36]),
		.c0(p[91]),
		.c1(p[92]),
		.c2(p[93]),
		.c3(p[94]),
		.c4(p[95]),
		.c5(p[96]),
		.c6(p[97])
	);
    RAM_set u_ram_15 (
		.clk(clk),
		.rst(rst),
		.data(state_spell[35:30]),
		.c0(p[98]),
		.c1(p[99]),
		.c2(p[100]),
		.c3(p[101]),
		.c4(p[102]),
		.c5(p[103]),
		.c6(p[104])
	);
    RAM_set u_ram_16 (
		.clk(clk),
		.rst(rst),
		.data(state_spell[29:24]),
		.c0(p[105]),
		.c1(p[106]),
		.c2(p[107]),
		.c3(p[108]),
		.c4(p[109]),
		.c5(p[110]),
		.c6(p[111])
	);
    RAM_set u_ram_17 (
		.clk(clk),
		.rst(rst),
		.data(state_spell[23:18]),
		.c0(p[112]),
		.c1(p[113]),
		.c2(p[114]),
		.c3(p[115]),
		.c4(p[116]),
		.c5(p[117]),
		.c6(p[118])
	);
    RAM_set u_ram_18 (
		.clk(clk),
		.rst(rst),
		.data(state_spell[17:12]),
		.c0(p[119]),
		.c1(p[120]),
		.c2(p[121]),
		.c3(p[122]),
		.c4(p[123]),
		.c5(p[124]),
		.c6(p[125])
	);
    RAM_set u_ram_19 (
		.clk(clk),
		.rst(rst),
		.data(state_spell[11:6]),
		.c0(p[126]),
		.c1(p[127]),
		.c2(p[128]),
		.c3(p[129]),
		.c4(p[130]),
		.c5(p[131]),
		.c6(p[132])
	);
    RAM_set u_ram_20 (
		.clk(clk),
		.rst(rst),
		.data(state_spell[5:0]),
		.c0(p[133]),
		.c1(p[134]),
		.c2(p[135]),
		.c3(p[136]),
		.c4(p[137]),
		.c5(p[138]),
		.c6(p[139])
	);

    always @ (posedge clk or negedge rst)
    begin
		if(!rst) state_spell <= 60'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111;
		else if(state == 7'b1100010) state_spell <= 60'b0010_1011_1111_0110_0001_0111_1111_1111_1111_1111_1111_1111_1111_1111_1111;//A ON 
		else if(state == 7'b1000001) state_spell <= 60'b0010_1011_1111_0110_0000_1111_0011_1111_1111_1111_1111_1111_1111_1111_1111;
		else if(state == 7'b0110010) state_spell <= 60'b0111_0011_1111_0110_0001_0111_1111_1111_1111_1111_1111_1111_1111_1111_1111;
		else if(state == 7'b0010001) state_spell <= 60'b0111_0011_1111_0110_0000_1111_0011_1111_1111_1111_1111_1111_1111_1111_1111;
		else if(state == 7'b0001001) state_spell <= 60'b0101_1011_1111_0110_0000_1111_0011_1111_1111_1111_1111_1111_1111_1111_1111;
		else if(state == 7'b0101010) state_spell <= 60'b0101_1011_1111_0110_0001_0111_1111_1111_1111_1111_1111_1111_1111_1111_1111;
		else if(state == 7'b0101011) state_spell <= 60'b0101_1011_1111_0110_0001_0111_1111_1101_1100_0111_0100_1010_0110_1101_1101;
		else if(state == 7'b0101100) state_spell <= 60'b0101_1011_1111_0110_0001_0111_1111_1101_0110_0110_0001_1111_0011_1011_1111;
		else state_spell <= 60'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111; 
    end
    
always @(posedge clk or negedge rst)
begin
    if(!rst) begin
        cnt     <= 4'd0;
        R_clk_25M     <= 1'b0;
    end
    else if(cnt < NUM_DIV / 2 - 1) begin
        cnt     <= cnt + 1'b1;
        R_clk_25M     <= R_clk_25M ;
    end
    else begin
        cnt     <= 4'd0;
        R_clk_25M     <= ~R_clk_25M ;
    end
end

always @(posedge R_clk_25M or negedge rst)
begin
    if(!rst)
        R_h_cnt <=  12'd0   ;
    else if(R_h_cnt == C_H_LINE_PERIOD - 1'b1)
        R_h_cnt <=  12'd0   ;
    else
        R_h_cnt <=  R_h_cnt + 1'b1  ;                
end                

assign hs =   (R_h_cnt < C_H_SYNC_PULSE) ? 1'b0 : 1'b1    ; 


always @(posedge R_clk_25M or negedge rst)
begin
    if(!rst)
        R_v_cnt <=  12'd0   ;
    else if(R_v_cnt == C_V_FRAME_PERIOD - 1'b1)
        R_v_cnt <=  12'd0   ;
    else if(R_h_cnt == C_H_LINE_PERIOD - 1'b1)
        R_v_cnt <=  R_v_cnt + 1'b1  ;
    else
        R_v_cnt <=  R_v_cnt ;                        
end   

assign vs =   (R_v_cnt < C_V_SYNC_PULSE) ? 1'b0 : 1'b1    ; 

assign W_active_flag =  (R_h_cnt >= (C_H_SYNC_PULSE + C_H_BACK_PORCH                  ))  &&
                        (R_h_cnt <= (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_H_ACTIVE_TIME))  && 
                        (R_v_cnt >= (C_V_SYNC_PULSE + C_V_BACK_PORCH                  ))  &&
                        (R_v_cnt <= (C_V_SYNC_PULSE + C_V_BACK_PORCH + C_V_ACTIVE_TIME))  ;   

	
always @ (posedge R_clk_25M or negedge rst)
	begin
		if (!rst) begin
			red <= 4'b0000;
			green <=4'b0000;
			blue <= 4'b0000;
		end
        
		else if (W_active_flag) begin
			if (R_h_cnt >= (C_H_SYNC_PULSE + C_H_BACK_PORCH                        )  && 
               R_h_cnt <= (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_IMAGE_WIDTH  - 1'b1)  &&
               R_v_cnt >= (C_V_SYNC_PULSE + C_V_BACK_PORCH                        )  && 
               R_v_cnt <= (C_V_SYNC_PULSE + C_V_BACK_PORCH + C_IMAGE_HEIGHT - 1'b1) ) begin
				if (p[R_h_cnt-(C_H_SYNC_PULSE + C_H_BACK_PORCH)][R_v_cnt-(C_V_SYNC_PULSE + C_V_BACK_PORCH )]) begin
					red <= 4'b1111;
					green <= 4'b1111;
					blue <= 4'b1111;
				end
				else begin
					red <= 4'b0000;
					green <= 4'b0000;
					blue <= 4'b0000;
				end
			end
			else begin
				red <= 4'b0000;
				green <= 4'b0000;
				blue <= 4'b0000;
			end
		end
		else begin
			red <= 4'b0000;
			green <= 4'b0000;
			blue <= 4'b0000;
		end
	end

endmodule
