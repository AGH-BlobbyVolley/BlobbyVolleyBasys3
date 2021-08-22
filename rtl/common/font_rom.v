module font_rom (
    input wire clk,
    input wire [14:0] address,
    output reg [5:0] pixel
);


reg [5:0] rom [0:31679];

initial $readmemb("font.dat", rom);
always @(posedge clk)
    pixel <= rom[address];

endmodule
