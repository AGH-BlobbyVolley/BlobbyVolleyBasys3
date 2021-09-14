/*--------------------------------------*/
/*      AUTHOR - Stanislaw Klat         */
/*--------------------------------------*/

`timescale 1ns / 1ps

module vol_reg(
    input wire rst,
    input wire clk_slow,
    input wire clk_fast,
    input wire start,
    input wire [7:0] sig_in,
    output reg [7:0] sig_out
  );

  reg [7:0] sig_out_nxt;
  reg [2:0] state, state_nxt;
  reg [9:0] ctr, ctr_nxt;
  reg start_int_nxt, start_int, start_prev; 
  
  localparam  IDLE = 3'b000,
              RING = 3'b001,
              CLR_CTR = 3'b10,
              WAIT = 3'b11;


always @(posedge clk_slow) begin
    if(rst) begin
      start_int <= 1'b0;
      start_prev <= 1'b0;
    end
    else begin
      start_int <= start_int_nxt;
      start_prev <= start;
    end
end

always @* begin
  if(start && ~start_prev) start_int_nxt = 1'b1;
  else start_int_nxt = 1'b0;
end

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
    end
    else
    begin
      state <= state_nxt;
      ctr <= ctr_nxt;
    end
  end

  always @*
  begin
    state_nxt = state;
    ctr_nxt = 10'b0;
    sig_out_nxt = 0;
    case(state)
      IDLE:
        if(start)
          state_nxt = RING;
        else 
          state_nxt = IDLE;
      RING:
      begin
        if(ctr==10'd100)
          state_nxt = CLR_CTR;
        else 
          state_nxt = state;
        ctr_nxt = ctr + 1;
        sig_out_nxt = sig_in;
      end
      CLR_CTR: begin
        state_nxt = WAIT;
        sig_out_nxt = 0;
      end
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
