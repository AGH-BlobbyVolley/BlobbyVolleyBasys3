`timescale 1 ns / 1 ps

module blobby_volley(
  inout ps2_clk,
  inout ps2_data,
  input wire clk,
  input wire rst,
  input wire rx,
  //input wire test,
  output wire vs,
  output wire hs,
  output wire [3:0] r,
  output wire [3:0] g,
  output wire [3:0] b,
  output wire pclk_mirror,
  output wire tx
  );
wire clk100MHz;
wire clk65MHz;
wire locked;
wire rst_d, reset_delay, reset;

wire [11:0] xpos_mux,ypos_mux, ball_xpos, ball_ypos, pl2_posx, pl2_posy;
wire [11:0] my_xpos_buf, my_ypos_buf;
wire [3:0] score_pl1, score_pl2;
wire endgame, whistle, last_touch, my_mouse_left_buf, mousectl, limit_mux;

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

 assign rst_d = (reset||reset_delay)? 1 : 0;

reset my_reset 
(
	.rst(locked),
	.pclk(clk65MHz),
	.delay_rst(reset_delay)
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
 
uart_top my_uart_top(
    .clk65MHz(clk65MHz),
    .rst(rst_d),
    .tx(tx),
    .rx(rx),
    .xpos_mux(xpos_mux),
    .ypos_mux(ypos_mux),
    .ball_xpos(ball_xpos),
    .ball_ypos(ball_ypos),
    .score_pl1(score_pl1),
    .score_pl2(score_pl2),
    .endgame(endgame),
    .whistle(whistle),
    .last_touch(last_touch),
    .pl2_posx(pl2_posx),
    .pl2_posy(pl2_posy)
  );

game my_game(
    .clk65MHz(clk65MHz),
    .rst(rst_d),
    .vs(vs),
    .hs(hs),
    .r(r),
    .g(g),
    .b(b),
    .xpos_mux(xpos_mux),
    .ypos_mux(ypos_mux),
    .limit_mux(limit_mux),
    .my_xpos_buf(my_xpos_buf),
    .my_ypos_buf(my_ypos_buf),
    .my_mouse_left_buf(my_mouse_left_buf),
    .pl2_posx(pl2_posx),
    .pl2_posy(pl2_posy),
    .ball_xpos(ball_xpos),
    .ball_ypos(ball_ypos),
    .score_pl1(score_pl1),
    .score_pl2(score_pl2),
    .endgame(endgame),
    .whistle(whistle),
    .last_touch(last_touch),
    .mousectl(mousectl),
    .reset(reset)
  );

  mouse_top my_mouse_top(
  .ps2_clk(ps2_clk),
  .ps2_data(ps2_data),
  .clk100MHz(clk100MHz),
  .clk65MHz(clk65MHz),
  .rst(rst),
  .rst_d(rst_d),
  .mousectl(mousectl),
  .xpos_mux(xpos_mux),
  .ypos_mux(ypos_mux),
  .limit_mux(limit_mux),
  .my_xpos_buf(my_xpos_buf),
  .my_ypos_buf(my_ypos_buf),
  .my_mouse_left_buf(my_mouse_left_buf)
);

endmodule
