module conv8to16bit (
	input wire clk,
	input wire rst,
	input wire tick,
	input wire [7:0] din,
	output reg [15:0] dout
);

reg [7:0] dout_msb, dout_msb_nxt;
reg [7:0] dout_lsb, dout_lsb_nxt;
reg [15:0] dout_nxt;
reg valid;
wire valid_nxt;

always @(posedge clk) begin
	if(rst) valid <= 0;
	else valid <= valid_nxt;
end

always @(posedge clk) begin
	if(rst) dout <= 0;
	else dout <= dout_nxt;
end

always @* begin
    if(valid) dout_nxt = dout;
    else dout_nxt = {dout_msb, dout_lsb};
end

assign valid_nxt = tick ? ~valid : valid;

always @(posedge clk) begin
	if(rst) begin
		dout_msb <= 0;
		dout_lsb <= 0;
	end
	else begin
		dout_msb <= dout_msb_nxt;
		dout_lsb <= dout_lsb_nxt;
	end
end
	
always @* begin
    if(tick) {dout_msb_nxt, dout_lsb_nxt} = valid ? {din, dout_lsb} : {dout_msb, din};
    else {dout_msb_nxt, dout_lsb_nxt} = {dout_msb, dout_lsb};
end
	
endmodule