// File: vga_example.v
// This is the top level design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.
 
module vga_example (
  input wire clk,
  input wire key_up, key_down, key_right, key_left, rst_btn, 
  output reg vs,
  output reg hs,
  output reg [3:0] r,
  output reg [3:0] g,
  output reg [3:0] b
);

  // Converts 100 MHz clk into 40 MHz pclk.
  
    wire locked;
    wire pclk;
  
       //clocking wizard
  
  wire clk100MHz;
    
    clk_wiz_0 clk_wiz_0_clk_wiz (
      .clk100MHz(clk100MHz),       
      .clk40MHz(pclk),             
      .reset(rst_btn),
      .locked(locked),
      .clk(clk)
    );      

  wire clk_100Hz;
  
  clk_divider #(.FREQ_OUT(100)) clk_divider_100Hz (
     .clk100MHz(clk100MHz),        //input clock 100 MHz
     .rst (rst),                  
     .clk_div (clk_100Hz)           
  );
  
  wire clk_500Hz;
  
  clk_divider #(.FREQ_OUT(500)) clk_divider_500Hz (
     .clk100MHz(clk100MHz),        //input clock 100 MHz
     .rst (rst),                  
     .clk_div (clk_500Hz)           
  );

  // Instantiate the vga_timing module, which is
  // the module you are designing for 1st lab.

  wire [10:0] vcount, hcount;
  wire vsync, hsync;
  wire vblnk, hblnk;

  vga_timing my_timing (
    .pclk(pclk),
    .rst(rst),
    .vcount(vcount),
    .vsync(vsync),
    .vblnk(vblnk),
    .hcount(hcount),
    .hsync(hsync),
    .hblnk(hblnk)
  );

  // Instantiate the draw_background module
  
  wire [10:0] vcount_bg_out, hcount_bg_out;
  wire vsync_bg_out, hsync_bg_out;
  wire vblnk_bg_out, hblnk_bg_out;
  wire [11:0] rgb_bg_out;
  wire [17:0] st_obst_xy_in;
  
  draw_background my_background (
    .hcount_in(hcount),
    .hsync_in(hsync),
    .hblank_in(hblnk),
    .vcount_in(vcount),
    .vsync_in(vsync),
    .vblank_in(vblnk),
    .pclk(pclk),
    .rst(rst),
    .hcount_out(hcount_bg_out),
    .hsync_out(hsync_bg_out),
    .hblank_out(hblnk_bg_out),
    .vcount_out(vcount_bg_out),
    .vsync_out(vsync_bg_out),
    .vblank_out(vblnk_bg_out),
    .rgb_out(rgb_bg_out),
    .st_obst_xy(st_obst_xy_in)  
  );
  
  
    wire [11:0] xpos_o, ypos_o;
    wire [10:0] vcount_out_o, hcount_out_o;
    wire vsync_out_o, hsync_out_o;
    wire vblnk_out_o, hblnk_out_o;
    wire [11:0] rgb_out_o;
    
    draw_dynamic_obst my_draw_dynamic_obst (
    
    .hcount_in(hcount_bg_out),
    .hsync_in(hsync_bg_out),
    .hblank_in(hblnk_bg_out),
    .vcount_in(vcount_bg_out),
    .vsync_in(vsync_bg_out),
    .vblank_in(vblnk_bg_out),
    .pclk(pclk),
    .rgb_in(rgb_bg_out),
    .rst(rst),
    
    .x_pos(xpos_o),
    .y_pos(ypos_o),
    .hcount_out(hcount_out_o),
    .vcount_out(vcount_out_o),
    .hsync_out(hsync_out_o),
    .hblank_out(hblnk_out_o),
    .vsync_out(vsync_out_o),
    .vblank_out(vblnk_out_o),
    .rgb_out(rgb_out_o)
    
    );

wire keyL, keyR, keyU, keyD; 

//debounce buttons

