/*--------------------------------------*/
/*      AUTHOR - Stanisław Klat         */
/*--------------------------------------*/

module uart_demux (
    input wire [15:0] data,
    input wire clk,
    input wire rst,
    output reg [11:0] pl1_posx,
    output reg [11:0] pl1_posy,
    output reg [11:0] ball_posx,
    output reg [11:0] ball_posy,
    output reg [3:0] pl1_score,
    output reg [3:0] pl2_score,
    output reg flag_point,
    output reg end_game,
    output reg reset,
    output reg whistle_play,
    input wire conv8to16valid
  );

  localparam  PL1_POSX = 4'h3,
              PL1_POSY = 4'h4,
              BALL_POSX = 4'h5,
              BALL_POSY = 4'h6,
              MATCH_CTRL = 4'h0;



  reg [11:0] pl1_posx_nxt, pl1_posy_nxt, ball_posx_nxt, ball_posy_nxt;
  reg [3:0] pl1_score_nxt, pl2_score_nxt;
  reg flag_point_nxt, end_game_nxt,reset_nxt;
  reg whistle_play_nxt;

  always @(posedge clk)
  begin
    if(rst)
    begin
      pl1_posx <= 12'b0;
      pl1_posy <= 12'b0;
      ball_posx <= 12'b0;
      ball_posy <= 12'b0;
      pl1_score <= 4'b0;
      pl2_score <= 4'b0;
      flag_point <= 1'b0;
      end_game <= 1'b0;
      whistle_play <= 1'b0;
    end
    else
    begin
      pl1_posx <= pl1_posx_nxt;
      pl1_posy <= pl1_posy_nxt;
      ball_posx <= ball_posx_nxt;
      ball_posy <= ball_posy_nxt;
      pl1_score <= pl1_score_nxt;
      pl2_score <= pl2_score_nxt;
      flag_point <= flag_point_nxt;
      end_game <= end_game_nxt;
      whistle_play <= whistle_play_nxt;
    end

  end

  always @*
  begin
    whistle_play_nxt = whistle_play;
    pl1_posx_nxt = pl1_posx;
    pl1_posy_nxt = pl1_posy;
    ball_posx_nxt = ball_posx;
    ball_posy_nxt = ball_posy;
    pl1_score_nxt = pl1_score;
    pl2_score_nxt = pl2_score;
    flag_point_nxt = flag_point;
    end_game_nxt = end_game;
    if(conv8to16valid)
      case(data[15:12])
        PL1_POSX:
          pl1_posx_nxt = data[11:0];
        PL1_POSY:
          pl1_posy_nxt = data[11:0];
        BALL_POSX:
          ball_posx_nxt = data[11:0];
        BALL_POSY:
          ball_posy_nxt = data[11:0];
        MATCH_CTRL:
        begin
          pl1_score_nxt = data[3:0];
          pl2_score_nxt = data[7:4];
          flag_point_nxt = data[8];
          end_game_nxt = data[9];
          whistle_play_nxt = data[10];
        end
      endcase
  end

endmodule
