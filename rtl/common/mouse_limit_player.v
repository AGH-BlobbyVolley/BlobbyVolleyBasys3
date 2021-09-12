`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 15.05.2021 12:37:15
// Design Name:
// Module Name: mouse_limit_player
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module mouse_limit_player
  #(parameter PLAYER=1'b0)
   (
     input wire clk,
     input wire rst,
     input wire [11:0] xpos,
     input wire [11:0] ypos,
     input wire  click_mouse,


     output reg signed [11:0] xpos_limit,
     output reg [11:0] ypos_limit,
     output reg click_mouse_limit
   );
  localparam MAX_X_PLAYER= PLAYER ? 950: 430;
  localparam MIN_X_PLAYER= PLAYER ? 525 : 0;
  localparam MIN_X_PLAYER_MOD =  PLAYER ? MIN_X_PLAYER : 12'h8;
  localparam  PLAYER_XPOS_INIT = PLAYER ? 750 : 250;
  localparam GROUND_POSITION=679;
  localparam JUMP_POSITION=450;

  localparam MOVE = 3'b000;
  localparam CLICK =3'b001;
  localparam JUMPUP =3'b011;
  localparam UP =3'b010;
  localparam FALLDOWN =3'b110;
  localparam DOWN =3'b111;
  wire clk_div, rst_d;
  wire [11:0] xpos_int;
  reg signed [11:0] xpos_nxt;
  clk_divider
    #(.FREQ(100), .SRC_FREQ(65_000_000))
    my_clk_divider (
      .clk_in(clk),
      .clk_div(clk_div),
      .rst(rst),
      .rst_d(rst_d)
    );

  always @(posedge clk_div)
  begin
    if(rst_d)
      xpos_limit <= PLAYER_XPOS_INIT;
    else
      xpos_limit <= xpos_nxt;
  end

  reg [2:0] state, state_nxt;
  reg [11:-12] ypos_nxt;
  reg click_mouse_nxt;
  reg [41:0] v,v_nxt;
  always @(posedge clk_div)
  begin
    if(rst_d)
    begin
      ypos_limit <= GROUND_POSITION;
      click_mouse_limit <= 0;
      state <= MOVE;
      v <= 42'h200_0000_0000;
    end
    else
    begin
      ypos_limit <= ypos_nxt[11:0];
      click_mouse_limit <= click_mouse;
      state <= state_nxt;
      v <= v_nxt;
    end
  end

  assign xpos_int = xpos>12'hF ? (PLAYER==0 ? {xpos[11], xpos[11:1]} : {xpos[11], xpos[11:1]} + 12'd512) : 12'h9;

  always @*
  begin
    if((xpos_int<xpos_limit+$signed(12'hFFA)) && ((xpos_limit + $signed(12'h8)) >= $signed(MIN_X_PLAYER_MOD))) xpos_nxt =  xpos_limit + (state==MOVE ? 12'hFFC: 12'hFFE);
    else if((xpos_limit < xpos_int + $signed(12'hFFA)) && ((xpos_limit + $signed(12'h8)) < MAX_X_PLAYER)) xpos_nxt = xpos_limit + (state==MOVE ? 12'h6 : 12'h2);
    else xpos_nxt = xpos_limit;
  end

  //! fsm_extract
  always @*
  begin
    state_nxt = MOVE;
    ypos_nxt = (GROUND_POSITION<<12);
    v_nxt=v;
    case (state)
      MOVE:
      begin
        if (click_mouse )
        begin
          state_nxt = CLICK ;
          ypos_nxt = (GROUND_POSITION<<12);
          v_nxt=v;
        end
        else
        begin
          state_nxt = MOVE;
          ypos_nxt = (GROUND_POSITION<<12);
          v_nxt=v;
        end
      end
      CLICK:
      begin
        state_nxt = JUMPUP;
        ypos_nxt = (GROUND_POSITION<<12);
        v_nxt=42'h200_0000_0000;
      end
      JUMPUP:
      begin
        if ( ypos_limit > JUMP_POSITION)
        begin
          state_nxt = JUMPUP;
          v_nxt=v-2000;
          ypos_nxt = ((ypos_limit - (v>>38))<<12);
        end
        else
        begin
          state_nxt = UP;
          v_nxt=v;
          ypos_nxt = (ypos_limit<<12);
        end
      end
      UP:
      begin
        state_nxt = FALLDOWN;
        ypos_nxt = (ypos_limit<<12);
        v_nxt=v;
      end
      FALLDOWN:
      begin
        if(ypos_limit < GROUND_POSITION )
        begin
          state_nxt = FALLDOWN;
          v_nxt=v+2000;
          ypos_nxt = ((ypos_limit + (v>>38))<<12);
        end
        else
        begin
          state_nxt = DOWN;
          v_nxt=v;
          ypos_nxt = (ypos_limit<<12);
        end
      end
      DOWN:
      begin
        state_nxt = MOVE;
        v_nxt=0;
        ypos_nxt = (GROUND_POSITION<<12);
      end
    endcase
  end
endmodule
