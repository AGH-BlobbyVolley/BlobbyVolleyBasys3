/*--------------------------------------*/
/*      AUTHOR - Stanislaw Klat         */
/*--------------------------------------*/

`timescale 1ns / 1ps

module mixer(
    input wire rst,
    input wire clk,
    input wire signed [7:0] sine_1,
    input wire signed [7:0] sine_2,
    // input wire [7:0] sine_3,
    output reg [7:0] mixed_out
);
wire signed [15:0]  mixed_int;
wire signed [7:0] mixed_out_nxt;

assign mixed_int = sine_1 * sine_2;
assign mixed_out_nxt = mixed_int[13:6] + 8'd85;
always @(posedge clk) begin
    if(rst) mixed_out <= 8'b0;
    else mixed_out <= mixed_out_nxt;
end

endmodule
