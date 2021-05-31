`timescale 1 ns / 1 ps

module ball_rom (
    input wire clk,
    input wire [11:0] address,
    output reg [3:0] pixel
);


reg [3:0] rom [0:4095];

initial $readmemh("ball.dat", rom);
always @(posedge clk)
    pixel <= rom[address];

endmodule
