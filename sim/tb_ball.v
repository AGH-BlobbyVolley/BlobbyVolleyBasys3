`timescale 1 ns / 1 ps

module tb_ball();

integer i;
reg clk, rst, pl1_col;
wire [11:0] ball_xpos, ball_ypos;

initial forever begin
#5 clk = 1;
#5 clk = 0;
end

initial begin
pl1_col = 0;
rst=0;
@(negedge clk) rst = 1;
@(negedge clk) rst = 0;
for(i=0;i<6;i=i+1) @(negedge clk);
#65_000_000 pl1_col = 1;
#70_000_00  pl1_col = 0;
end

ball_pos_ctrl DUT(
	.rst(rst),
	.clk(clk),
	.pl1_col(pl1_col),
	.pl2_col(1'b0),
	.net_col(1'b0),
	.pl1_posx(12'd320),
	.pl1_posy(12'd600),
	.pl2_posx(12'b0),
	.pl2_posy(12'b0),
	.gnd_col(),
	.ovr_touch(),
	.ball_posx_out(ball_xpos),
	.ball_posy_out(ball_ypos)
);

endmodule