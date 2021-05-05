`timescale 1 ns / 1 ps

module draw_background (
    input wire rst,
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire pclk,
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out,
    
    input wire [11:0] rgb_pixel,
    output reg [19:0] pixel_addr
  );

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
	hsync_out <= 0;
	hblnk_out <= 0;
	vcount_out <= 0;
	vsync_out <= 0;
	vblnk_out <= 0;
	end
	else begin
	hcount_out <= hcount_buf;
	hsync_out <= hsync_buf;
	hblnk_out <= hblnk_buf;
	vcount_out <= vcount_buf;
	vsync_out <= vsync_buf;
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
	else rgb_out_nxt = rgb_pixel;
end

//generating pixel address

reg [9:0] pixel_addrx_nxt, pixel_addry_nxt;

always @* begin
    if(hcount_in<=WIDTH && vcount_in<=HEIGHT)
    begin
       if(0 == vcount_in && 0 == hcount_in) {pixel_addry_nxt,pixel_addrx_nxt} = 20'b0;
       else if(pixel_addr[9:0]<WIDTH) 
       begin 
           pixel_addrx_nxt = pixel_addr[9:0] + 1;
           pixel_addry_nxt = pixel_addr[19:10];
       end
       else if((pixel_addr[19:10]<HEIGHT) && (pixel_addr[9:0]==WIDTH)) 
       begin
           pixel_addry_nxt = pixel_addr[19:10] + 1;
           pixel_addrx_nxt = 0;
       end
       else {pixel_addry_nxt,pixel_addrx_nxt} = 20'b0;
    end
    else {pixel_addry_nxt,pixel_addrx_nxt} = pixel_addr;
end

always @(posedge pclk) begin
    if(rst) pixel_addr <= 20'b0;
    else  pixel_addr <= {pixel_addry_nxt, pixel_addrx_nxt};
end

endmodule