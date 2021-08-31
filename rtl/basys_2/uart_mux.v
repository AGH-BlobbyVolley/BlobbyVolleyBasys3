module uart_mux (
    input wire clk,
    input wire en,
    input wire [11:0] pl1_posx,
    input wire [11:0] pl1_posy,
    input wire [11:0] pl2_posx,
    input wire [11:0] pl2_posy,
    input wire start_game,
    //mux output
    output reg [15:0] data,
    input wire conv16to8ready
  );

  localparam  PL2_POSX = 4'h1,
              PL2_POSY = 4'h2,
              MATCH_CTRL = 4'h3;

wire [3:0] sel,sel_nxt;
wire [15:0] data_nxt;

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
    case(sel[3:0])
      begin
        PL1_POSX:
          data_nxt = {PL1_POSX,pl1_posx};
        PL1_POSY:
          data_nxt = {PL1_POSY,pl1_posy};
        PL2_POSX:
          data_nxt = {PL2_POSX,pl2_posx};
        PL2_POSY:
          data_nxt = {PL2_POSY,pl2_posy};
        BALL_POSX:
          data_nxt = {BALL_POSX,ball_posx};
        BALL_POSY:
          data_nxt = {BALL_POSY,ball_posy};
        MATCH_CTRL:
        begin
          data_nxt = {MATCH_CTRL,end_game,flag_point,pl2_score_nxt,pl1_score_nxt};
        end
      endcase
    end

  endmodule
