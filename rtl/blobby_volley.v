`timescale 1 ns / 1 ps

`include "_vga_macros.vh"

module blobby_volley(
  input wire clk,
  input wire rst,
  input wire test,
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


  wire [11:0] vcount, hcount;
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

wire [`VGA_BUS_SIZE-1:0] vga_bus [2:0];

draw_background my_draw_background (
	.rst(rst_d),
	.hcount_in(hcount),
	.hsync_in(hsync),
	.hblnk_in(hblnk),
	.vcount_in(vcount),
	.vsync_in(vsync),
	.vblnk_in(vblnk),
	.pclk(clk65MHz),

	.vga_out(vga_bus[0])
  );

wire [3:0] rgb_pixel;
wire [13:0] pixel_addr;

player1 my_player1(
	.rst(rst_d),
	.pclk(clk65MHz),
	.vga_in(vga_bus[0]),
	.vga_out(vga_bus[1]),
	.rgb_pixel(rgb_pixel),
	.pixel_addr(pixel_addr)
);

player1_rom my_player1_rom (
    .clk(clk65MHz),
    .address(pixel_addr),
    .rgb(rgb_pixel)
);

wire [3:0] pixel;
wire [11:0] pixel_addr_ball;
wire [11:0] ball_xpos, ball_ypos;

draw_ball my_draw_ball(
	.rst(rst_d),
	.pclk(clk65MHz),
	.vga_in(vga_bus[1]),
	.vga_out(vga_bus[2]),
	.pixel(pixel),
	.pixel_addr(pixel_addr_ball),
	.xpos(ball_xpos),
	.ypos(ball_ypos)
);

ball_rom my_ball_rom (
    .clk(clk65MHz),
    .address(pixel_addr_ball),
    .pixel(pixel)
);

ball_pos_ctrl my_ball_pos_ctrl(
	.rst(rst_d),
	.clk(clk65MHz),
	.pl1_col(test),
	.pl2_col(1'b0),
	.net_col(1'b0),
	.pl1_posx(12'd180),
	.pl1_posy(12'd325),
	.pl2_posx(12'b0),
	.pl2_posy(12'b0),
	.gnd_col(),
	.ovr_touch(),
	.ball_posx_out(ball_xpos),
	.ball_posy_out(ball_ypos)
);

assign vs = vga_bus[2][`VGA_VS_BITS];
assign hs = vga_bus[2][`VGA_HS_BITS];
assign {r,g,b} = vga_bus[2][`VGA_RGB_BITS]; 

endmodule
