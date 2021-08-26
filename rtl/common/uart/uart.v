`timescale 1ns / 1ps

module uart (
	input wire clk,
	input wire rst,
	input wire rx,
	output wire tx,
	output wire tx_done,
	input wire [15:0] data_in,
	output wire [15:0] data_out,
	output wire tick,
	output wire con_broken
);

//wire tick;
wire rx_done;

mod_m_counter #(.N(8), .M(212)) // 9 i 326 teraz jest 115200
my_mod_m_counter(
	.clk(clk),
	.reset(rst),
	.max_tick(tick)
);

wire [7:0] data_rx, data_tx;
wire done_tick;

uart_rx my_uart_rx(
	.clk(clk),
	.reset(rst),
	.s_tick(tick),
	.dout(data_rx),
	.rx_done_tick(rx_done),
	.rx(rx)
);

uart_tx my_uart_tx(
	.clk(clk),
	.reset(rst),
	.s_tick(tick),
	.din(data_tx),
	.tx_start(1'b1),
	.tx_done_tick(tx_done),
	.tx(tx)
);

conv8to16bit my_conv8to16bit(
	.clk(clk),
	.rst(rst),
	.clk_tick(tick),
    .data_tick(rx_done),
    .con_broken(con_broken),
	.din(data_rx),
	.dout(data_out)
);

conv16to8bit my_conv16to8bit(
	.clk(clk),
	.rst(rst),
	.tick(tx_done),
	.din(data_in),
	.dout(data_tx)
);

endmodule