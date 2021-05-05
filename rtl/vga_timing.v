// File: vga_timing.v
// This is the vga timing design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_timing (
  input wire rst,
  input wire pclk,
  output reg [10:0] vcount,
  output reg vsync,
  output reg vblnk,
  output reg [10:0] hcount,
  output reg hsync,
  output reg hblnk  
  );

parameter 	HOR_TOTAL_TIME 	= 1344,
			HOR_ADDR_TIME	= 1024,
			HOR_FRONT_PROCH	= 24,
			HOR_SYNC_TIME	= 136,
			HOR_BACK_PORCH	= 160,
			VER_TOTAL_TIME 	= 806,
			VER_ADDR_TIME	= 768,
			VER_FRONT_PROCH	= 3,
			VER_SYNC_TIME	= 6,
			VER_BACK_PORCH	= 29;



 wire vsync_nxt;
 wire vblnk_nxt;
 wire hsync_nxt;
 wire hblnk_nxt; 


//horizontal counter
reg [10:0] hcount_nxt;
//vertical counter
reg [10:0] vcount_nxt;


always @(posedge pclk) begin
	if(rst) begin
	        hcount <= 11'b0;
			vcount <= 11'b0;
			vsync <= 0;
			vblnk <= 0;
			hsync <= 0;
			hblnk <= 0;
			end
	else 	begin
			vcount <= vcount_nxt;
			vsync <= vsync_nxt;
			vblnk <= vblnk_nxt;
			hsync <= hsync_nxt;
			hblnk <= hblnk_nxt;
			hcount <= hcount_nxt;
			end
end

always @* begin
	if(hcount == HOR_TOTAL_TIME - 1) hcount_nxt = 0;
	else hcount_nxt = hcount + 1;
end

always @* begin
	if( ((vcount == VER_TOTAL_TIME - 1) && (hcount == HOR_TOTAL_TIME - 1)) ) vcount_nxt = 0;
	else if(hcount == HOR_TOTAL_TIME - 1) vcount_nxt = vcount + 1;
	else vcount_nxt = vcount;
end

//sync combinational control
assign hsync_nxt = ( hcount_nxt > (HOR_ADDR_TIME+HOR_FRONT_PROCH-1) ) && ( hcount_nxt < (HOR_ADDR_TIME+HOR_FRONT_PROCH+HOR_SYNC_TIME) );
assign hblnk_nxt = (hcount_nxt > (HOR_ADDR_TIME-1));
assign vsync_nxt = ( vcount_nxt > (VER_ADDR_TIME+VER_FRONT_PROCH-1) ) && ( vcount_nxt < (VER_ADDR_TIME+VER_FRONT_PROCH+VER_SYNC_TIME-1) );
assign vblnk_nxt = (vcount_nxt > (VER_ADDR_TIME-1));

endmodule