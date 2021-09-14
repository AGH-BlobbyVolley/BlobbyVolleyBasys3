/*--------------------------------------*/
/*      AUTHOR - Stanisław Klat         */
/*--------------------------------------*/

`timescale 1ns / 1ps

module conv8to16bit (
    input wire clk,
    input wire rst,
    input wire clk_tick,
    input wire data_tick,
    input wire [7:0] din,
    output reg [15:0] dout,
    output reg valid
  );

  reg [1:0] word_nr, word_nr_nxt;

  reg [15:0] dout_nxt;
  reg valid_nxt;

  always @(posedge clk)
  begin
    if(rst)
      valid <= 0;
    else
      valid <= valid_nxt;
  end

  always @(posedge clk)
  begin
    if(rst)
      dout <= 0;
    else
      dout <= dout_nxt;
  end

  always @*
  begin
    dout_nxt = dout;
    valid_nxt = valid;
    if(data_tick)
      case(din[7:6])
        2'b00: begin
          dout_nxt = 16'hFFFF;
          valid_nxt = 1'b0;
        end
        2'b01: begin
          dout_nxt = {din[5:2], dout[11:0]};
          valid_nxt = 1'b0;
        end
        2'b10: begin
          dout_nxt = {dout[15:12], din[5:0], dout[5:0]};
          valid_nxt = 1'b0;
        end
        2'b11: begin 
          dout_nxt = {dout[15:6], din[5:0]};
          valid_nxt = 1'b1;
        end
      endcase
  end

endmodule
