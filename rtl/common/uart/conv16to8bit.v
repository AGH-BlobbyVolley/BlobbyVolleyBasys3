module conv16to8bit (
    input wire clk,
    input wire rst,
    input wire tick,
    output reg [7:0] dout,
    input wire [15:0] din,
    output reg ready
  );
  reg [7:0] dout_nxt;
  reg [1:0] word_nr, word_nr_nxt;
  reg ready_nxt;

  always @(posedge clk)
  begin
    if(rst) begin
      word_nr <= 0;
      ready <= 0;
    end
    else begin
      word_nr <= word_nr_nxt;
      ready <= ready_nxt;
    end
  end

  always @*
  begin
    if(tick) begin
      word_nr_nxt = word_nr + 1;
      if(word_nr==2'b11) ready_nxt = 1'b1;
      else ready_nxt = 1'b0;
    end
    else begin
      word_nr_nxt = word_nr;
      ready_nxt = ready;
    end
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
    case(word_nr)
      2'b00: dout_nxt = 8'h3F;
      2'b01: dout_nxt = {word_nr, din[15:12], 2'b0};
      2'b10: dout_nxt = {word_nr, din[11:6]};
      2'b11: dout_nxt = {word_nr, din[5:0] };
    endcase
  end

endmodule
