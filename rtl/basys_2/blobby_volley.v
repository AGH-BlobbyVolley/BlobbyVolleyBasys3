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
wire [`VGA_BUS_SIZE-1:0] vga_bus [3:0];
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

uart my_uart (
	.clk(clk65MHz),
	.rst(rst_d),
	.rx(rx),
	.tx(tx),
  .tx_done(tx_done),
	.data_in(reg_to_uart),
	.data_out(uart_to_reg)
);

wire [11:0] ball_posx, ball_posy, pl1_posx, pl1_posy;

uart_demux my_uart_demux(
    .data(uart_to_reg),
    .clk(clk65MHz),
    .rst(rst_d),
    .pl1_posx(pl1_posx),
    .pl1_posy(pl1_posy),
    .pl2_posx(),
    .pl2_posy(),
    .ball_posx(ball_posx),
    .ball_posy(ball_posy),
    .pl1_score(),
    .pl2_score(),
    .flag_point(),
    .end_game()
  );

uart_mux my_uart_mux(
    .clk(clk65MHz),
    .rst(rst_d),
    .tx_done(tx_done),
    //input data to mux
    .pl2_posx(my_xpos_limit),
    .pl2_posy(my_ypos_limit),
    .start_game(1'b0),
    //mux output
    .data(reg_to_uart)
  );

wire [3:0] rgb_pixel;
wire [13:0] pixel_addr;
player1 my_player1(
	.rst(rst_d),
	.xpos(pl1_posx),       
  .ypos(pl1_posy),       
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
	.xpos(my_xpos_limit),       
  .ypos(my_ypos_limit),       
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
wire pl1_col;

draw_ball my_draw_ball(
	.rst(rst_d),
	.pclk(clk65MHz),
	.vga_in(vga_bus[2]),
	.vga_out(vga_bus[3]),
	.pixel(pixel),
	.pixel_addr(pixel_addr_ball),
	.xpos(ball_posx),
	.ypos(ball_posy),
	.pl1_col()
);

ball_rom my_ball_rom (
    .clk(clk65MHz),
    .address(pixel_addr_ball),
    .pixel(pixel)
);

assign vs = vga_bus[3][`VGA_VS_BITS];
assign hs = vga_bus[3][`VGA_HS_BITS];
assign {r,g,b} = vga_bus[3][`VGA_RGB_BITS]; 

endmodule