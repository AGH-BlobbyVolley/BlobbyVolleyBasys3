module conv8to16bit (
    input wire clk,
    input wire rst,
    input wire clk_tick,
    input wire data_tick,
    output reg con_broken,
    input wire [7:0] din,
    output reg [15:0] dout
  );

  reg [7:0] dout_msb, dout_msb_nxt;
  reg [7:0] dout_lsb, dout_lsb_nxt;
  reg [15:0] dout_nxt;
  reg valid, con_broken_nxt;
  reg valid_nxt;

  reg [5:0] tick_cnt, tick_cnt_nxt;

  localparam KEYWORD = 8'b00001111;


  always @(posedge clk)
  begin
    if(rst)
      tick_cnt <= 6'b0;
    else
      tick_cnt <= tick_cnt_nxt;
  end

  always @*
  begin
    if(clk_tick)
    begin
      if(data_tick)
        tick_cnt_nxt = 6'b0;
      else
        tick_cnt_nxt = tick_cnt + 1;
    end
    else
      tick_cnt_nxt = tick_cnt;
  end

  always @(posedge clk)
  begin
    if(rst)
      con_broken <= 1'b1;
    else
      con_broken <= con_broken_nxt;
  end

  always @*
  begin
    if(con_broken==1'b1) con_broken_nxt=(din==KEYWORD) ? 1'b0 : 1'b1;
    else if(clk_tick && tick_cnt==6'h3F) con_broken_nxt = 1'b1;
    else con_broken_nxt = con_broken;
  end

  always @(posedge clk)
  begin
    if(rst)
      valid <= 0;
    else
      valid <= valid_nxt;
  end

  always @* begin
    if(data_tick) begin
       if(~con_broken) valid_nxt = ~valid;
       else if(con_broken && din==KEYWORD) valid_nxt = 1'b1;
       else valid_nxt = 1'b0;
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
    if(valid)
      dout_nxt = dout;
    else
      dout_nxt = {dout_msb, dout_lsb};
  end

  always @(posedge clk)
  begin
    if(rst)
    begin
      dout_msb <= 0;
      dout_lsb <= 0;
    end
    else
    begin
      dout_msb <= dout_msb_nxt;
      dout_lsb <= dout_lsb_nxt;
    end
  end

  always @*
  begin
    if(data_tick)
      {dout_msb_nxt, dout_lsb_nxt} = valid ? {din, dout_lsb} : {dout_msb, din};
    else
      {dout_msb_nxt, dout_lsb_nxt} = {dout_msb, dout_lsb};
  end

endmodule
