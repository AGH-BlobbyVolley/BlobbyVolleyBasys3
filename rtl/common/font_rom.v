module font_rom (
    input wire clk,
    input wire rst,
    input wire [14:0] address,
    output reg [5:0] pixel
);


(* ram_style = "block" *)reg [23:0] ram [0:7919];
reg [5:0] buf1,buf2,buf3,buf4,pixel_nxt;

initial $readmemb("font1.dat", ram);
always @*
    {buf1,buf2,buf3,buf4} <= ram[address[14:2]];
    
    
always @(posedge clk)begin
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
end
endmodule
