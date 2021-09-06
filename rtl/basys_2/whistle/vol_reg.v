`timescale 1ns / 1ps

module vol_reg(
    input wire rst,
    input wire clk_slow,
    input wire clk_fast,
    input wire start,
    input wire [7:0] sig_in,
    output reg [7:0] sig_out
  );

  reg [3:0] coef, coef_nxt;
  reg [7:0] sig_out_nxt;
  reg [2:0] state, state_nxt;
  reg [9:0] ctr, ctr_nxt;

  localparam  IDLE = 3'b000,
              WAIT_PRE = 3'b001,
              CLR_CTR = 3'b010,
              RING = 3'b011,
              CLR_CTR2 = 3'b100,
              WAIT = 3'b11;


always @(posedge clk_fast)
  begin
    if(rst) sig_out <= 0;
    else    sig_out <= sig_out_nxt;
  end

  always @(posedge clk_slow)
  begin
    if(rst)
    begin
      state <= 0;
      ctr <= 0;
      coef <= 0;
    end
    else
    begin
      state <= state_nxt;
      ctr <= ctr_nxt;
      coef <= coef_nxt;
    end
  end

  always @*
  begin
    state_nxt = state;
    ctr_nxt = 10'b0;
    coef_nxt = coef;
    sig_out_nxt = 0;
    case(state)
      IDLE:
        if(start)
          state_nxt = RING;
        else 
          state_nxt = state;
      WAIT_PRE:
      begin
        if(ctr==10'd230)
          state_nxt = CLR_CTR;
        else 
          state_nxt = state;
        ctr_nxt = ctr + 1;
      end
      CLR_CTR:
        state_nxt = RING;
      RING:
      begin
        if(ctr==10'd100)
          state_nxt = CLR_CTR2;
        else 
          state_nxt = state;
        ctr_nxt = ctr + 1;
        sig_out_nxt = sig_in;
      end
      CLR_CTR2:
        state_nxt = WAIT;
      WAIT:
      begin
        if(ctr==10'd300)
          state_nxt = IDLE;
        else 
          state_nxt = state;
        ctr_nxt = ctr + 1;
      end
    endcase
  end



  endmodule
