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
    input wire gamestage,
    input wire [7:0] char_yx,       //{char_y,char_x} - x(column), y(line)
    output wire [6:0] char_code
);
    
   localparam INSTRUCTIONS = 1'b0;
   localparam CONGRATULATIONS = 1'b1; 
    
reg [6:0] char_code_nxt;    

assign char_code = char_code_nxt;  
    
always @* begin
    if (gamestage == CONGRATULATIONS)
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
    
    else // gamestage == INSTRUCTIONS
        case(char_yx)
             8'h0: char_code_nxt = 7'h57;
             8'h1: char_code_nxt = 7'h65;
             8'h2: char_code_nxt = 7'h6C;
             8'h3: char_code_nxt = 7'h63;
             8'h4: char_code_nxt = 7'h6F;
             8'h5: char_code_nxt = 7'h6D;
             8'h6: char_code_nxt = 7'h65;
             8'h7: char_code_nxt = 7'h20;
             8'h8: char_code_nxt = 7'h74;
             8'h9: char_code_nxt = 7'h6F;
             8'hA: char_code_nxt = 7'h20;
             8'hB: char_code_nxt = 7'h74;
             8'hC: char_code_nxt = 7'h68;
             8'hD: char_code_nxt = 7'h65;
             8'hE: char_code_nxt = 7'h20;
             8'hF: char_code_nxt = 7'h20;
             8'h10: char_code_nxt = 7'h4C;
             8'h11: char_code_nxt = 7'h61;
             8'h12: char_code_nxt = 7'h62;
             8'h13: char_code_nxt = 7'h79;
             8'h14: char_code_nxt = 7'h72;
             8'h15: char_code_nxt = 7'h69;
             8'h16: char_code_nxt = 7'h6E;
             8'h17: char_code_nxt = 7'h74;
             8'h18: char_code_nxt = 7'h68;
             8'h19: char_code_nxt = 7'h21;
             8'h1A: char_code_nxt = 7'h20;
             8'h1B: char_code_nxt = 7'h54;
             8'h1C: char_code_nxt = 7'h72;
             8'h1D: char_code_nxt = 7'h79;
             8'h1E: char_code_nxt = 7'h20;
             8'h1F: char_code_nxt = 7'h20;
             8'h20: char_code_nxt = 7'h74;
             8'h21: char_code_nxt = 7'h6F;
             8'h22: char_code_nxt = 7'h20;
             8'h23: char_code_nxt = 7'h67;
             8'h24: char_code_nxt = 7'h65;
             8'h25: char_code_nxt = 7'h74;
             8'h26: char_code_nxt = 7'h20;
             8'h27: char_code_nxt = 7'h74;
             8'h28: char_code_nxt = 7'h68;
             8'h29: char_code_nxt = 7'h65;
             8'h2A: char_code_nxt = 7'h20;
             8'h2B: char_code_nxt = 7'h74;
             8'h2C: char_code_nxt = 7'h68;
             8'h2D: char_code_nxt = 7'h65;
             8'h2E: char_code_nxt = 7'h20;
             8'h2F: char_code_nxt = 7'h20;
             8'h30: char_code_nxt = 7'h64;
             8'h31: char_code_nxt = 7'h6F;
             8'h32: char_code_nxt = 7'h6F;
             8'h33: char_code_nxt = 7'h72;
             8'h34: char_code_nxt = 7'h2C;
             8'h35: char_code_nxt = 7'h20;
             8'h36: char_code_nxt = 7'h62;
             8'h37: char_code_nxt = 7'h75;
             8'h38: char_code_nxt = 7'h74;
             8'h39: char_code_nxt = 7'h20;
             8'h3A: char_code_nxt = 7'h61;
             8'h3B: char_code_nxt = 7'h76;
             8'h3C: char_code_nxt = 7'h6F;
             8'h3D: char_code_nxt = 7'h69;
             8'h3E: char_code_nxt = 7'h64;
             8'h3F: char_code_nxt = 7'h20;
             8'h40: char_code_nxt = 7'h63;
             8'h41: char_code_nxt = 7'h6F;
             8'h42: char_code_nxt = 7'h6C;
             8'h43: char_code_nxt = 7'h6C;
             8'h44: char_code_nxt = 7'h69;
             8'h45: char_code_nxt = 7'h73;
             8'h46: char_code_nxt = 7'h69;
             8'h47: char_code_nxt = 7'h6F;
             8'h48: char_code_nxt = 7'h6E;
             8'h49: char_code_nxt = 7'h73;
             8'h4A: char_code_nxt = 7'h20;
             8'h4B: char_code_nxt = 7'h77;
             8'h4C: char_code_nxt = 7'h69;
             8'h4D: char_code_nxt = 7'h74;
             8'h4E: char_code_nxt = 7'h68;
             8'h4F: char_code_nxt = 7'h20;
             8'h50: char_code_nxt = 7'h74;
             8'h51: char_code_nxt = 7'h68;
             8'h52: char_code_nxt = 7'h65;
             8'h53: char_code_nxt = 7'h20;
             8'h54: char_code_nxt = 7'h64;
             8'h55: char_code_nxt = 7'h79;
             8'h56: char_code_nxt = 7'h6E;
             8'h57: char_code_nxt = 7'h61;
             8'h58: char_code_nxt = 7'h6D;
             8'h59: char_code_nxt = 7'h69;
             8'h5A: char_code_nxt = 7'h63;
             8'h5B: char_code_nxt = 7'h20;
             8'h5C: char_code_nxt = 7'h6F;
             8'h5D: char_code_nxt = 7'h62;
             8'h5E: char_code_nxt = 7'h73;
             8'h5F: char_code_nxt = 7'h74;
             8'h60: char_code_nxt = 7'h61;
             8'h61: char_code_nxt = 7'h63;
             8'h62: char_code_nxt = 7'h6C;
             8'h63: char_code_nxt = 7'h65;
             8'h64: char_code_nxt = 7'h73;
             8'h65: char_code_nxt = 7'h2E;
             8'h66: char_code_nxt = 7'h20;
             8'h67: char_code_nxt = 7'h54;
             8'h68: char_code_nxt = 7'h68;
             8'h69: char_code_nxt = 7'h65;
             8'h6A: char_code_nxt = 7'h20;
             8'h6B: char_code_nxt = 7'h75;
             8'h6C: char_code_nxt = 7'h73;
             8'h6D: char_code_nxt = 7'h65;
             8'h6E: char_code_nxt = 7'h72;
             8'h6F: char_code_nxt = 7'h20;
             8'h70: char_code_nxt = 7'h69;
             8'h71: char_code_nxt = 7'h73;
             8'h72: char_code_nxt = 7'h20;
             8'h73: char_code_nxt = 7'h63;
             8'h74: char_code_nxt = 7'h6F;
             8'h75: char_code_nxt = 7'h6E;
             8'h76: char_code_nxt = 7'h74;
             8'h77: char_code_nxt = 7'h72;
             8'h78: char_code_nxt = 7'h6F;
             8'h79: char_code_nxt = 7'h6C;
             8'h7A: char_code_nxt = 7'h6C;
             8'h7B: char_code_nxt = 7'h65;
             8'h7C: char_code_nxt = 7'h64;
             8'h7D: char_code_nxt = 7'h20;
             8'h7E: char_code_nxt = 7'h62;
             8'h7F: char_code_nxt = 7'h79;
             8'h80: char_code_nxt = 7'h20;
             8'h81: char_code_nxt = 7'h74;
             8'h82: char_code_nxt = 7'h68;
             8'h83: char_code_nxt = 7'h65;
             8'h84: char_code_nxt = 7'h20;
             8'h85: char_code_nxt = 7'h61;
             8'h86: char_code_nxt = 7'h72;
             8'h87: char_code_nxt = 7'h72;
             8'h88: char_code_nxt = 7'h6F;
             8'h89: char_code_nxt = 7'h77;
             8'h8A: char_code_nxt = 7'h20;
             8'h8B: char_code_nxt = 7'h6B;
             8'h8C: char_code_nxt = 7'h65;
             8'h8D: char_code_nxt = 7'h79;
             8'h8E: char_code_nxt = 7'h73;
             8'h8F: char_code_nxt = 7'h2E;
             8'h90: char_code_nxt = 7'h20;
             8'h91: char_code_nxt = 7'h47;
             8'h92: char_code_nxt = 7'h6F;
             8'h93: char_code_nxt = 7'h6F;
             8'h94: char_code_nxt = 7'h64;
             8'h95: char_code_nxt = 7'h20;
             8'h96: char_code_nxt = 7'h6C;
             8'h97: char_code_nxt = 7'h75;
             8'h98: char_code_nxt = 7'h63;
             8'h99: char_code_nxt = 7'h6B;
             8'h9A: char_code_nxt = 7'h21;
             8'h9B: char_code_nxt = 7'h20;
             8'h9C: char_code_nxt = 7'h49;
             8'h9D: char_code_nxt = 7'h66;
             8'h9E: char_code_nxt = 7'h20;
             8'h9F: char_code_nxt = 7'h20;
             8'hA0: char_code_nxt = 7'h79;
             8'hA1: char_code_nxt = 7'h6F;
             8'hA2: char_code_nxt = 7'h75;
             8'hA3: char_code_nxt = 7'h20;
             8'hA4: char_code_nxt = 7'h73;
             8'hA5: char_code_nxt = 7'h75;
             8'hA6: char_code_nxt = 7'h63;
             8'hA7: char_code_nxt = 7'h63;
             8'hA8: char_code_nxt = 7'h65;
             8'hA9: char_code_nxt = 7'h65;
             8'hAA: char_code_nxt = 7'h64;
             8'hAB: char_code_nxt = 7'h2C;
             8'hAC: char_code_nxt = 7'h20;
             8'hAD: char_code_nxt = 7'h79;
             8'hAE: char_code_nxt = 7'h6F;
             8'hAF: char_code_nxt = 7'h75;
             8'hB0: char_code_nxt = 7'h20;
             8'hB1: char_code_nxt = 7'h63;
             8'hB2: char_code_nxt = 7'h61;
             8'hB3: char_code_nxt = 7'h6E;
             8'hB4: char_code_nxt = 7'h20;
             8'hB5: char_code_nxt = 7'h72;
             8'hB6: char_code_nxt = 7'h65;
             8'hB7: char_code_nxt = 7'h73;
             8'hB8: char_code_nxt = 7'h74;
             8'hB9: char_code_nxt = 7'h61;
             8'hBA: char_code_nxt = 7'h72;
             8'hBB: char_code_nxt = 7'h74;
             8'hBC: char_code_nxt = 7'h20;
             8'hBD: char_code_nxt = 7'h74;
             8'hBE: char_code_nxt = 7'h68;
             8'hBF: char_code_nxt = 7'h65;
             8'hC0: char_code_nxt = 7'h67;
             8'hC1: char_code_nxt = 7'h61;
             8'hC2: char_code_nxt = 7'h6D;
             8'hC3: char_code_nxt = 7'h65;
             8'hC4: char_code_nxt = 7'h20;
             8'hC5: char_code_nxt = 7'h62;
             8'hC6: char_code_nxt = 7'h79;
             8'hC7: char_code_nxt = 7'h20;
             8'hC8: char_code_nxt = 7'h70;
             8'hC9: char_code_nxt = 7'h72;
             8'hCA: char_code_nxt = 7'h65;
             8'hCB: char_code_nxt = 7'h73;
             8'hCC: char_code_nxt = 7'h73;
             8'hCD: char_code_nxt = 7'h69;
             8'hCE: char_code_nxt = 7'h6E;
             8'hCF: char_code_nxt = 7'h67;
             8'hD0: char_code_nxt = 7'h74;
             8'hD1: char_code_nxt = 7'h68;
             8'hD2: char_code_nxt = 7'h65;
             8'hD3: char_code_nxt = 7'h20;
             8'hD4: char_code_nxt = 7'h6D;
             8'hD5: char_code_nxt = 7'h69;
             8'hD6: char_code_nxt = 7'h64;
             8'hD7: char_code_nxt = 7'h64;
             8'hD8: char_code_nxt = 7'h6C;
             8'hD9: char_code_nxt = 7'h65;
             8'hDA: char_code_nxt = 7'h20;
             8'hDB: char_code_nxt = 7'h20;
             8'hDC: char_code_nxt = 7'h20;
             8'hDD: char_code_nxt = 7'h20;
             8'hDE: char_code_nxt = 7'h20;
             8'hDF: char_code_nxt = 7'h20;
             8'hE0: char_code_nxt = 7'h62;
             8'hE1: char_code_nxt = 7'h75;
             8'hE2: char_code_nxt = 7'h74;
             8'hE3: char_code_nxt = 7'h74;
             8'hE4: char_code_nxt = 7'h6F;
             8'hE5: char_code_nxt = 7'h6E;
             8'hE6: char_code_nxt = 7'h20;
             8'hE7: char_code_nxt = 7'h6F;
             8'hE8: char_code_nxt = 7'h6E;
             8'hE9: char_code_nxt = 7'h20;
             8'hEA: char_code_nxt = 7'h46;
             8'hEB: char_code_nxt = 7'h50;
             8'hEC: char_code_nxt = 7'h47;
             8'hED: char_code_nxt = 7'h41;
             8'hEE: char_code_nxt = 7'h20;
             8'hEF: char_code_nxt = 7'h20;
             8'hF0: char_code_nxt = 7'h62;
             8'hF1: char_code_nxt = 7'h6F;
             8'hF2: char_code_nxt = 7'h61;
             8'hF3: char_code_nxt = 7'h72;
             8'hF4: char_code_nxt = 7'h64;
             8'hF5: char_code_nxt = 7'h2E;
       endcase 
end    
    
endmodule