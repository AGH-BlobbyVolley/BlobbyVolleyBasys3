`timescale 1 ns / 1 ps

module uart_top(
    input wire clk65MHz,
    input wire rst,
    output wire tx,
    input wire rx,
    output wire [11:0] pl1_posx,
    output wire [11:0] pl1_posy,
    output wire [11:0]ball_xpos,
    output wire [11:0]ball_ypos,
    output wire [3:0] score_pl1,
    output wire [3:0] score_pl2,
    output wire endgame,
    output wire whistle_play,
    output wire last_touch,
    input wire [11:0] xpos_mux,
    input wire [11:0] ypos_mux
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
    .pl1_posx(pl1_posx),
    .pl1_posy(pl1_posy),
    .ball_posx(ball_xpos),
    .ball_posy(ball_ypos),
    .pl1_score(score_pl1),
    .pl2_score(score_pl2),
    .flag_point(last_touch),
    .end_game(endgame),
    .whistle_play(whistle_play),
    .conv8to16valid(conv8to16valid)
  );

uart_mux my_uart_mux(
    .clk(clk65MHz),
    .rst(rst),
    .tx_done(tx_done),
    .conv16to8ready(conv16to8ready),
    //input data to mux
    .pl2_posx(xpos_mux),
    .pl2_posy(ypos_mux),
    .start_game(1'b0),
    //mux output
    .data(reg_to_uart)
  );

endmodule