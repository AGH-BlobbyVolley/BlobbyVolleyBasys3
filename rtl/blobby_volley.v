`timescale 1 ns / 1 ps

`include "_vga_macros.vh"

module blobby_volley(
  input wire clk,
  input wire rst,
  output wire vs,
  output wire hs,
  output wire [3:0] r,
  output wire [3:0] g,
  output wire [3:0] b,
  output wire pclk_mirror
  );

wire clk100MHz;
wire clk65MHz;

wire locked;
wire rst_d;

clock my_clock
 (
  // Clock out ports
  .clk100MHz(clk100MHz),
  .clk65MHz(clk65MHz),
  // Status and control signals
  .reset(rst),
  .locked(locked),
 // Clock in ports
  .clk(clk)
 );
 
reset my_reset 
(
	.rst(locked),
	.pclk(clk65MHz),
	.delay_rst(rst_d)
);

  ODDR pclk_oddr (
    .Q(pclk_mirror),
    .C(clk65MHz),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
  );


  wire [10:0] vcount, hcount;
  wire vsync, hsync;
  wire vblnk, hblnk;

vga_timing my_timing (
  .rst(rst_d),
  .vcount(vcount),
  .vsync(vsync),
  .vblnk(vblnk),
  .hcount(hcount),
  .hsync(hsync),
  .hblnk(hblnk),
  .pclk(clk65MHz)
);
 
wire [19:0] pixel_addr;
wire [11:0] rgb_pixel;

wire [`VGA_BUS_SIZE-1:0] vga_out;

draw_background my_draw_background (
  .rst(rst_d),
  .hcount_in(hcount),
  .hsync_in(hsync),
  .hblnk_in(hblnk),
  .vcount_in(vcount),
  .vsync_in(vsync),
  .vblnk_in(vblnk),
  .pclk(clk65MHz),
  
  .vga_out(vga_out)
  );

assign vs = vga_out[`VGA_VS_BITS];
assign hs = vga_out[`VGA_HS_BITS];
assign {r,g,b} = vga_out[`VGA_RGB_BITS]; 

endmodule
