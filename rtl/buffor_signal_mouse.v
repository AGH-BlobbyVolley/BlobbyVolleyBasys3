`timescale 1ns / 1ps
/*--------------------------------------*/
/*      AUTHOR - Szymon Irla         */             
/*--------------------------------------*/
module buffor_signal_mouse(
        input wire pclk,
        input wire rst,
        input wire my_left,
        input wire [11:0] my_xpos,
        input wire [11:0] my_ypos,
        output reg my_left_buf,
        output reg [11:0]my_xpos_buf,
        output reg [11:0]my_ypos_buf
    );

always @(posedge pclk) begin
           if(rst) begin
                   my_xpos_buf <= 0;
                   my_ypos_buf <= 0;
                   my_left_buf <= 0;
               end
           else begin
                   my_xpos_buf <= my_xpos;
                   my_ypos_buf <= my_ypos;
                   my_left_buf <= my_left;
          end
    end
endmodule
