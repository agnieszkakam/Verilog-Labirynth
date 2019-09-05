`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2019 13:03:33
// Design Name: 
// Module Name: char_rom_16x16
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

//instance for goodbye screen
module char_rom_16x16
(
    input wire game_stage,          //1 - welcome screen, 0 - goodbye screen
    input wire [7:0] char_yx,       //{char_y,char_x} - x(column), y(line)
    output reg [6:0] char_code
);
    
    reg [10:0] address;
    reg [2047:0] text = game_stage ? "Welcoming message, some instructions, blablabla" : "Congratulations! You won!";
    
    
always @* begin
    address = 1+(char_yx<<3);
    char_code = text [address+:7];
end    
    
endmodule