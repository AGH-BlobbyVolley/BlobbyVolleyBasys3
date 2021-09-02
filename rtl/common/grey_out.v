/*--------------------------------------*/
/*      AUTHOR - Stanislaw Klat         */
/*--------------------------------------*/

`timescale 1ns / 1ps

`include "_vga_macros.vh"

module grey_out (
    input wire rst,
    input wire pclk,
    input wire [7:0] char_pixel,
    input wire endgame,
    input wire [`VGA_BUS_SIZE-1:0] vga_in,
    output reg [3:0] char_line,
    output reg [7:0] char_xy,
    output wire [`VGA_BUS_SIZE-1:0] vga_out
  );

  `VGA_SPLIT_INPUT(vga_in)
  `VGA_OUT_REG
  `VGA_MERGE_OUTPUT(vga_out)
    
  wire [11:0] hcount_buf;
  wire hsync_buf;
  wire hblnk_buf;
  wire [11:0] vcount_buf;
  reg [11:0] vcount_rect , hcount_rect;
  wire vsync_buf;
  wire vblnk_buf;
  wire [11:0] rgb_buf;
  reg [11:0] rgb_out_nxt;
  reg [7:0] char_xy_nxt;
  reg [3:0] char_line_nxt;
  delay #(.WIDTH(40), .CLK_DEL(2))
  my_delay
  (
      .din( { hcount_in, hs_in, hblnk_in, vcount_in, vs_in, vblnk_in, rgb_in } ),
      .dout({hcount_buf,hsync_buf,hblnk_buf,vcount_buf,vsync_buf,vblnk_buf, rgb_buf}),
      .rst(rst),
      .clk(pclk)
  );

  
  localparam 	WIDTH = 390,
                POSY = 330,
                POSX = 340,
                COLOR = 12'hf_f_3, 
                HEIGHT = 50;

  always @(posedge pclk)
  begin
    if (rst)
    begin
      hcount_out <= 0;
      hs_out <= 0;
      hblnk_out <= 0;
      vcount_out <= 0;
      vs_out <= 0;
      vblnk_out <= 0;
      rgb_out <= 0;
      char_line  <= 0; 
      char_xy    <= 0;
    end
    else
    begin
      hcount_out <= hcount_buf;
      hs_out <= hsync_buf;
      hblnk_out <= hblnk_buf;
      vcount_out <= vcount_buf;
      vs_out <= vsync_buf;
      vblnk_out <= vblnk_buf;
      rgb_out <= rgb_out_nxt;
      char_xy  <= char_xy_nxt;      
      char_line <= char_line_nxt;
    end
  end



  wire [11:0] red, green, blue; 

  assign red = {rgb_in[11:8], 2'b0}*6'b0000_01;
  assign green = {rgb_in[7:4], 2'b0}*6'b0000_01;
  assign blue = {rgb_in[3:0], 2'b0}*6'b0000_01;

  always @*
  begin
  
    vcount_rect = vcount_in -  POSY;
    hcount_rect = hcount_in -  POSX;
    if (endgame)
        char_xy_nxt = {hcount_rect[8:5],4'b0000};
    else
        char_xy_nxt = {4'b0000,hcount_rect[8:5]};
    
    char_line_nxt = vcount_rect[5:2];
    if ((hcount_in >= POSX && hcount_in <=POSX+WIDTH)&&(vcount_in >= POSY && vcount_in <=POSY+HEIGHT))begin                            
          if (char_pixel[8-hcount_rect[4:2]%8])
              rgb_out_nxt = COLOR;
          else
              rgb_out_nxt = {red[7:4],green[7:4],blue[7:4]}; 
    end else
          rgb_out_nxt = {red[7:4],green[7:4],blue[7:4]};
    
  
    
      
  end
endmodule
