// This is the ROM for the 'AGH48x64.png' image.
// The image size is 48 x 64 pixels.
// The input 'address' is a 12-bit number, composed of the concatenated
// 6-bit y and 6-bit x pixel coordinates.
// The output 'rgb' is 12-bit number with concatenated
// red, green and blue color values (4-bit each)
module image_rom (
    input wire clk ,
    input wire [19:0] address,  // address = {addry[9:0], addrx[9:0]}
    output reg [11:0] rgb
);


reg [19:0] rom [0:786431];

initial $readmemh("image.dat", rom);
always @(posedge clk)
    rgb <= rom[address];

endmodule
