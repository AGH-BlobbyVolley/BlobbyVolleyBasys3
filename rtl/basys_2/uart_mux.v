module uart_mux (
    input wire clk,
    input wire en,
    input wire [11:0] pl1_posx,
    input wire [11:0] pl1_posy,
    input wire [11:0] pl2_posx,
    input wire [11:0] pl2_posy,
    input wire [11:0] ball_posx,
    input wire [11:0] ball_posy,
    input wire [3:0] pl1_score,
    input wire [3:0] pl2_score,
    input wire flag_point,
    input wire end_game,
    output wire [15:0] data,
  );

  localparam  PL1_POSX = 4'h1,
              PL1_POSY = 4'h2,
              PL2_POSX = 4'h3,
              PL2_POSY = 4'h4,
              BALL_POSX = 4'h5,
              BALL_POSY = 4'h6,
              MATCH_CTRL = 4'h7;

wire [3:0] sel,sel_nxt;
wire [15:0] data_nxt;

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

  always @(posedge clk)
    begin
      if(rst)
      begin
        sel <= 0;
      end 
      else if(en)
          sel <= sel_nxt;
      else  
          sel <= sel; // sprawdzic!!
    end

  always @* begin 
      sel_nxt = (sel==4'h8)?  4'h0 : sel + 4'h1;  
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
