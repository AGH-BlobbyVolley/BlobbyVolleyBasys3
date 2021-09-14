/*--------------------------------------*/
/*      AUTHOR - Stanisław Klat         */
/*--------------------------------------*/

module player1_rom (
    input wire clk,
    input wire [13:0] address,
    output reg [3:0] rgb
);


reg [13:0] rom [0:6674];

initial $readmemh("blobby.dat", rom);
always @(posedge clk)
    rgb <= rom[address];

endmodule
