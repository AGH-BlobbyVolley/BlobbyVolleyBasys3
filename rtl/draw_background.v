`timescale 1 ns / 1 ps

`include "_vga_macros.vh"

module draw_background (
    input wire rst,
    input wire pclk,
    
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    
    output wire [`VGA_BUS_SIZE-1:0] vga_out
  );

`VGA_OUT_REG
`VGA_MERGE_OUTPUT(vga_out)

wire [10:0] hcount_buf;
wire hsync_buf;
wire hblnk_buf;
wire [10:0] vcount_buf;
wire vsync_buf;
wire vblnk_buf;

localparam 	WIDTH = 1023,
			HEIGHT = 767;


delay #(.WIDTH(26), .CLK_DEL(2))
my_delay
(
    .din( { hcount_in, hsync_in, hblnk_in, vcount_in, vsync_in, vblnk_in } ),
    .dout({hcount_buf,hsync_buf,hblnk_buf,vcount_buf,vsync_buf,vblnk_buf}),
    .rst(rst),
    .clk(pclk)
);

always @(posedge pclk) begin
	if (rst) begin
	hcount_out <= 0;
	hs_out <= 0;
	hblnk_out <= 0;
	vcount_out <= 0;
	vs_out <= 0;
	vblnk_out <= 0;
	end
	else begin
	hcount_out <= hcount_buf;
	hs_out <= hsync_buf;
	hblnk_out <= hblnk_buf;
	vcount_out <= vcount_buf;
	vs_out <= vsync_buf;
	vblnk_out <= vblnk_buf;
	end
end

reg [11:0] rgb_out_nxt;

always @(posedge pclk) begin
	if(rst) rgb_out <= 0;
	else rgb_out <= rgb_out_nxt;
end
 
always @* begin
	if(hblnk_buf | vblnk_buf) rgb_out_nxt = 12'h0_0_0;
	else begin
		if(vcount_in<=6 || (vcount_in>12 && vcount_in<=20)) rgb_out_nxt = 12'h3BE;
		else if((vcount_in>6 && vcount_in<=12) || (vcount_in>20 && vcount_in<=28)) rgb_out_nxt = 12'h6CF;
		else if((vcount_in>28 && vcount_in<=462) || (vcount_in>576 && vcount_in<=586)) rgb_out_nxt = 12'h7AD;
		else if((vcount_in>462 && vcount_in<=474)) rgb_out_nxt = 12'hBDF;
		else if((vcount_in>474 && vcount_in<=483)) rgb_out_nxt = 12'h05A;
		else if((vcount_in>483 && vcount_in<=512)) rgb_out_nxt = 12'h28D;
		else if((vcount_in>512 && vcount_in<=576)) rgb_out_nxt = 12'h9CE;
		else if((vcount_in>586 && vcount_in<=594)) rgb_out_nxt = 12'hFFF;
		else if((vcount_in>594 && vcount_in<=614)) rgb_out_nxt = 12'h974;
		else if((vcount_in>614 && vcount_in<=670)) rgb_out_nxt = 12'hC96;
		else rgb_out_nxt = 12'hEC9;
	end
	
end

endmodule