debounce up_debounce (
    .clk(pclk),
    .reset(1'b0),
    .sw(key_up),
    .db_level(keyU),
    .db_tick() 
);

debounce down_debounce (
    .clk(pclk),
    .reset(1'b0),
    .sw(key_down),
    .db_level(keyD),
    .db_tick() 
);

debounce right_debounce (
    .clk(pclk),
    .reset(1'b0),
    .sw(key_right),
    .db_level(keyR),
    .db_tick() 
);

debounce left_debounce (
    .clk(pclk),
    .reset(1'b0),
    .sw(key_left),
    .db_level(keyL),
    .db_tick() 
);

debounce rst_debounce (
    .clk(pclk),
    .reset(1'b0),
    .sw(rst_btn),
    .db_level(),
    .db_tick(rst) 
);

wire [11:0] user_xpos, user_ypos;

user_pos_ctl user_pos_ctl (
    .clk(clk_500Hz),
    .rst(rst),
    .keys({keyU,keyD,keyR,keyL}),       // {keyU,keyD,keyR,keyL}
    //.st_obst_xy(st_obst_xy_in),       // st_obst_xy = {STAT_OBST_1_X,STAT_OBST_1_Y,STAT_OBST_2_X,STAT_OBST_2_Y,STAT_OBST_3_X,STAT_OBST_3_Y};
    
    .xpos(user_xpos),
    .ypos(user_ypos),
    .dynamic_o_xpos(xpos_o),
    .dynamic_o_ypos(ypos_o)
);

  wire game_won; 
  wire [10:0] vcount_out_u, hcount_out_u;
  wire vsync_out_u, hsync_out_u;
  wire vblnk_out_u, hblnk_out_u;
  wire [11:0] rgb_out_u;
  
  draw_user draw_user (
     .hcount_in(hcount_out_o),
     .hsync_in(hsync_out_o),
     .hblank_in(hblnk_out_o),
     .vcount_in(vcount_out_o),
     .vsync_in(vsync_out_o),
     .vblank_in(vblnk_out_o),
     .pclk(pclk),
     .rgb_in(rgb_out_o),
     .rst(rst),
     
     .x_pos(user_xpos),
     .y_pos(user_ypos),
     .hcount_out(hcount_out_u),
     .hsync_out(hsync_out_u),
     .hblank_out(hblnk_out_u),
     .vcount_out(vcount_out_u),
     .vsync_out(vsync_out_u),
     .vblank_out(vblnk_out_u),
     .rgb_out(rgb_out_u),
     .game_won(game_won)
  );
  
  
  dynamic_obst_ctl my_dynamic_obst_ctl (
  
  .clk(clk_100Hz),
  .rst(rst),
  .xpos(xpos_o),
  .ypos(ypos_o)

  );
  
  wire game_stage;
  wire [7:0] char_yx;
  wire [6:0] char_code;
  
  char_rom_16x16 goodbye_char_rom (
    //.game_stage(1'b0),
    .char_yx(char_yx),
    .char_code(char_code)  
  );
  
  wire [10:0] vcount_out_char, hcount_out_char;
  wire vsync_out_char, hsync_out_char;
  wire vblnk_out_char, hblnk_out_char;
  wire [11:0] rgb_out_char;
  wire [7:0] char_line_pixels;
  wire [3:0] char_line;
  
  font_rom my_font(
  
    .clk(pclk),
    .rst(rst),
    .addr({char_code[6:0],char_line[3:0]}),
    .char_line_pixels(char_line_pixels)
  
  );
  
  draw_rect_char  #(.XPOS(350), .YPOS(310)) goodbye_note (
  
  .clk(pclk),    
  .rst(rst),     
  .enable(game_won),                  //connect there a signal when destiantion reached       
  .hcount_in(hcount_out_u),
  .hsync_in(hsync_out_u),  
  .hblank_in(hblnk_out_u), 
  .vcount_in(vcount_out_u),
  .vsync_in(vsync_out_u),
  .vblank_in(vblnk_out_u),
  .rgb_in(rgb_out_u),
  .char_pixels(char_line_pixels),
                   
  .hcount_out(hcount_out_char),
  .hsync_out(hsync_out_char), 
  .hblank_out(hblnk_out_char),
  .vcount_out(vcount_out_char),
  .vsync_out(vsync_out_char),
  .vblank_out(vblnk_out_char),
  .rgb_out(rgb_out_char),
  .char_yx(char_yx),
  .char_line(char_line)
  
  );
  
  always @(posedge pclk) begin
    if(rst) begin
        vs <= 0;
        hs <= 0;
        {r,g,b} <= 0;
    end
    else begin
        vs <= vsync_out_char;
        hs <= hsync_out_char;
        {r,g,b} <= rgb_out_char;
    end
  end
  
endmodule