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
// The module draws a rectangle starting at (x_pos, y_pos) and goes right and down to reach HEIGHT and WIDTH set by the prameters.
// Its coulour may be changed by modifying RGB value which is by default set to yellow (R=255, G=255, B=0).
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module draw_dynamic_obst
#(    
parameter WIDTH = 50,      //vertical range
parameter HEIGHT = 50,      //horizontal range
parameter RECT_RGB = 12'hB59     //rectangle's coulour (default: pink)
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

reg [11:0] rgb_temp;
reg [11:0] rgb_out_nxt;
reg [10:0] hcount_temp, vcount_temp;
reg hsync_temp, vsync_temp, hblank_temp, vblank_temp; 
 
 localparam OBST_SEPARATION = 100;
 
//sequential part

always @(posedge pclk) begin

    if (rst) begin
    hcount_out <= 0;
    hsync_out <= 0;
    hblank_out <= 0;
    vcount_out <= 0;
    vsync_out <= 0;
    vblank_out <= 0;
    rgb_out <= 0;  
    end
  
    else begin
    hcount_out <= hcount_in;
    hsync_out <= hsync_in;
    hblank_out <= hblank_in;
    vcount_out <= vcount_in;
    vsync_out <= vsync_in;
    vblank_out <= vblank_in;    
    rgb_out <= rgb_out_nxt;    
    end
end
//combinational part

always @* begin 
  if  (vblank_in || hblank_in)      //inactive screen
       rgb_out_nxt = rgb_in;
  else begin   //active screen
       if ((hcount_in >= x_pos && vcount_in >= y_pos &&
           hcount_in < (x_pos+WIDTH) && vcount_in < (y_pos+HEIGHT))         // 1st obstacle
           || (hcount_in >= x_pos && vcount_in >= (y_pos + OBST_SEPARATION) &&
           hcount_in < (x_pos+WIDTH) && vcount_in < (y_pos + HEIGHT + OBST_SEPARATION))         // 2nd obstacle
           || (hcount_in >= x_pos && vcount_in >= (y_pos + 2*OBST_SEPARATION) &&
           hcount_in < (x_pos+WIDTH) && vcount_in < (y_pos + HEIGHT + 2*OBST_SEPARATION)))        // 3rd obstacle
               rgb_out_nxt = RECT_RGB;
       else    //not-rectangle area
               rgb_out_nxt = rgb_in; 
  end            
end

endmodule