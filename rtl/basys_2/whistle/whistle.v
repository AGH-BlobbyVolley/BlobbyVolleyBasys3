/*--------------------------------------*/
/*      AUTHOR - Stanislaw Klat         */
/*--------------------------------------*/

`timescale 1ns / 1ps

module whistle(
    input wire rst,
    input wire clk,
    input wire start,
    output wire gain,
    output wire shut_down_n,
    output wire a_out
    );

wire clk12M5Hz, clk390kHz;
wire rst_d, rst_dd, rst_lf, clk100Hz;
assign gain = 1'b0;
assign shut_down_n = 1'b1;
reg rst_int, rst_int2, rst_int3;

always @(posedge clk) begin
    rst_int3 <= rst;
    rst_int2 <= rst_int3;
    rst_int <= rst_int2;
end

clk_divider #(
    .FREQ(12_500_000),
    .SRC_FREQ(100_000_000)
)
gen_clk(
    .clk_in(clk),
    .rst(rst_int),
    .clk_div(clk12M5Hz),
    .count(),
    .rst_d(rst_d)
);

clk_divider #(
    .FREQ(390_625),
    .SRC_FREQ(12_500_000)
)
lf_clk(
    .clk_in(clk12M5Hz),
    .rst(rst_d),
    .clk_div(clk390kHz),
    .count(),
    .rst_d(rst_lf)
);

clk_divider #(
    .FREQ(100),
    .SRC_FREQ(12_500_000)
)
reg_clk(
    .clk_in(clk12M5Hz),
    .rst(rst_d),
    .clk_div(clk100Hz),
    .count(),
    .rst_d(rst_dd)
);

wire en;
wire [21:0] sin_1, sin_2;
wire [7:0] sin_digit, sig_out;
sine_gen #(.SEED(22'b00_11100110011110010100))
my_sine_gen_1(
    .rst(rst_d),
    .clk(clk12M5Hz),
    .sig_out(),
    .en_pwm(en),
    .signal(sin_1)
);

sine_gen #(.SEED(22'b00_11111010100101111111))
my_sine_gen_2(
    .rst(rst_lf),
    .clk(clk390kHz),
    .sig_out(),
    .en_pwm(),
    .signal(sin_2)
);

pwm my_pwm(
    .in(sig_out),
    .en(en),
    .clk(clk12M5Hz),
    .rst(rst_d),
    .out(a_out)
);

mixer my_mixer(
    .rst(rst_d),
    .clk(clk12M5Hz),
    .sine_1(sin_1[21:14]),
    .sine_2(sin_2[21:14]),
    .mixed_out(sin_digit)
);

vol_reg my_vol_reg(
    .rst(rst_dd),
    .clk_slow(clk100Hz),
    .clk_fast(clk12M5Hz),
    .start(start),
    .sig_in(sin_digit),
    .sig_out(sig_out)
);

endmodule
