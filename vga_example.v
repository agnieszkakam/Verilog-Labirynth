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
  output reg [3:0] b,
  
  inout wire ps2_data,
  inout wire ps2_clk
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
  
  //---
    localparam INSTRUCTIONS = 1'b0;
    localparam SUCCESS = 1'b1;
    wire game_stage;
    wire [7:0] char_yx_ins_out;
    wire [6:0] char_code_bg_out;
    
    char_rom_16x16 instructions_char_rom (
      .mode(INSTRUCTIONS),
      .char_yx(char_yx_ins_out),
      .char_code(char_code_bg_out)  
    );
    
    wire [10:0] vcount_out_ins_char, hcount_out_ins_char;
    wire vsync_out_ins_char, hsync_out_ins_char;
    wire vblnk_out_ins_char, hblnk_out_ins_char;
    wire [11:0] rgb_out_ins_char;
    wire [7:0] char_line_pixels1;
    wire [3:0] char_line1;
    
    font_rom the_font(
    
      .clk(pclk),
      .rst(rst),
      .addr({char_code_bg_out[6:0],char_line1[3:0]}),
      .char_line_pixels(char_line_pixels1)
    
    );
    
    draw_rect_char  #(.XPOS(300), .YPOS(1)) instruction_note (
    
    .clk(pclk),    
    .rst(rst),     
    .enable(1'b1),                       
    .hcount_in(hcount_bg_out),
    .hsync_in(hsync_bg_out),  
    .hblank_in(hblnk_bg_out), 
    .vcount_in(vcount_bg_out),
    .vsync_in(vsync_bg_out),
    .vblank_in(vblnk_bg_out),
    .rgb_in(rgb_bg_out),
    .char_pixels(char_line_pixels1),
                     
    .hcount_out(hcount_out_ins_char),
    .hsync_out(hsync_out_ins_char), 
    .hblank_out(hblnk_out_ins_char),
    .vcount_out(vcount_out_ins_char),
    .vsync_out(vsync_out_ins_char),
    .vblank_out(vblnk_out_ins_char),
    .rgb_out(rgb_out_ins_char),
    .char_yx(char_yx_ins_out),
    .char_line(char_line1)
    
    );
  //---
  
    wire [11:0] xpos_o, ypos_o;
    wire [10:0] vcount_out_o, hcount_out_o;
    wire vsync_out_o, hsync_out_o;
    wire vblnk_out_o, hblnk_out_o;
    wire [11:0] rgb_out_o;
    
    draw_dynamic_obst my_draw_dynamic_obst (
    
    .hcount_in(hcount_out_ins_char),
    .hsync_in(hsync_out_ins_char),
    .hblank_in(hblnk_out_ins_char),
    .vcount_in(vcount_out_ins_char),
    .vsync_in(vsync_out_ins_char),
    .vblank_in(vblnk_out_ins_char),
    .pclk(pclk),
    .rgb_in(rgb_out_ins_char),
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
wire mouse_en;
wire m_left;

user_pos_ctl user_pos_ctl (
    .clk(clk_500Hz),
    .rst(rst),
    .keys({keyU,keyD,keyR,keyL}),       // {keyU,keyD,keyR,keyL}
    
    .xpos(user_xpos),
    .ypos(user_ypos),
    .dynamic_o_xpos(xpos_o),
    .dynamic_o_ypos(ypos_o),
    .mouse_en(mouse_en)
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
  
  wire [7:0] char_yx2;
  wire [6:0] char_code2;
  
  char_rom_16x16 goodbye_char_rom (
    .mode(SUCCESS),
    .char_yx(char_yx2),
    .char_code(char_code2)  
  );
  
  wire [10:0] vcount_out_char, hcount_out_char;
  wire vsync_out_char, hsync_out_char;
  wire vblnk_out_char, hblnk_out_char;
  wire [11:0] rgb_out_char;
  wire [7:0] char_line_pixels2;
  wire [3:0] char_line2;
  
  font_rom my_font(
  
    .clk(pclk),
    .rst(rst),
    .addr({char_code2[6:0],char_line2[3:0]}),
    .char_line_pixels(char_line_pixels2)
  
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
  .char_pixels(char_line_pixels2),
                   
  .hcount_out(hcount_out_char),
  .hsync_out(hsync_out_char), 
  .hblank_out(hblnk_out_char),
  .vcount_out(vcount_out_char),
  .vsync_out(vsync_out_char),
  .vblank_out(vblnk_out_char),
  .rgb_out(rgb_out_char),
  .char_yx(char_yx2),
  .char_line(char_line2)
  
  );
//MOUSE-----------------------------------------------------

wire [11:0] xpos_mouse, ypos_mouse;
wire [3:0] red_out_m, green_out_m, blue_out_m;
wire en_m;
 
MouseCtl my_MouseCtl (
    .rst(rst),
    .clk(clk100MHz),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .xpos(xpos_mouse),
    .ypos(ypos_mouse),
    .zpos(),
    .left(m_left),  
    .middle(),    
    .right(),     
    .new_event(), 
    .value(12'b0),     
    .setx(1'b0),      
    .sety(1'b0),      
    .setmax_x(1'b0),  
    .setmax_y(1'b0)    
);

MouseDisplay my_MDisplay (
    //inputs
    .pixel_clk(pclk),
    .xpos(xpos_mouse),
    .ypos(ypos_mouse),
    .hcount(hcount_out_char),
    .vcount(vcount_out_char),
    .blank(hblnk_out_char || vblnk_out_char),
    .red_in(rgb_out_char[11:8]),
    .green_in(rgb_out_char[7:4]),
    .blue_in(rgb_out_char[3:0]),
    //outputs
    .enable_mouse_display_out(en_m),
    .red_out(red_out_m),
    .green_out(green_out_m),
    .blue_out(blue_out_m)
);
  
  always @(posedge pclk) begin
    if(rst) begin
        vs <= 0;
        hs <= 0;
        {r,g,b} <= 0;
    end
    else begin
        if (mouse_en == 1'b1) begin
            vs <= vsync_out_char;
            hs <= hsync_out_char;
            {r,g,b} <= {red_out_m,green_out_m,blue_out_m};
        end
        else begin
            vs <= vsync_out_char;
            hs <= hsync_out_char;
            {r,g,b} <= rgb_out_char;
        end
    end
  end
  
endmodule