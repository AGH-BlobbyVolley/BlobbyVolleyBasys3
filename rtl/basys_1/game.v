`timescale 1 ns / 1 ps
`include "_vga_macros.vh"

module game(
    input wire clk65MHz,
    input wire rst,
    output wire vs,
    output wire hs,
    output wire [3:0] r,
    output wire [3:0] g,
    output wire [3:0] b,
    input wire [11:0] xpos_mux,
    input wire [11:0] ypos_mux,
    input wire limit_mux,
    input wire [11:0] my_xpos_buf,
    input wire [11:0] my_ypos_buf,
    input wire my_mouse_left_buf,
    input wire [11:0] pl2_posx,
    input wire [11:0] pl2_posy,
    output wire [11:0]ball_xpos,
    output wire [11:0]ball_ypos,
    output wire [3:0] score_pl1,
    output wire [3:0] score_pl2,
    output wire endgame,
    output wire whistle,
    output wire last_touch,
    output wire mousectl,
    output wire reset
  );

  wire [11:0] vcount, hcount;
  wire vsync, hsync;
  wire vblnk, hblnk;
  wire [11:0] ball_posx, ball_posy, pl1_posx, pl1_posy;
  wire [3:0] pixel;
  wire [11:0] pixel_addr_ball;
  wire thirdtouched,gnd_col;
  wire [7:0] rgb_char,rgb_char2;
  wire [6:0] char_code,char_code2;
  wire [3:0] char_line;
  wire pl1_col,pl2_col,net_col;
  wire [3:0] bcd01,bcd02,bcd11,bcd12;

  vga_timing my_timing (
               .rst(rst),
               .vcount(vcount),
               .vsync(vsync),
               .vblnk(vblnk),
               .hcount(hcount),
               .hsync(hsync),
               .hblnk(hblnk),
               .pclk(clk65MHz)
             );

  wire [`VGA_BUS_SIZE-1:0] vga_bus [5:0];

  draw_background my_draw_background (
                    .rst(rst),
                    .hcount_in(hcount),
                    .hsync_in(hsync),
                    .hblnk_in(hblnk),
                    .vcount_in(vcount),
                    .vsync_in(vsync),
                    .vblnk_in(vblnk),
                    .pclk(clk65MHz),
                    .vga_out(vga_bus[0])
                  );

  font_rom my_font_rom(
             .clk(clk65MHz),
             .rst(rst),
             .addr({char_code,char_line}),
             .char_line_pixels(rgb_char)
           );

  score my_score(
          .rst(rst),
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
             .rst(rst),
             .addr({char_code2,char_line}),
             .char_line_pixels(rgb_char2)
           );


  wire [3:0] rgb_pixel;
  wire [13:0] pixel_addr;
  player1 my_player1(
            .rst(rst),
            .xpos(xpos_mux),
            .ypos(ypos_mux),
            .pclk(clk65MHz),
            .vga_in(vga_bus[0]),
            .vga_out(vga_bus[1]),
            .rgb_pixel(rgb_pixel),
            .pixel_addr(pixel_addr)
          );
  wire [3:0] rgb_pixel2;
  wire [13:0] pixel_addr2;

  Player_2 my_player2(
             .rst(rst),
             .xpos(pl2_posx),
             .ypos(pl2_posy),
             .pclk(clk65MHz),
             .vga_in(vga_bus[1]),
             .vga_out(vga_bus[2]),
             .rgb_pixel(rgb_pixel2),
             .pixel_addr(pixel_addr2)
           );
  wire enable_menu;
  menu my_menu(
         .clk(clk65MHz),
         .rst(rst),
         .left(my_mouse_left_buf),
         .xpos(my_xpos_buf),
         .ypos(my_ypos_buf),
         .enable_menu(enable_menu),
         .endgame(endgame),
         .reset(reset),
         .flag_point(last_touch),
         .enable_game(),
         .vga_in_menu(vga_bus[2]),
         .vga_out(vga_bus[5]),
         .mousecontrol(mousectl)
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

  draw_ball my_draw_ball(
              .rst(rst),
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
                  .rst(rst),
                  .clk(clk65MHz),
                  .pl1_col(pl1_col),
                  .pl2_col(pl2_col),
                  .net_col(net_col),
                  .pl1_posx(xpos_mux),
                  .pl1_posy(ypos_mux),
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
          .rst(rst),
          .gnd_col(gnd_col),
          .yposball(ball_ypos),
          .xposball(ball_xpos),
          .collisionsplayer1(pl1_col),
          .collisionsplayer2(pl2_col),
          .clk(clk65MHz),
          .score_player1(score_pl1),
          .score_player2(score_pl2),
          .flag_point(last_touch),
          .endgame(endgame),
          .thirdtouched(thirdtouched),
          .whistle(whistle)
        );

  assign vs = (enable_menu)? vga_bus[5][`VGA_VS_BITS] : vga_bus[4][`VGA_VS_BITS];
  assign hs = (enable_menu)? vga_bus[5][`VGA_HS_BITS] : vga_bus[4][`VGA_HS_BITS];
  assign {r,g,b} = (enable_menu)? vga_bus[5][`VGA_RGB_BITS] : vga_bus[4][`VGA_RGB_BITS];

endmodule
