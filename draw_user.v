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
    output reg [11:0] rgb_out
    //output wire [11:0] pixel_addr
);

reg [11:0] rgb_temp, rgb_out_nxt;
//wire [11:0] addrx, addry;
reg [10:0] hcount_temp, vcount_temp;
reg hsync_temp, vsync_temp, hblank_temp, vblank_temp; 
 
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
  
    hcount_out <= 0;
    hsync_out <= 0;
    hblank_out <= 0;
    vcount_out <= 0;
    vsync_out <= 0;
    vblank_out <= 0;
    
    rgb_out <= 0;  
  end
  else begin
    hcount_temp <= hcount_in;
    hsync_temp <= hsync_in;
    hblank_temp <= hblank_in;
    vcount_temp <= vcount_in;
    vsync_temp <= vsync_in;
    vblank_temp <= vblank_in;
    
    rgb_temp <= rgb_in;
    
    hcount_out <= hcount_temp;
    hsync_out <= hsync_temp;
    hblank_out <= hblank_temp;
    vcount_out <= vcount_temp;
    vsync_out <= vsync_temp;
    vblank_out <= vblank_temp;    
    
    rgb_out <= rgb_out_nxt;
end

//combinational part
// assumption: module that provides xypos (dependent on key pressings)
//             is returning the same xypos value if xypos is colliding
//             with static obstacles
always @* begin 
  if  (vblank_temp || hblank_temp)      //inactive screen
    rgb_out_nxt = rgb_temp;
  else begin   //active screen
    if (hcount_temp >= x_pos+20 && vcount_temp >= y_pos+10 && hcount_temp < (x_pos+40) && vcount_temp < (y_pos+30)) rgb_out_nxt = 12'h000;
    else if (hcount_temp >= x_pos+60 && vcount_temp >= y_pos+10 && hcount_temp < (x_pos+80) && vcount_temp < (y_pos+30)) rgb_out_nxt = 12'h000;
    else if (hcount_temp >= x_pos+20 && vcount_temp >= y_pos+60 && hcount_temp < (x_pos+80) && vcount_temp < (y_pos+80)) rgb_out_nxt = 12'hF00;
    else if (hcount_temp >= x_pos && vcount_temp >= y_pos && hcount_temp < (x_pos+WIDTH) && vcount_temp < (y_pos+HEIGHT)) rgb_out_nxt = YELLOW_RGB;
    else    //not-rectangle area
        rgb_out_nxt = rgb_temp; 
    end            
end

endmodule
