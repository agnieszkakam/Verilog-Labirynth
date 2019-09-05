`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.04.2019 12:36:06
// Design Name: 
// Module Name: draw_rect_char
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//
// Draws a char whose font is provided by font_rom module.
// The combinational part for rgb is based on the following concept:
// 'char_pixels' give us 8 bits for the one vertical line of the char -
//          if bit=1, the pixel should be printed with a different colour, to create a char (later on) 
// 'hcount_in[2:0]' may vary from 0..7 and indicates current vert. position "in the printed char"
// the sum of currently printed pixel (index of "char_pixels": 0..7) and "hcount_in[2:0]" is always equal to 7;
// e.g. if hcount_in[2:0]=3'b000, then we print (if 1) the first component of the char, which is char_pixels[7];
// if hcount_in[2:0]=3'b001, then we move on and print char_pixels[6]...
// Dependencies: 
// 
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module draw_rect_char #(
    parameter XPOS = 0,
    parameter YPOS = 0
)
(
   input wire clk,
   input wire rst,
   input wire enable,
   input wire [10:0] hcount_in,
   input wire hsync_in,
   input wire hblank_in,
   input wire [10:0] vcount_in,
   input wire vsync_in,
   input wire vblank_in,
   input wire [11:0] rgb_in,
   input wire [7:0] char_pixels,     
   
   output reg [10:0]  hcount_out,
   output reg hsync_out,
   output reg hblank_out,
   output reg [10:0] vcount_out,
   output reg vsync_out,
   output reg vblank_out,
   output reg [11:0] rgb_out,
   output wire [7:0] char_yx,           //char position in the rectangle
   output wire [3:0] char_line          //line of the char
);

localparam WIDTH = 128;
localparam HEIGHT = 256;

reg [10:0] char_x, char_x_del, char_y;
reg [11:0] rgb_out_nxt, rgb_temp;
reg [10:0] hcount_temp, vcount_temp;
reg hsync_temp, vsync_temp, hblank_temp, vblank_temp;  

always @(posedge clk) begin
 if (rst) begin
         hsync_out <= 0;
         vsync_out <= 0;
         hblank_out <= 0;
         vblank_out <= 0;
         hcount_out <= 0;
         vcount_out <= 0;
         
         hsync_temp <= 0;
         vsync_temp <= 0;
         hblank_temp <= 0;
         vblank_temp <= 0;
         hcount_temp <= 0;
         vcount_temp <= 0;  
end
else begin
        hcount_out <= hcount_temp;
        vcount_out <= vcount_temp;
        hsync_out <= hsync_temp;
        vsync_out <= vsync_temp;
        hblank_out <= hblank_temp;
        vblank_out <= vblank_temp;
        rgb_out <= rgb_out_nxt;
        
        hcount_temp <= hcount_in;
        vcount_temp <= vcount_in;
        hsync_temp <= hsync_in;
        vsync_temp <= vsync_in;
        hblank_temp <= hblank_in;
        vblank_temp <= vblank_in;
        rgb_temp <= rgb_in;
   end
end

assign char_line = char_y[3:0];
assign char_yx = {char_y[7:4],char_x[6:3]};          //{y_char,x_char}
  
//print char 
always @* begin
    if (enable) begin
         char_y = vcount_in-YPOS; 
         char_x = hcount_in-XPOS;
         char_x_del = hcount_temp-XPOS;
         if (hcount_temp >= XPOS && hcount_temp < (WIDTH + XPOS)
             && vcount_temp >= YPOS && vcount_temp < (HEIGHT + YPOS)
             && (char_pixels[7 - char_x_del[2:0]]))       // 'char' rectangle
                 rgb_out_nxt = {vcount_temp,1'b1};
         else    //'non-char' area
                 rgb_out_nxt = rgb_temp; 
    end 
    else
                 rgb_out_nxt = rgb_temp; 
end 
 
endmodule   