module conv16to8bit (
	input wire clk,
	input wire rst,
	input wire tick,
	output wire [7:0] dout,
	input wire [15:0] din
);
reg [7:0] dout_nxt;
reg sel, sel_nxt;

always @(posedge clk) begin
	if(rst) sel <= 0;
	else sel <= sel_nxt;
end

assign sel_nxt = tick ? ~sel : sel;

always @(posedge clk) begin
	if(rst) dout <= 0;
	else dout <= dout_nxt;
end
	
always @* begin
    if(tick) dout_nxt = sel ? din[15:8] : din[7:0];
    else dout_nxt = dout;
end
	
endmodule