/*--------------------------------------*/
/*      AUTHOR - Stanisław Klat         */
/*--------------------------------------*/

module uart_mux (
    input wire clk,
    input wire rst,
    input wire tx_done,
    //input data to mux
    input wire [11:0] pl2_posx,
    input wire [11:0] pl2_posy,
    input wire start_game,
    //mux output
    output reg [15:0] data
  );

  reg nd_time, nd_time_nxt = 1'b0;

  reg [3:0] sel, sel_nxt;

  always @(posedge clk)
  begin
    if(rst) begin
      sel <= 4'b0;
      nd_time <= 1'b0;
    end
    else begin
      sel <= sel_nxt;
      nd_time <= nd_time_nxt;
    end
  end

  always @* begin
    sel_nxt = (tx_done & (~nd_time)) ? sel + 1 : sel;
    nd_time_nxt = tx_done ? ~nd_time : nd_time;
  end

  localparam  PL2_POSX = 4'h1,
              PL2_POSY = 4'h2,
              MATCH_CTRL = 4'h3;

  reg [15:0] data_nxt;

  always @(posedge clk)
  begin
    if(rst)
      data <= 16'b0;
    else
      data <= data_nxt;
  end

  always @*
  begin
    case(sel)
      PL2_POSX:
        data_nxt = {sel, pl2_posx};
      PL2_POSY:
        data_nxt = {sel, pl2_posy};
      MATCH_CTRL:
        data_nxt = {sel, 11'b0, start_game};
      default:
        data_nxt = 16'b0;
    endcase
  end

endmodule
