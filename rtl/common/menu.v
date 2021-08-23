`timescale 1ns / 1ps

`include "_vga_macros.vh"

module menu(
   input wire rst,
   input wire pclk,
   input wire [11:0] hcount_in,
   input wire hsync_in,
   input wire hblnk_in,
   input wire [11:0] vcount_in,
   input wire vsync_in,
   input wire vblnk_in,
   input wire [5:0] rgb_pixel,
   output reg [19:0] pixel_addr,
   output wire [`VGA_BUS_SIZE-1:0] vga_out
   );
   
   `VGA_OUT_REG
   `VGA_MERGE_OUTPUT(vga_out) 
   
   localparam xpos = 0 ,
                ypos = 0,
                    HEIGHT = 246  ,
                        WIDTH = 426; 
    
    always @(posedge pclk) begin
       if (rst) begin
       hcount_out <= 0;
       hs_out <= 0;
       hblnk_out <= 0;
       vcount_out <= 0;
       vs_out <= 0;
       vblnk_out <= 0;
       end
       else begin
       hcount_out <= hcount_in;
       hs_out <= hsync_in;
       hblnk_out <= hblnk_in;
       vcount_out <= vcount_in;
       vs_out <= vsync_in;
       vblnk_out <= vblnk_in;
       end
   end
   
   reg [11:0] rgb_out_nxt;
   
   always @(posedge pclk) begin
       if(rst) rgb_out <= 0;
       else rgb_out <= rgb_out_nxt;
   end
    
   always @* begin
       if(hblnk_in | vblnk_in) rgb_out_nxt = 12'h0_0_0;
       else begin
        if (rgb_pixel != 0 )
            rgb_out_nxt = {rgb_pixel[5:4],rgb_pixel[5:4],rgb_pixel[3:2],rgb_pixel[3:2],rgb_pixel[1:0],rgb_pixel[1:0]};
        else
            rgb_out_nxt = 12'h0_0_0;
    end
   end
   

   
   reg [19:0] pixel_addr_nxt;
   always @* begin
       if( (ypos <= vcount_in) && (xpos <= hcount_in) && (ypos + HEIGHT > vcount_in) && (xpos + WIDTH > hcount_in) )
       begin
          if(ypos == vcount_in && xpos == hcount_in) pixel_addr_nxt = 20'b0;
          else if(pixel_addr< (26199*4 )-1 ) 
          begin 
          pixel_addr_nxt = pixel_addr + 1;
          end
          else pixel_addr_nxt = 20'b0;
       end
       else pixel_addr_nxt = pixel_addr;
   end
   
   
   always @(posedge pclk) begin
       if(rst) pixel_addr <= 20'b0;
       else  pixel_addr <= pixel_addr_nxt;
   end
endmodule
