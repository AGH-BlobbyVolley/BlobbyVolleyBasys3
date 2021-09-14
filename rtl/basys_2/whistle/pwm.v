/*--------------------------------------*/
/*      AUTHOR - Stanislaw Klat         */
/*--------------------------------------*/

`timescale 1ns / 1ps

module pwm(
    input wire [7:0] in,
    input wire en,
    input wire clk,
    input wire rst,
    output reg out
    );

reg [7:0] ctr, ctr_nxt;
reg out_nxt;

always @(posedge clk) begin
    if(rst) out = 1'b0;
    else out = out_nxt;
end

always @* begin
    if(ctr<in) out_nxt = 1;
    else out_nxt = 0;
end

always @(posedge clk) begin
    if(rst) ctr <= 8'b0;
    else ctr <= ctr_nxt;
end

always @* begin
    if(en) ctr_nxt = ctr + 1;
    else ctr_nxt = 0;
end

endmodule
