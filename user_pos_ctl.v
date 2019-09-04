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
    
    output reg [11:0] xpos,
    output reg [11:0] ypos
);

localparam OBSTACLE_SIDE = 100;

reg [11:0] xpos_nxt, ypos_nxt;

always @(posedge clk) begin
    if (rst) begin
        xpos <= 12'b0;
        ypos <= 12'b0;
    end
    else begin
        xpos <= xpos_nxt;
        ypos <= ypos_nxt;
    end
end  

always @* begin

    if (keys[3]) begin //UP
        if ( xpos >= 0 && xpos <= 699 && ypos >= 0 && ypos <= 499 ) begin
            if ( (xpos >= 1 && xpos < 200 && ypos >= 0 && ypos <= 100) || ( xpos >= 101 && xpos < 300 && 
            ypos >= 100 && ypos <= 200) || (xpos >= 201 && xpos < 400 && ypos >= 200 && ypos <= 300) ) begin
                xpos_nxt = xpos;
                ypos_nxt = ypos;
            end
            else begin
                xpos_nxt = xpos;
                ypos_nxt = ypos - 1;
            end
            end
        //monitor borders
        else if (xpos < 0) begin
            xpos_nxt = 0;
            ypos_nxt = ypos;
        end
        else if (xpos > 699) begin
            xpos_nxt = 699;
            ypos_nxt = ypos;
        end     
        else if (ypos < 0) begin
            xpos_nxt = xpos;
            ypos_nxt = 0;
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
        if ( xpos >= 0 && xpos <= 699 && ypos >= 0 && ypos <= 499 ) begin
            if ( (xpos >= 101 && xpos < 300 && ypos > 0 && ypos < 200) || (xpos >= 201 && xpos < 400 && ypos >= 100 && ypos < 200) ) begin
                xpos_nxt = xpos;
                ypos_nxt = ypos;
            end
            else begin
                xpos_nxt = xpos;
                ypos_nxt = ypos + 1;
            end
            end
        //monitor borders    
        else if (xpos < 0) begin
            xpos_nxt = 0;
            ypos_nxt = ypos;
        end
        else if (xpos > 699) begin
            xpos_nxt = 699;
            ypos_nxt = ypos;
        end     
        else if (ypos < 0) begin
            xpos_nxt = xpos;
            ypos_nxt = 0;
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
        if ( xpos >= 0 && xpos <= 699 && ypos >= 0 && ypos <= 499 ) begin
            if ( (xpos >= 0 && xpos <= 100 && ypos >= 0 && ypos < 100) || (xpos >= 100 && xpos < 200 && ypos >= 1 && ypos < 200) ||
            (xpos >= 200 && xpos < 300 && ypos >= 101 && ypos < 300) ) begin
                 xpos_nxt = xpos;
                 ypos_nxt = ypos;
             end
             else begin
                 xpos_nxt = xpos + 1;
                 ypos_nxt = ypos;
             end
             end
        //monitor borders
        else if (xpos < 0) begin
            xpos_nxt = 0;
            ypos_nxt = ypos;
        end
        else if (xpos > 699) begin
            xpos_nxt = 699;
            ypos_nxt = ypos;
        end       
        else if (ypos < 0) begin
            xpos_nxt = xpos;
            ypos_nxt = 0;
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
        if ( xpos >= 0 && xpos <= 699 && ypos >= 0 && ypos <= 499 ) begin
            if ( (xpos >= 100 && xpos <= 200 && ypos >= 0 && ypos < 100) || (xpos >= 200 && xpos <= 300 && ypos >= 1 && ypos < 200) ||
            (xpos >= 300 && xpos <= 400 && ypos >= 101 && ypos < 300) ) begin
                 xpos_nxt = xpos;
                 ypos_nxt = ypos;
             end
             else begin
                 xpos_nxt = xpos - 1;
                 ypos_nxt = ypos;
                end
                end
        //monitor borders        
        else if (xpos < 0) begin
            xpos_nxt = 0;
            ypos_nxt = ypos;
        end
        else if (xpos > 699) begin
            xpos_nxt = 699;
            ypos_nxt = ypos;
        end       
        else if (ypos < 0) begin
            xpos_nxt = xpos;
            ypos_nxt = 0;
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
        xpos_nxt = xpos;
        ypos_nxt = ypos;
    end
end

endmodule
