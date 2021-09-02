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
	output wire conv16to8ready,
	output wire conv8to16valid
);
//--------------------------------------------------------//
localparam KEYWORD = 8'hFF;

wire rst_int;
reg con_broken, con_broken_nxt;
reg init_con, init_con_nxt;
reg [9:0] tick_cnt, tick_cnt_nxt;
wire rx_done;
wire [7:0] data_rx, data_tx, data_tx_int;

assign rst_int = rst || init_con;

always @(posedge clk)
  begin
    if(rst) begin
      tick_cnt <= 10'b0;
	  init_con <= 1'b1;
	end
    else begin
      tick_cnt <= tick_cnt_nxt;
	  init_con <= init_con_nxt;
	end
  end

always @*
begin
	if(con_broken) init_con_nxt = 1'b1;
	else if(~con_broken && tick_cnt>10'h32) init_con_nxt = 1'b0;
	else init_con_nxt = init_con;
end

  always @*
  begin
    if(tick)
    begin
      if(rx_done)
        tick_cnt_nxt = 10'b0;
      else
        tick_cnt_nxt = tick_cnt + 1;
    end
    else
      tick_cnt_nxt = tick_cnt;
  end

  always @(posedge clk)
  begin
    if(rst)
      con_broken <= 1'b1;
    else
      con_broken <= con_broken_nxt;
  end

  always @*
  begin
    if(con_broken==1'b1) begin //con_broken_nxt=(din==KEYWORD) ? 1'b0 : 1'b1;
		if(rx_done && data_rx==KEYWORD) con_broken_nxt = 1'b0;
		else con_broken_nxt = con_broken;
	end
    else if(tick && tick_cnt==10'h3FF) con_broken_nxt = 1'b1;
    else con_broken_nxt = con_broken;
  end

//--------------------------------------------------------//



mod_m_counter #(.N(6), .M(35)) // 9 i 326 teraz jest 115200
my_mod_m_counter(
	.clk(clk),
	.reset(rst),
	.max_tick(tick)
);
assign data_tx_int = init_con ? 8'hFF : data_tx; 

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
	.din(data_tx_int),
	.tx_start(1'b1),
	.tx_done_tick(tx_done),
	.tx(tx)
);

conv8to16bit my_conv8to16bit(
	.clk(clk),
	.rst(rst_int),
	.clk_tick(tick),
    .data_tick(rx_done),
	.din(data_rx),
	.dout(data_out),
	.valid(conv8to16valid)
);

conv16to8bit my_conv16to8bit(
	.clk(clk),
	.rst(rst_int),
	.tick(tx_done),
	.din(data_in),
	.dout(data_tx),
	.ready(conv16to8ready)
);

endmodule