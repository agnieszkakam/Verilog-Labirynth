`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2019 14:11:31
// Design Name: 
// Module Name: draw_background
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


module draw_background(
	input wire [10:0]  hcount_in,
	input wire hsync_in,
	input wire hblank_in,
	input wire [10:0] vcount_in,
	input wire vsync_in,
	input wire vblank_in,
	input wire pclk,
	input wire rst,        
	
	output reg [10:0]  hcount_out,
    output reg hsync_out,
    output reg hblank_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblank_out,
    output reg [11:0] rgb_out,
    output reg [17:0] st_obst_xy       //contains left-corner coordinates of static obstables scaled by 100 (e.g. x=700 -> 7)
);

    //*** violet colour (RGB)
  localparam VIOLET_RGB = {4'h8, 4'h2, 4'hC};   
  
  localparam BROWN_RGB = 12'h530; 

    //*** pink colour (RGB)
 // localparam PINK_RGB = {4'hB, 4'h5, 4'h9}; 
  
  localparam OBSTACLE_SIDE = 100;

 //static obstacles (left-corner) xy coordinates 
 //the coordinates are scaled and are thought to be multiplied by 100 
localparam STAT_OBST_1_X = 3'd1;
localparam STAT_OBST_1_Y = 3'd0;
localparam STAT_OBST_2_X = 3'd2;
localparam STAT_OBST_2_Y = 3'd1;
localparam STAT_OBST_3_X = 3'd3;
localparam STAT_OBST_3_Y = 3'd2;
 
reg [11:0] rgb_out_nxt;

//sequential part
always @(posedge pclk) 
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

//combinational part
always @*
  begin
  
    st_obst_xy = {STAT_OBST_1_X,STAT_OBST_1_Y,STAT_OBST_2_X,STAT_OBST_2_Y,STAT_OBST_3_X,STAT_OBST_3_Y};
  
    // During blanking, make it it black.
    if (vblank_in || hblank_in) rgb_out_nxt = 12'h0_0_0; 
    else
    begin
      // Active display, static obstacles
      if (         
        // 1st obst. (100;0)
        ( hcount_in >= 100*STAT_OBST_1_X && hcount_in < (100*STAT_OBST_1_X + OBSTACLE_SIDE) && vcount_in >= 100*STAT_OBST_1_Y && vcount_in < (100*STAT_OBST_1_Y + OBSTACLE_SIDE) )
        // 2nd obst. (200;100)                                                                                                     
        || (hcount_in >= 100*STAT_OBST_2_X && hcount_in < (100*STAT_OBST_2_X + OBSTACLE_SIDE) && vcount_in >= 100*STAT_OBST_2_Y && vcount_in < (100*STAT_OBST_2_Y + OBSTACLE_SIDE) )
        // 3rd obst. (100;700)                                                                                                    
        || (hcount_in >= 100*STAT_OBST_3_X && hcount_in < (100*STAT_OBST_3_X + OBSTACLE_SIDE) && vcount_in >= 100*STAT_OBST_3_Y && vcount_in < (100*STAT_OBST_3_Y + OBSTACLE_SIDE) ) )
                rgb_out_nxt = VIOLET_RGB;
                
        // destination = "door"
       
       
      else if ( (hcount_in >= 720 && vcount_in >= 310 &&
        hcount_in < 730 && vcount_in < 320)  )
            rgb_out_nxt = 12'h500;     
      else if ( (hcount_in >= 710 && vcount_in >= 250 &&
            hcount_in < 790 && vcount_in < 390)  )
                rgb_out_nxt = BROWN_RGB;
      else if ( (hcount_in >= 700 && vcount_in >= 240 &&
            hcount_in < 780 && vcount_in < 380)  )
                rgb_out_nxt = 12'h500;
      //else if ( (hcount_in >= 700 && vcount_in >= 200 &&
            //hcount_in < 800 && vcount_in < 400)  )
                //rgb_out_nxt = BROWN_RGB;          

        // Active display, edges, make yellow lines.
      else if ((vcount_in == 0) || (vcount_in == 599) || (hcount_in == 0) || (hcount_in == 799))
                rgb_out_nxt = 12'hf_f_0;
                                      
      // Active display, interior, fill with gray.
      // You will replace this with your own test.
      else rgb_out_nxt = 12'h8_8_8;    
    end
  end

endmodule
