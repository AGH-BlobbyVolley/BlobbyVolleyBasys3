/*--------------------------------------*/
/*      AUTHOR - Stanislaw Klat         */             
/*--------------------------------------*/

`timescale 1ns / 1ps

`include "_vga_macros.vh"

module draw_ball (
    input wire en,
    input wire rst,
    input wire pclk,
    
	input wire [11:0] xpos,
	input wire [11:0] ypos,
    input wire [`VGA_BUS_SIZE-1:0] vga_in,   
    output wire [`VGA_BUS_SIZE-1:0] vga_out,
	
	input wire [3:0] pixel,
	output reg [11:0] pixel_addr,
	
	output reg pl1_col,
	output reg pl2_col,
	output reg net_col
  );

localparam  PL1_COLOR = 12'h000,
            PL2_COLOR = 12'hF00,
            NET_COLOR = 12'h888;

`VGA_SPLIT_INPUT(vga_in)
`VGA_OUT_REG
`VGA_MERGE_OUTPUT(vga_out)

wire [11:0] hcount_buf;
wire hsync_buf;
wire hblnk_buf;
wire [11:0] vcount_buf;
wire vsync_buf;
wire vblnk_buf;
wire [11:0] rgb_buf;

localparam 	WIDTH = 64,
			HEIGHT = 64;


delay #(.WIDTH(40), .CLK_DEL(2))
my_delay
(
    .din( { hcount_in, hs_in, hblnk_in, vcount_in, vs_in, vblnk_in, rgb_in } ),
    .dout({hcount_buf,hsync_buf,hblnk_buf,vcount_buf,vsync_buf,vblnk_buf, rgb_buf}),
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
	if(hblnk_buf | vblnk_buf) begin
		rgb_out_nxt = rgb_buf;
		pl1_col = 0;
		pl2_col = 0;
		net_col = 0;
	end	
	else if( (ypos <= vcount_buf) && (xpos <= hcount_buf) && (ypos + HEIGHT > vcount_buf) && (xpos + WIDTH > hcount_buf) ) begin
		pl1_col = (pixel!='b0 && rgb_buf==PL1_COLOR);
		pl2_col = (pixel!='b0 && rgb_buf==PL2_COLOR);
		net_col = (pixel!='b0 && rgb_buf==NET_COLOR);
		if(pixel=='b0) rgb_out_nxt = rgb_buf;
		else rgb_out_nxt = {pixel,pixel,pixel};
	end
	else begin
		rgb_out_nxt = rgb_buf;
		pl1_col = 0;
	    pl2_col = 0;
        net_col = 0;
	end	
end

//generating pixel address

reg [11:0] pixel_addr_nxt;

always @* begin
    if( (ypos <= vcount_in) && (xpos <= hcount_in) && (ypos + HEIGHT > vcount_in) && (xpos + WIDTH > hcount_in) )
    begin
	   if(ypos == vcount_in && xpos == hcount_in) pixel_addr_nxt = 12'b0;
       else if(pixel_addr<WIDTH*HEIGHT-1) 
	   begin 
	   pixel_addr_nxt = pixel_addr + 1;
	   end
       else pixel_addr_nxt = 12'b0;
    end
	else pixel_addr_nxt = pixel_addr;
end

always @(posedge pclk) begin
    if(rst) pixel_addr <= 12'b0;
    else  pixel_addr <= pixel_addr_nxt;
end
 
endmodule 