/*--------------------------------------*/
/*      AUTHOR - Stanislaw Klat         */
/*--------------------------------------*/

`timescale 1ns / 1ps

module sine_gen
#(parameter SEED=22'b00_1111_1111_1111_0001_0111)   
(
    input wire rst,
    input wire clk,
    output reg signed [1:-20] signal, //12
    output reg [7:0] sig_out,
    output reg en_pwm
);
wire rst_d;
wire clk_div;
clk_divider #(
    .FREQ(100),
    .SRC_FREQ(25_600)
)
my_clk_div(
    .clk_in(clk),
    .rst(rst),
    .clk_div(clk_div),
    .count(),
    .rst_d(rst_d)
);

reg signed [1:-20] prev_point, pprev_point, prev_point_nxt, pprev_point_nxt, signal_nxt; //12
wire signed [2:-40] temp; //24
wire [7:0] temp2;
reg flag;

always @(posedge clk_div) begin
    if(rst_d) en_pwm <= 1'b0;
    else en_pwm <= 1'b1;
end

//localparam signed SEED = 22'b00_1111_1111_1111_0001_0111;//14'b00_1111_1111_0001;//14'b0_1111_1111_0011; //14'b0_1111_1000_0100;



localparam signed H0 = {SEED, 1'b0};

localparam OFFSET = 14'h0980; //h1015

//w0 = 2pif0/fs
//x[n] = 2*cos(w)*x[n-1] - x[n-2]
//x[n] = (cos(w)<<1)*x[n-1] - x[n-2]

always @(posedge clk_div) begin
    if(rst_d) begin
        flag <= 1;
        signal <= 0;
        prev_point <= SEED;
        pprev_point <= 22'h100000; //14 i 13b
    end
    else begin
        flag <= 0;
        signal <= signal_nxt;
        prev_point <= prev_point_nxt;
        pprev_point <= pprev_point_nxt;
    end
end

assign temp = (H0*prev_point); //prev_point[1] ? (H0*(~prev_point + 1)) : 

always @* begin
    prev_point_nxt = temp[2:-20] + ~{pprev_point[1], pprev_point} + 15'b1; // 12 15
    pprev_point_nxt = prev_point;
    signal_nxt = prev_point;// + OFFSET;
end

assign temp2 = {signal[1], signal[1:-6]} + 8'd128; 

always @* begin
    sig_out = temp2[7:0];
end

endmodule
