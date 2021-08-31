`timescale 1 ns / 1 ps
`include "_vga_macros.vh"
module blobby_volley(
  inout ps2_clk,
  inout ps2_data,
  input wire clk,
  input wire rst,
  input wire test,
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
 wire [11:0] my_xpos,my_ypos;
 wire my_mouse_left;
  
 MouseCtl my_MouseCtl
  (
  .clk(clk100MHz),        
  .rst(rst),        
  .xpos(my_xpos),
  .ypos(my_ypos),      
  .zpos(),       
  .left(my_mouse_left),       
  .middle(),     
  .right(),      
  .new_event(),  
  .value(0),      
  .setx(),       
  .sety(),       
  .setmax_x(0),   
  .setmax_y(0),   
  .ps2_clk(ps2_clk),
  .ps2_data(ps2_data) 
  );
  wire [11:0] my_xpos_buf,my_ypos_buf;
  wire my_mouse_left_buf;
 
 buffor_signal_mouse my_buffor_signal_mouse( 
 .pclk(clk65MHz),            
 .rst(rst),             
 .my_left(my_mouse_left),         
 .my_xpos(my_xpos),  
 .my_ypos(my_ypos),  
 .my_left_buf(my_mouse_left_buf),     
 .my_xpos_buf(my_xpos_buf),
 .my_ypos_buf(my_ypos_buf)
 );
 
 
 wire [11:0] my_xpos_limit,my_ypos_limit;
 wire my_mouse_left_limit;

 wire [3:0] bcd01,bcd02,bcd11,bcd12;

 
 mouse_limit_player my_mouse_limit_player(
 .clk(clk65MHz),            
 .rst(rst),                                    
 .xpos(my_xpos_buf),            
 .ypos(my_ypos_buf),            
 .click_mouse(my_mouse_left_buf),                   
 .xpos_limit(my_xpos_limit),      
 .ypos_limit(my_ypos_limit),      
 .click_mouse_limit(my_mouse_left_limit)
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

wire [`VGA_BUS_SIZE-1:0] vga_bus [4:0];
  
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
wire [15:0] uart_to_reg, reg_to_uart;
  wire tx_done;
wire conv8to16valid, conv16to8ready;
uart my_uart (
  .clk(clk65MHz),
  .rst(rst_d),
  .rx(rx),
  .tx(tx),
  .tx_done(tx_done),
  .data_in(reg_to_uart),
  .data_out(uart_to_reg),
  .conv16to8ready(conv16to8ready),
  .conv8to16valid(conv8to16valid)
);
  wire [3:0] score_player1,score_player2;
  wire [11:0] ball_posx, ball_posy, pl1_posx, pl1_posy,pl2_posx,pl2_posy;
  wire [3:0] pixel;
  wire [11:0] pixel_addr_ball;
  wire [11:0] ball_xpos, ball_ypos;
  wire pl1_col;
  wire last_touch,thirdtouched,gnd_col,endgame;
  
uart_demux my_uart_demux(
  .data(uart_to_reg),       
  .clk(clk65MHz),               
  .rst(rst_d),                
  .pl2_posx(pl2_posx),    
  .pl2_posy(pl2_posy),
  .conv8to16valid(conv8to16valid)
);
  
uart_mux my_uart_mux(
  .data(reg_to_uart),
  .clk(clk65MHz),
  .tx_done(tx_done),
  .rst(rst_d),
  .pl1_posx(my_xpos_limit),
  .pl1_posy(my_ypos_limit),
  .ball_posx(ball_xpos),
  .ball_posy(ball_ypos),
  .pl1_score(score_player1),
  .pl2_score(score_player2),
  .flag_point(last_touch),
  .end_game(endgame),
  .conv16to8ready(conv16to8ready)
);

  wire [7:0] rgb_char,rgb_char2;
  wire [6:0] char_code,char_code2;
  wire [3:0] char_line;
  wire last_touch,thirdtouched,gnd_col;
    font_rom my_font_rom(
      .clk(clk65MHz),
      .rst(rst_d),
      .addr({char_code,char_line}),
      .char_line_pixels(rgb_char)
      );
   wire [3:0]score_pl1,score_pl2;
   score my_score(
   .rst(rst_d),                           
   .pclk(clk65MHz),                          
   .char_pixel(rgb_char),
   .char_pixel2(rgb_char2),                
   .bcd01(bcd01), 
   .flag_point(last_touch),              
   .bcd02(bcd02),
   .bcd11(bcd11),
   .bcd12(bcd12),               
   .vga_in(vga_bus[3]),    
   .vga_out(vga_bus[4]),  
   .char_line(char_line),               
   .char_code(char_code),
   .char_code2(char_code2)               
   );
   font_rom my_font_rom2(
     .clk(clk65MHz),
     .rst(rst_d),
     .addr({char_code2,char_line}),
     .char_line_pixels(rgb_char2)
     ); 


wire [3:0] rgb_pixel;
wire [13:0] pixel_addr;
player1 my_player1(
	.rst(rst_d),
	.xpos(my_xpos_limit),       
    .ypos(my_ypos_limit),       
    .mouse_click(my_mouse_left_limit),
	.pclk(clk65MHz),
	.vga_in(vga_bus[0]),
	.vga_out(vga_bus[1]),
	.rgb_pixel(rgb_pixel),
	.pixel_addr(pixel_addr)
);
wire [3:0] rgb_pixel2;
wire [13:0] pixel_addr2;

Player_2 my_player2(
	.rst(rst_d),
	.xpos(pl2_posx),       
  .ypos(pl2_posy),       
  .mouse_click(my_mouse_left_limit),
	.pclk(clk65MHz),
	.vga_in(vga_bus[1]),
	.vga_out(vga_bus[2]),
	.rgb_pixel(rgb_pixel2),
	.pixel_addr(pixel_addr2)
);

player1_rom my_player2_rom (
    .clk(clk65MHz),
    .address(pixel_addr2),
    .rgb(rgb_pixel2)
);

player1_rom my_player1_rom (
    .clk(clk65MHz),
    .address(pixel_addr),
    .rgb(rgb_pixel)
);
wire [3:0] pixel;
wire [11:0] pixel_addr_ball;
wire [11:0] ball_xpos, ball_ypos;
wire pl1_col,pl2_col,net_col;


draw_ball my_draw_ball(
	.rst(rst_d),
	.pclk(clk65MHz),
	.vga_in(vga_bus[2]),
	.vga_out(vga_bus[3]),
	.pixel(pixel),
	.pixel_addr(pixel_addr_ball),
	.xpos(ball_xpos),
	.ypos(ball_ypos),
	.pl1_col(pl1_col),
	.pl2_col(pl2_col),
  .net_col(net_col)
);

ball_rom my_ball_rom (
    .clk(clk65MHz),
    .address(pixel_addr_ball),
    .pixel(pixel)
);


ball_pos_ctrl my_ball_pos_ctrl(
	.rst(rst_d),
	.clk(clk65MHz),
	.pl1_col(pl1_col),
	.pl2_col(pl2_col),
	.net_col(net_col),
	.pl1_posx(my_xpos_limit),
	.pl1_posy(my_ypos_limit),
	.pl2_posx(pl2_posx),
	.pl2_posy(pl2_posy),
	.gnd_col(gnd_col),
	.ovr_touch(thirdtouched),
	.last_touch(last_touch),
	.ball_posx_out(ball_xpos),
	.ball_posy_out(ball_ypos)
);

bin2bcd bin2bcd_my1(
 .bin(score_pl1),  
 .bcd0(bcd01),
 .bcd1(bcd11)
);
bin2bcd bin2bcd_my2(
 .bin(score_pl2),  
 .bcd0(bcd02),
 .bcd1(bcd12)
);

judge my_judge(
	.rst(rst_d),
	.gnd_col(gnd_col),
	.yposball(ball_ypos),
	.xposball(ball_xpos),
	.collisionsplayer1(pl1_col),
	.collisionsplayer2(pl2_col),
	.clk(clk65MHz),
	.score_player1(score_pl1),
	.score_player2(score_pl2),
	.flag_point(last_touch),
	.endgame(),
	.thirdtouched(thirdtouched)
);

assign vs = vga_bus[4][`VGA_VS_BITS];
assign hs = vga_bus[4][`VGA_HS_BITS];
assign {r,g,b} = vga_bus[4][`VGA_RGB_BITS]; 


endmodule
