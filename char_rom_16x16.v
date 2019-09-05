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


module char_rom_16x16
(
    input wire [7:0] char_yx,       //{char_y,char_x} - x(column), y(line)
    output wire [6:0] char_code
);
    
reg [6:0] char_code_nxt;    

assign char_code = char_code_nxt;  
    
always @* begin
    case(char_yx)
        8'h0: char_code_nxt = 7'h43;		//C
        8'h1: char_code_nxt = 7'h6f;		//o
        8'h2: char_code_nxt = 7'h6e;		//n
        8'h3: char_code_nxt = 7'h67;		//g
        8'h4: char_code_nxt = 7'h72;		//r
        8'h5: char_code_nxt = 7'h61;		//a
        8'h6: char_code_nxt = 7'h74;		//t
        8'h7: char_code_nxt = 7'h75;		//u
        8'h8: char_code_nxt = 7'h6c;
        8'h9: char_code_nxt = 7'h61;
        8'hA: char_code_nxt = 7'h74;		//t
        8'hB: char_code_nxt = 7'h69;		//i
        8'hC: char_code_nxt = 7'h6f;
        8'hD: char_code_nxt = 7'h6e;
        8'hE: char_code_nxt = 7'h73;		//s
        8'hF: char_code_nxt = 7'h20;
        8'h10: char_code_nxt = 7'h20;
        8'h11: char_code_nxt = 7'h20;
        8'h12: char_code_nxt = 7'h2D;		//-
        8'h13: char_code_nxt = 7'h20;
        8'h14: char_code_nxt = 7'h20;
        8'h15: char_code_nxt = 7'h20;
        8'h16: char_code_nxt = 7'h79;		//y
        8'h17: char_code_nxt = 7'h6F;
        8'h18: char_code_nxt = 7'h75;
        8'h19: char_code_nxt = 7'h20;
        8'h1A: char_code_nxt = 7'h20;
        8'h1B: char_code_nxt = 7'h77;		//w
        8'h1C: char_code_nxt = 7'h6f;
        8'h1D: char_code_nxt = 7'h6e;
        8'h1E: char_code_nxt = 7'h13;		//!!
        8'h1F: char_code_nxt = 7'h20;
        8'h20: char_code_nxt = 7'h01;		// : )
        default : char_code_nxt = 7'h00;
    endcase
end    
    
endmodule