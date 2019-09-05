`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2019 23:21:25
// Design Name: 
// Module Name: user_pos_ctl
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


module user_pos_ctl(
    input wire clk,
    input wire rst,
    input wire [3:0] keys,       // {keyU,keyD,keyR,keyL}
    //input wire [17:0] st_obst_xy,       // st_obst_xy = {STAT_OBST_1_X,STAT_OBST_1_Y,STAT_OBST_2_X,STAT_OBST_2_Y,STAT_OBST_3_X,STAT_OBST_3_Y};
    input wire [11:0] dynamic_o_xpos,
    input wire [11:0] dynamic_o_ypos,
    
    output reg [11:0] xpos,
    output reg [11:0] ypos,
    output reg mouse_en
);

localparam OBSTACLE_SIDE = 100;
localparam WIDTH = 100;    //vertical range
localparam HEIGHT = 100;

reg [11:0] xpos_nxt, ypos_nxt;

always @(posedge clk) begin
    if (rst) begin
        xpos <= 1;
        ypos <= 1;
    end
    else begin
        xpos <= xpos_nxt;
        ypos <= ypos_nxt;
    end
end  

always @* begin

    if ( (xpos >= dynamic_o_xpos - 100 && xpos <= dynamic_o_xpos + 50) && (ypos >= dynamic_o_ypos - 100 && ypos <= dynamic_o_ypos + 250) ) begin
        xpos_nxt = 1;
        ypos_nxt = 1;
        mouse_en = 1'b0;
    end
    
    else if ( (xpos + WIDTH) > 750 && (ypos+HEIGHT) < 400 && ypos > 200 ) begin
        xpos_nxt = xpos;
        ypos_nxt = ypos;
        mouse_en = 1'b1;
    end

    else if (keys[3]) begin //UP
        mouse_en = 1'b0;
        if ( xpos >= 1 && xpos <= 699 && ypos >= 1 && ypos <= 499 ) begin
            if ( (xpos >= 1 && xpos < 200 && ypos >= 1 && ypos <= 100) || ( xpos >= 101 && xpos < 300 && 
            ypos >= 100 && ypos <= 200) || (xpos >= 201 && xpos < 400 && ypos >= 200 && ypos <= 300) ) begin
                xpos_nxt = xpos;
                ypos_nxt = ypos;
            end
            else if ( (xpos >= dynamic_o_xpos - 100 && xpos <= dynamic_o_xpos + 50) && (ypos >= dynamic_o_ypos - 100 && ypos <= dynamic_o_ypos + 250) ) begin
                xpos_nxt = 1;
                ypos_nxt = 1;
            end
            else begin
                xpos_nxt = xpos;
                ypos_nxt = ypos - 1;
            end
            end
        //monitor borders
        else if (xpos < 1) begin
            xpos_nxt = 1;
            ypos_nxt = ypos;
        end
        else if (xpos > 699) begin
            xpos_nxt = 699;
            ypos_nxt = ypos;
        end     
        else if (ypos < 1 ) begin
            xpos_nxt = xpos;
            ypos_nxt = 1;
        end        
        else if (ypos > 499) begin
              xpos_nxt = xpos;
              ypos_nxt = 499;
        end      
        else begin
            xpos_nxt = xpos;
            ypos_nxt = ypos;
        end       
    end
  
    else if (keys[2]) begin //DOWN
        mouse_en = 1'b0;
        if ( xpos >= 1 && xpos <= 699 && ypos >= 1 && ypos <= 499 ) begin
            if ( (xpos >= 101 && xpos < 300 && ypos >= 1 && ypos < 200) || (xpos >= 201 && xpos < 400 && ypos >= 100 && ypos < 200) ) begin
                xpos_nxt = xpos;
                ypos_nxt = ypos;
            end
            else if ( (xpos >= dynamic_o_xpos - 100 && xpos <= dynamic_o_xpos + 50) && (ypos >= dynamic_o_ypos - 100 && ypos <= dynamic_o_ypos + 250) ) begin
                xpos_nxt = 1;
                ypos_nxt = 1;
            end
            else begin
                xpos_nxt = xpos;
                ypos_nxt = ypos + 1;
            end
            end
        //monitor borders    
        else if (xpos < 1) begin
            xpos_nxt = 1;
            ypos_nxt = ypos;
        end
        else if (xpos > 699) begin
            xpos_nxt = 699;
            ypos_nxt = ypos;
        end     
        else if (ypos < 1) begin
            xpos_nxt = xpos;
            ypos_nxt = 1;
        end        
        else if (ypos > 499) begin
              xpos_nxt = xpos;
              ypos_nxt = 499;
        end
        else begin
            xpos_nxt = xpos;
            ypos_nxt = ypos;
        end
    end
   
    else if (keys[1]) begin //RIGHT
        mouse_en = 1'b0;
        if ( xpos >= 1 && xpos <= 699 && ypos >= 1 && ypos <= 499 ) begin
            if ( (xpos >= 1 && xpos <= 100 && ypos >= 1 && ypos < 100) || (xpos >= 100 && xpos < 200 && ypos >= 1 && ypos < 200) ||
            (xpos >= 200 && xpos < 300 && ypos >= 101 && ypos < 300) ) begin
                 xpos_nxt = xpos;
                 ypos_nxt = ypos;
             end
             else if ( (xpos >= dynamic_o_xpos - 100 && xpos <= dynamic_o_xpos + 50) && (ypos >= dynamic_o_ypos - 100 && ypos <= dynamic_o_ypos + 250) ) begin
                 xpos_nxt = 1;
                 ypos_nxt = 1;
             end
             else begin
                 xpos_nxt = xpos + 1;
                 ypos_nxt = ypos;
             end
             end
        //monitor borders
        else if (xpos < 1) begin
            xpos_nxt = 1;
            ypos_nxt = ypos;
        end
        else if (xpos > 699) begin
            xpos_nxt = 699;
            ypos_nxt = ypos;
        end       
        else if (ypos < 1) begin
            xpos_nxt = xpos;
            ypos_nxt = 1;
        end        
        else if (ypos > 499) begin
              xpos_nxt = xpos;
              ypos_nxt = 499;
        end
        else begin
            xpos_nxt = xpos;
            ypos_nxt = ypos;
        end
    end    
    
    else if (keys[0]) begin //LEFT
    mouse_en = 1'b0;
        if ( xpos >= 1 && xpos <= 699 && ypos >= 1 && ypos <= 499 ) begin
            if ( (xpos >= 100 && xpos <= 200 && ypos >= 1 && ypos < 100) || (xpos >= 200 && xpos <= 300 && ypos >= 1 && ypos < 200) ||
            (xpos >= 300 && xpos <= 400 && ypos >= 101 && ypos < 300) ) begin
                 xpos_nxt = xpos;
                 ypos_nxt = ypos;
             end
             else if ( xpos <= dynamic_o_xpos + 50 && (ypos >= dynamic_o_ypos - 100 && ypos <= dynamic_o_ypos + 250) ) begin
                 xpos_nxt = 1;
                 ypos_nxt = 1;
             end
             else begin
                 xpos_nxt = xpos - 1;
                 ypos_nxt = ypos;
                end
                end
        //monitor borders        
        else if (xpos < 1) begin
            xpos_nxt = 1;
            ypos_nxt = ypos;
        end
        else if (xpos > 699) begin
            xpos_nxt = 699;
            ypos_nxt = ypos;
        end       
        else if (ypos < 1) begin
            xpos_nxt = xpos;
            ypos_nxt = 1;
        end        
        else if (ypos > 499) begin
              xpos_nxt = xpos;
              ypos_nxt = 499;
        end
        else begin
            xpos_nxt = xpos;
            ypos_nxt = ypos;
        end
    end
    
    else begin
        mouse_en = 1'b0;
        xpos_nxt = xpos;
        ypos_nxt = ypos;
    end
end

endmodule
