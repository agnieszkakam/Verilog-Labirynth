`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2019 22:36:45
// Design Name: 
// Module Name: draw_rect_ctl
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


module dynamic_obst_ctl(
   input wire clk,          //100 Hz
   input wire rst,
   output reg [11:0] xpos,
   output reg [11:0] ypos
);

localparam VER_PIXELS = 600;
localparam RECT_HEIGHT = 50; 

localparam XPOS_INIT = 600;
localparam YPOS_INIT = 1;

localparam DOWN = 2'b01, UP = 2'b10, CHANGE_DIRECTION = 2'b11;

reg [11:0] xpos_nxt, ypos_nxt;  
//reg GO_UP;
//reg [1:0] state, state_nxt;

always @(posedge clk) begin
    if(rst) begin
        xpos <= 0;
        ypos <= 0;  
        //state <= DOWN;  
    end
    else begin
        xpos <= xpos_nxt;
        ypos <= ypos_nxt;
        //state <= state_nxt;
    end
end

/*
If clock 100 Hz is applied to the module, then t is incremented each 10 ms.
v = 1 pixels/10ms -> obstables moving 100 pixels in 1 sec
*/

always @* begin

    xpos_nxt = XPOS_INIT;
    ypos_nxt = ypos + 1;
    
    if ( ypos == 350 ) begin
        ypos_nxt = 1;
    end
    else begin
        ypos_nxt = ypos + 1;
    end
end
endmodule 

/*always @* begin

    xpos_nxt = XPOS_INIT;
    
    case (state)
    
    DOWN: begin
    
        ypos_nxt = ypos + 1;
        
        if ( ypos >= 300) begin
            GO_UP = 1'b1;
            state_nxt = CHANGE_DIRECTION;
        end
        else begin
            GO_UP = 1'b0;
            state_nxt = DOWN;
        end
        
    end
    
    UP: begin
        
        ypos_nxt = ypos - 1;
        
        if ( ypos <= 1) begin
            state_nxt = CHANGE_DIRECTION;
            GO_UP = 1'b0;
        end
        else begin
            GO_UP = 1'b1;
            state_nxt = UP;
        end
    end
    
    CHANGE_DIRECTION: begin
    
        ypos_nxt = ypos;
        state_nxt = GO_UP ? UP : DOWN;
        GO_UP = 1'b0;       
             
    end
    
    default: begin
        ypos_nxt = ypos;
        GO_UP = 1'b0;
        state_nxt = GO_UP ? UP : DOWN;
    end
    
endcase
end*/

