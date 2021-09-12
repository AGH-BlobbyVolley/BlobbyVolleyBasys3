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
  output wire tx,
  output wire gain,
  output wire shut_down_n,
  output wire a_out
  );
wire clk100MHz;
wire reset,reset_delay;
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
 assign rst_d = (reset||reset_delay)? 1 : 0;

 wire [11:0] my_xpos_limit,my_ypos_limit, my_xpos_buf, my_ypos_buf, ball_xpos, ball_ypos;
 wire [3:0] score_pl1, score_pl2;
 wire my_mouse_left_limit, my_mouse_left_buf;
 wire [11:0] my_xpos,my_ypos, pl1_posx, pl1_posy;
 wire my_mouse_left;
 wire [11:0] xpos_mux,ypos_mux;
 wire limit_mux;
 wire [3:0] bcd01,bcd02,bcd11,bcd12;
 wire mousectl, endgame, last_touch;
 wire whistle_play;

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
    .pl1_posx(pl1_posx),
    .pl1_posy(pl1_posy),
    .ball_xpos(ball_xpos),
    .ball_ypos(ball_ypos),
    .score_pl1(score_pl1),
    .score_pl2(score_pl2),
    .endgame(endgame),
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

uart_top my_uart_top(
    .clk65MHz(clk65MHz),
    .rst(rst_d),
    .tx(tx),
    .rx(rx),
    .pl1_posx(pl1_posx),
    .pl1_posy(pl1_posy),
    .ball_xpos(ball_xpos),
    .ball_ypos(ball_ypos),
    .score_pl1(score_pl1),
    .score_pl2(score_pl2),
    .endgame(endgame),
    .whistle_play(whistle_play),
    .last_touch(last_touch),
    .xpos_mux(xpos_mux),
    .ypos_mux(ypos_mux)
);

whistle my_whistle(
  .rst(rst),
  .clk(clk100MHz),
  .start(whistle_play),
  .gain(gain),
  .shut_down_n(shut_down_n),
  .a_out(a_out)
);

endmodule
