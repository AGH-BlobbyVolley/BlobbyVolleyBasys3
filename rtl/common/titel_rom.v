module titel_rom (
    input wire rst,
    input wire clk,
    input wire [19:0] address,
    output reg [23:0] pixel
);


(* rom_style = "block" *) reg [23:0] ram [0:26199];
reg [5:0] buf1,buf2,buf3,buf4,pixel_nxt;
wire we; 

assign we = 0;

initial $readmemb("titel1.dat",ram );
always @(posedge clk)begin
    if (we) 
        ram[address[19:2]] <= 24'b0;
    //{buf1,buf2,buf3,buf4} <= ram[address[19:2]];
    pixel <= ram[address[19:2]];
end
    
always @(posedge clk)begin
    if (rst)
        pixel <=0;
        
    else
        pixel <= pixel_nxt;
end
/*
always @* begin
    case (address[1:0])
        2'b00:pixel_nxt =  buf1;
        2'b01:pixel_nxt =  buf2;
        2'b10:pixel_nxt =  buf3;
        2'b11:pixel_nxt =  buf4;
        
    endcase 
end*/
endmodule