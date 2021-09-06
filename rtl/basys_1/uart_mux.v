module uart_mux (
    input wire clk,
    input wire rst,
    input wire tx_done,
    input wire [11:0] pl1_posx,
    input wire [11:0] pl1_posy,
    input wire [11:0] ball_posx,
    input wire [11:0] ball_posy,
    input wire [3:0] pl1_score,
    input wire [3:0] pl2_score,
    input wire flag_point,
    input wire end_game,
    output reg [15:0] data,
    input wire whistle,
    input wire conv16to8ready
  );

  localparam  PL1_POSX = 4'h3,
              PL1_POSY = 4'h4,
              BALL_POSX = 4'h5,
              BALL_POSY = 4'h6,
              MATCH_CTRL = 4'h0;

  reg [3:0] sel, sel_nxt;

  always @(posedge clk)
  begin
    if(rst)
    begin
      sel <= 4'hF;
    end
    else
    begin
      sel <= sel_nxt;
    end
  end

  always @*
  begin
    sel_nxt = (tx_done & conv16to8ready) ? sel + 1 : sel;
  end
  reg [15:0] data_nxt;

  always @(posedge clk)
  begin
    if(rst)
    begin
      data <= 0;
    end
    else
    begin
      data <= data_nxt;
    end
  end

  always @*
  begin
    case(sel)
      PL1_POSX:
        data_nxt = {sel,pl1_posx};
      PL1_POSY:
        data_nxt = {sel,pl1_posy};
      BALL_POSX:
        data_nxt = {sel,ball_posx};
      BALL_POSY:
        data_nxt = {sel,ball_posy};
      MATCH_CTRL:
        data_nxt = {sel,1'b0,whistle,end_game,flag_point,pl2_score,pl1_score};
      default:
        data_nxt = {sel, 12'b0};
    endcase
  end

endmodule
