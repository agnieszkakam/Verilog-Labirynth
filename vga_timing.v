// File: vga_timing.v
// This is the vga timing design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_timing (
  input wire pclk,      //pixel clock rate
  input wire rst,
  output reg [10:0] vcount,
  output reg vsync,        //vertical synchronization signal
  output reg vblnk,        //when we're out of the 'active' screen
  output reg [10:0] hcount,
  output reg hsync,        //horizontal synchronization signal
  output reg hblnk         //when we're out of the 'active' screen
  );
  

  // Describe the actual circuit for the assignment.
  // Video timing controller set for 800x600@60fps
  // using a 40 MHz pixel clock per VESA spec.

//Display Timing for 800x600@60Hz [Video Electronics Standards Association]
//while using params 1 will be subtracted,
//cause we start from 0 (so we go 0...TotalTime-1 instead of 1...TotalTime)

localparam HOR_PIXELS = 800;
localparam HOR_BLANK_START = 800;
localparam HOR_SYNC_START = 840;
localparam HOR_SYNC_TIME = 128;
localparam HOR_SYNC_END = HOR_SYNC_START + HOR_SYNC_TIME;
localparam HOR_TOTAL_TIME = 1056;

localparam VER_PIXELS = 600;
localparam VER_BLANK_START = 600;
localparam VER_SYNC_START = 601;
localparam VER_SYNC_TIME = 4;
localparam VER_SYNC_END = VER_SYNC_START + VER_SYNC_TIME;
localparam VER_TOTAL_TIME = 628;

//init. the counters
initial hcount = 0;
initial vcount = 0;

always @(posedge pclk)
 begin
    if (rst) begin
     hcount <= 0;
     vcount <= 0;
     hblnk <= 0;
     hsync <= 0;
     vblnk <= 0;
     vsync <= 0;
    end
    else
     hcount <= hcount + 1;
     if ((HOR_BLANK_START - 1) <= hcount && hcount < (HOR_TOTAL_TIME - 1))
     begin
            hblnk <= 1'b1;             //between the horizontal front porch and back porch
            if ((HOR_SYNC_START - 1) <= hcount && hcount < (HOR_SYNC_END - 1))
                hsync <= 1'b1;           //the sync Pulse
            else
                hsync <= 1'b0;           //front/back porch, not the sync pulse
        end
        else if (hcount == (HOR_TOTAL_TIME - 1)) begin      
            hcount <= 0;
            hblnk <= 1'b0;
        end
    
        if (hcount == (HOR_TOTAL_TIME - 1))        
        begin
            vcount <= vcount + 1;
            if ((VER_BLANK_START - 1) <= vcount && vcount < (VER_TOTAL_TIME - 1))
            begin
                vblnk <= 1'b1;             //between the vertical front porch and back porch
                if ((VER_SYNC_START - 1) <= vcount && vcount < (VER_SYNC_END - 1))
                    vsync <= 1'b1;           //the sync Pulse
                else
                    vsync <= 1'b0;           //front/back porch, but not the sync pulse
            end
            else if (vcount == (VER_TOTAL_TIME - 1)) begin
                vcount <= 0;
                vblnk <= 1'b0;
            end
        end
    end
   
endmodule
