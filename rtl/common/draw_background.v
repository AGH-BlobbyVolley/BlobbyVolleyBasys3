/*--------------------------------------*/
/*      AUTHOR - Szymon Irla            */
/*      AUTHOR - Stanisław Klat         */
/*--------------------------------------*/

`timescale 1 ns / 1 ps

`include "_vga_macros.vh"

module draw_background (
    input wire rst,
    input wire pclk,
    input wire [11:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [11:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [7:0] char_line_pixels,
    output wire [`VGA_BUS_SIZE-1:0] vga_out
  );

`VGA_OUT_REG
`VGA_MERGE_OUTPUT(vga_out)

localparam 	WIDTH = 1023,
			HEIGHT = 767;

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
	hcount_out <= hcount_in;
	hs_out <= hsync_in;
	hblnk_out <= hblnk_in;
	vcount_out <= vcount_in;
	vs_out <= vsync_in;
	vblnk_out <= vblnk_in;
	end
end

reg [11:0] rgb_out_nxt;

always @(posedge pclk) begin
	if(rst) rgb_out <= 0;
	else rgb_out <= rgb_out_nxt;
end
 
always @* begin
	if(hblnk_in | vblnk_in) rgb_out_nxt = 12'h0_0_0;
	else begin
		if( (vcount_in<=28)) rgb_out_nxt = 12'h3BE;
		else if((hcount_in>500 && hcount_in<=524)&&(vcount_in>450 && vcount_in<=767)) rgb_out_nxt = 12'h888;
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