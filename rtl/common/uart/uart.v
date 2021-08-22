`timescale 1ns / 1ps

module uart (
	input wire clk,
	input wire rst,
	input wire rx,
	output wire tx,
	input wire [15:0] data_in,
	output wire [15:0] data_out,
	output wire valid
);

wire tick;

wire rx_available;

mod_m_counter #(.N(6), .M(35)) // 9 i 326 teraz jest 115200
my_mod_m_counter(
	.clk(clk),
	.reset(rst),
	.max_tick(tick)
);

wire [7:0] data, cur_byte, prv_byte;
wire done_tick;

uart_rx my_uart_rx(
	.clk(clk),
	.reset(rst),
	.s_tick(tick),
	.dout(data),
	.rx_done_tick(done_tick),
	.rx(rx)
);

uart_tx my_uart_tx(
	.clk(clk),
	.reset(rst),
	.s_tick(tick),
	.din(data),
	.tx_start(done_tick),
	.tx_done_tick(),
	.tx(tx)
);

conv8to16bit my_conv8to16bit(
	.clk(clk),
	.rst(rst),
	.tick(done_tick),
	.din(data),
	.dout(data_out)
);

endmodule