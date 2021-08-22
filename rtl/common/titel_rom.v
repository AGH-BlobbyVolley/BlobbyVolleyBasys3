module font_rom (
    input wire clk,
    input wire [19:0] address,
    output reg [5:0] pixel
);


reg [5:0] rom [0:104795];

initial $readmemb("titel.dat", rom);
always @(posedge clk)
    pixel <= rom[address];

endmodule
