`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2019 16:09:00
// Design Name: 
// Module Name: draw_rect
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// The module draws a rectangle starting at (X_POS,Y_POS) and goes right and down to reach HEIGHT and WIDTH set by the prameters.
// Its coulour may be changed by modifying RGB value which is by default set to yellow (R=255, G=255, B=0).
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module draw_user
#(    
parameter WIDTH = 100,      //vertical range
parameter HEIGHT = 100,      //horizontal range
parameter YELLOW_RGB = 12'hFF0     //rectangle's coulour (default: yellow)
)
(
    input wire [10:0]  hcount_in,
	input wire hsync_in,
	input wire hblank_in,
	input wire [10:0] vcount_in,
	input wire vsync_in,
	input wire vblank_in,
	input wire pclk,
	input wire [11:0] rgb_in,
	input wire rst,   
	input wire [11:0] x_pos,
	input wire [11:0] y_pos, 
	//input wire [11:0] rgb_pixel,  
	
	output reg [10:0]  hcount_out,
    output reg hsync_out,
    output reg hblank_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblank_out,
    output reg [11:0] rgb_out,
    output reg game_won
    //output wire [11:0] pixel_addr
);

reg [11:0] rgb_temp, rgb_out_nxt, xpos_temp, ypos_temp, xpos_out, ypos_out;
//wire [11:0] addrx, addry;                             y_pos, y_pos_out
reg [10:0] hcount_temp, vcount_temp;
reg hsync_temp, vsync_temp, hblank_temp, vblank_temp, game_won_nxt, game_won_temp; 
 
//assign addry = vcount_in - y_pos;
//assign addrx = hcount_in - x_pos;
//assign pixel_addr = {addry[5:0],addrx[5:0]}; 

//sequential part

always @(posedge pclk) 
  if (rst) begin
    hcount_temp <= 0;
    hsync_temp <= 0;
    hblank_temp <= 0;
    vcount_temp <= 0;
    vsync_temp <= 0;
    vblank_temp <= 0;
    xpos_temp <= 0;
    ypos_temp <= 0;
    game_won_temp <=0; 
   
   
    hcount_out <= 0;
    hsync_out <= 0;
    hblank_out <= 0;
    vcount_out <= 0;
    vsync_out <= 0;
    vblank_out <= 0;
    game_won <=0; 
    xpos_out <= 0;
    ypos_out <= 0;
    
    rgb_out <= 0;  
  end
  else begin
    hcount_temp <= hcount_in;
    hsync_temp <= hsync_in;
    hblank_temp <= hblank_in;
    vcount_temp <= vcount_in;
    vsync_temp <= vsync_in;
    vblank_temp <= vblank_in;
    xpos_temp <= x_pos;
    ypos_temp <= y_pos;
    
    rgb_temp <= rgb_in;
    
    hcount_out <= hcount_temp;
    hsync_out <= hsync_temp;
    hblank_out <= hblank_temp;
    vcount_out <= vcount_temp;
    vsync_out <= vsync_temp;
    vblank_out <= vblank_temp;    
    xpos_out <=xpos_temp;
    ypos_out <=ypos_temp ;
    rgb_out <= rgb_out_nxt;
end

//combinational part
// assumption: module that provides xypos (dependent on key pressings)
//             is returning the same xypos value if xypos is colliding
//             with static obstacles
always @* begin 
  game_won_nxt = 1'b0;
  if  (vblank_temp || hblank_temp)      //inactive screen
    rgb_out_nxt = rgb_temp;
  else begin   //active screen
    if (hcount_temp >= xpos_temp+20 && vcount_temp >= ypos_temp+10 && hcount_temp < (xpos_temp+40) && vcount_temp < (ypos_temp+30)) rgb_out_nxt = 12'h000;
    else if (hcount_temp >= xpos_temp+60 && vcount_temp >= ypos_temp+10 && hcount_temp < (xpos_temp+80) && vcount_temp < (ypos_temp+30)) rgb_out_nxt = 12'h000;
    else if (hcount_temp >= xpos_temp+40 && vcount_temp >= ypos_temp+60 && hcount_temp < (xpos_temp+80) && vcount_temp < (ypos_temp+80)) rgb_out_nxt = 12'hfff;
    else if (hcount_temp >= xpos_temp && vcount_temp >= ypos_temp && hcount_temp < (xpos_temp+WIDTH) && vcount_temp < (ypos_temp+HEIGHT)) rgb_out_nxt = YELLOW_RGB;
    else    //not-rectangle area
        rgb_out_nxt = rgb_temp; 
    end   
    
   // destination reached? not ideally, but at least covering the quarter of the doors' surface
 
 if ( (xpos_temp + WIDTH) > 750 && (ypos_temp+HEIGHT) < 400 && ypos_temp > 200 )  //make sure to block the user on the right edge of the screen 
    game_won_nxt = 1'b1;
end

endmodule
