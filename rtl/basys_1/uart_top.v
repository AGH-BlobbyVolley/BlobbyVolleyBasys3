`timescale 1 ns / 1 ps

module uart_top(
    input wire clk65MHz,
    input wire rst,
    output wire tx,
    input wire rx,
    input wire [11:0] xpos_mux,
    input wire [11:0] ypos_mux,
    input wire [11:0]ball_xpos,
    input wire [11:0]ball_ypos,
    input wire [3:0] score_pl1,
    input wire [3:0] score_pl2,
    input wire endgame,
    input wire whistle,
    input wire last_touch,
    output wire [11:0] pl2_posx,
    output wire [11:0] pl2_posy
  );

  wire [15:0] uart_to_reg, reg_to_uart;
  wire tx_done;
  wire conv8to16valid, conv16to8ready;
  uart my_uart (
         .clk(clk65MHz),
         .rst(rst),
         .rx(rx),
         .tx(tx),
         .tx_done(tx_done),
         .data_in(reg_to_uart),
         .data_out(uart_to_reg),
         .conv16to8ready(conv16to8ready),
         .conv8to16valid(conv8to16valid)
       );

  uart_demux my_uart_demux(
               .data(uart_to_reg),
               .clk(clk65MHz),
               .rst(rst),
               .pl2_posx(pl2_posx),
               .pl2_posy(pl2_posy),
               .conv8to16valid(conv8to16valid)
             );

  uart_mux my_uart_mux(
             .data(reg_to_uart),
             .clk(clk65MHz),
             .tx_done(tx_done),
             .rst(rst),
             .pl1_posx(xpos_mux),
             .pl1_posy(ypos_mux),
             .ball_posx(ball_xpos),
             .ball_posy(ball_ypos),
             .pl1_score(score_pl1),
             .pl2_score(score_pl2),
             .flag_point(last_touch),
             .end_game(endgame),
             .whistle(whistle),
             .conv16to8ready(conv16to8ready)
           );

endmodule
