module font_rom (
    input wire clk,
    input wire rst,
    input wire [14:0] address,
    output reg [5:0] pixel
);

wire en;
(*rom_style="block"*)reg [5:0] rom [0:7920*4-1];
//wire [5:0] buf1,buf2,buf3,buf4;
//reg [5:0] pixel_nxt;
//reg [23:0] temp;

assign en = 1'b1;

initial $readmemb("font.dat", rom);
always @(posedge clk) begin
	if(en) pixel <= rom[address[14:0]];
end    

//assign {buf1,buf2,buf3,buf4} = temp; 
 
/*always @(posedge clk)begin
    if (rst)
        pixel <=0;
    else
        pixel <= pixel_nxt;
end

always @* begin
    case (address[1:0])
        2'b00:pixel_nxt =  buf1;
        2'b01:pixel_nxt =  buf2;
        2'b10:pixel_nxt =  buf3;
        2'b11:pixel_nxt =  buf4;
    endcase 
end*/
endmodule
