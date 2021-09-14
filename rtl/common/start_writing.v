/*--------------------------------------*/
/*      AUTHOR - Szymon Irla            */
/*--------------------------------------*/

`timescale 1ns / 1ps

module start_writing(
        input  wire        clk,
        input  wire        rst,
        input  wire[7:0]   char_xy,
        input  wire        flag_point,
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
     8'h1: char_code_nxt = 7'h53; //S
     8'h2: char_code_nxt = 7'h54; //T
     8'h3: char_code_nxt = 7'h41; //A
     8'h4: char_code_nxt = 7'h52; //R
     8'h5: char_code_nxt = 7'h54; //T
     8'h6: char_code_nxt = 7'h20; //
     8'h7: char_code_nxt = 7'h47; //G
     8'h8: char_code_nxt = 7'h41; //A
     8'h9: char_code_nxt = 7'h4D; //M
     8'hA: char_code_nxt = 7'h45; //E
     8'hB: char_code_nxt = 7'h2E; //.
     
     8'h10: char_code_nxt = 7'h57; //W
     8'h20: char_code_nxt = 7'h49; //I
     8'h30: char_code_nxt = 7'h4E; //N
     8'h40: char_code_nxt = 7'h20; //
     8'h50: char_code_nxt = 7'h50; //P
     8'h60: char_code_nxt = 7'h4C; //L
     8'h70: char_code_nxt = 7'h41; //A
     8'h80: char_code_nxt = 7'h59; //Y
     8'h90: char_code_nxt = 7'h45; //E
     8'hA0: char_code_nxt = 7'h52; //R
     8'hB0: char_code_nxt = (flag_point) ? 7'h32 : 7'h31; //2 || 1
     default: char_code_nxt = 7'h00; //
     endcase
 end
endmodule
