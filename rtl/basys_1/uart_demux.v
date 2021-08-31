module uart_demux (
    input wire [15:0] data,
    input wire clk,
    input wire rst,
    output reg [11:0] pl2_posx,
    output reg [11:0] pl2_posy,
    input wire conv8to16valid
  );

  localparam  PL2_POSX = 4'h1,
              PL2_POSY = 4'h2,
              SYNC = 4'hF;
             


reg [11:0] pl1_posx_nxt, pl1_posy_nxt, pl2_posx_nxt,
            pl2_posy_nxt, ball_posx_nxt, ball_posy_nxt;
reg [3:0] pl1_score_nxt, pl2_score_nxt;
reg flag_point_nxt, end_game_nxt;

  always @(posedge clk)
  begin
    if(rst)
    begin
      pl2_posx <= 12'b0;
      pl2_posy <= 12'b0;
    end
    else
    begin
      pl2_posx <= pl2_posx_nxt;
      pl2_posy <= pl2_posy_nxt;
    end

  end

  always @*
  begin
    pl2_posx_nxt = pl2_posx;
    pl2_posy_nxt = pl2_posy;
    if(conv8to16valid)
      case(data[15:12])
        PL2_POSX:
          pl2_posx_nxt = data[11:0];
        PL2_POSY:
          pl2_posy_nxt = data[11:0];
      endcase
  end

  endmodule
