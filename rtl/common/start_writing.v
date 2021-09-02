`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2021 21:20:27
// Design Name: 
// Module Name: start_writing
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


module start_writing(
        input  wire        clk,
        input  wire        rst,
        input  wire[7:0]   char_xy,
        output reg[6:0]    char_code
    );
       reg [6:0] char_code_nxt;
  always @(posedge clk)begin
             if (rst)
                 char_code<=0;
             else
                 char_code <= char_code_nxt;
         end   
 always @* begin 
 case (char_xy)    
     8'h0: char_code_nxt = 7'h53; //S
     8'h1: char_code_nxt = 7'h54; //T
     8'h2: char_code_nxt = 7'h41; //A
     8'h3: char_code_nxt = 7'h52; //R
     8'h4: char_code_nxt = 7'h54; //T
     8'h5: char_code_nxt = 7'h20; //
     8'h6: char_code_nxt = 7'h47; //G
     8'h7: char_code_nxt = 7'h41; //A
     8'h8: char_code_nxt = 7'h4D; //M
     8'h9: char_code_nxt = 7'h45; //E
     8'hA: char_code_nxt = 7'h2E; //.
     default: char_code_nxt = 7'h00; //
     endcase
 end
endmodule
