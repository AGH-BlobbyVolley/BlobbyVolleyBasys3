`timescale 1 ns / 1 ps

module ball_pos_ctrl(
    input wire rst,
    input wire clk,
    (* mark_debug = "true" *) input wire pl1_col,
    input wire pl2_col,
    input wire net_col,
    (* mark_debug = "true" *) input wire [11:0] pl1_posx,
    (* mark_debug = "true" *) input wire [11:0] pl1_posy,
    input wire [11:0] pl2_posx,
    input wire [11:0] pl2_posy,
    output wire gnd_col,
    output reg ovr_touch,
    output wire [11:0] ball_posx_out,
    output wire [11:0] ball_posy_out
  );

  reg pl1_col_d, pl1_col_d_nxt, pl2_col_d, pl2_col_d_nxt;
  wire [11:0] pl1_posx_int,  pl1_posy_int, pl2_posx_int,  pl2_posy_int;
  reg [3:0] ball_state, ball_state_nxt;
  wire clk100Hz;
  wire [18:0] div_count;

  clk_divider #(.FREQ(100), .SRC_FREQ(65_000_000)) my_clk_divider(
                .clk_in(clk),
                .rst(rst),
                .clk_div(clk100Hz),
                .count(div_count)
              );

  //extend collision to 1 cycle clk100Hz
  always @(posedge clk)
  begin
    if(rst)
      pl1_col_d <= 0;
    else
      pl1_col_d <= pl1_col_d_nxt;
  end

  always @(posedge clk)
  begin
    if(rst)
      pl2_col_d <= 0;
    else
      pl2_col_d <= pl2_col_d_nxt;
  end


  always @*
  begin
    if(pl1_col)
      pl1_col_d_nxt = 1;
    else if(ball_state==BOUNCE)
      pl1_col_d_nxt = 0;
    else
      pl1_col_d_nxt = (div_count==16'hFFFF && ~clk100Hz) ? 0 : pl1_col_d;
  end

  always @*
  begin
    if(pl2_col)
      pl2_col_d_nxt = 1;
    else if(ball_state==BOUNCE)
      pl2_col_d_nxt = 0;
    else
      pl2_col_d_nxt = (div_count==16'hFFFF && ~clk100Hz) ? 0 : pl2_col_d;
  end
  //

  localparam GND_LVL = 750;

  reg [7:0] timer, timer_nxt;
  wire timer_done;



  //rst delay for clk100Hz
  reg rst_d, rst_d_nxt;
  reg [19:0]rstd_timer, rstd_timer_nxt;

  always @*
  begin
    if(rst_d)
      rstd_timer_nxt = rstd_timer + 1;
    else
      rstd_timer_nxt = 0;
  end

  delay #(.WIDTH(48), .CLK_DEL(3)) my_delay_inst(
          .din({pl1_posx, pl1_posy, pl2_posx, pl2_posy}),
          .dout({pl1_posx_int, pl1_posy_int, pl2_posx_int, pl2_posy_int}),
          .clk(clk100Hz),
          .rst(rst_d)
        );

  always @(posedge clk)
  begin
    if(rst)
      rstd_timer <= 0;
    else
      rstd_timer <= rstd_timer_nxt;
  end

  always @*
  begin
    if(rst)
      rst_d_nxt = 1;
    else if(rstd_timer_nxt == 650_000)
      rst_d_nxt = 0;
    else
      rst_d_nxt = rst_d;
  end

  always @(posedge clk)
  begin
    rst_d <= rst_d_nxt;
  end

  //ball position

  (* mark_debug = "true" *) reg signed	[12:-7] ball_posx, ball_posx_nxt;
  (* mark_debug = "true" *) reg signed 	[12:-7] ball_posy, ball_posy_nxt;

  assign ball_posx_out = ball_posx[11:0];
  assign ball_posy_out = ball_posy[11:0];


  localparam 	signed 	PL_CENTER_POSX = 13'd38,
              PL_CENTER_POSY = 13'd70, //45
              BALL_CENTER_POS = 13'd32;

  reg signed	[12:-7] vel_x, vel_x_nxt;
  reg signed 	[12:-7] vel_y, vel_y_nxt;

  reg last_touch, last_touch_nxt;

  localparam	PLAYER1 = 1'b0,
             PLAYER2 = 1'b1;

  localparam	BALL_SIZE = 64;

  localparam	START_POSX_PL1 	= 12'd250,
             START_POSX_PL2 	= 12'd774,
             START_POSY 		= 12'd555;


  localparam 	HANG = 4'b0000,
              BOUNCE = 4'b0010,
              FLIGHT = 4'b0100,
              WAIT = 4'b1000;

  wire wall_col;

  

  always @(posedge clk100Hz)
  begin
    if(rst_d)
      ball_state <= HANG;
    else
      ball_state <= ball_state_nxt;
  end

//! fsm_extract
  always @*
  begin
    case(ball_state)
      HANG:
      begin
        if(pl1_col_d || pl2_col_d)
          ball_state_nxt=BOUNCE;
        else
          ball_state_nxt=HANG;
      end
      BOUNCE:
        if(ovr_touch)
          ball_state_nxt=WAIT;
        else
          ball_state_nxt=FLIGHT;
      FLIGHT:
      begin
        if((pl1_col_d || pl2_col_d) && ghost_time_done)
          ball_state_nxt=BOUNCE;
        else if(wall_col || net_col)
          ball_state_nxt=BOUNCE;
        else if(gnd_col)
          ball_state_nxt=WAIT;
        else
          ball_state_nxt=FLIGHT;
      end
      WAIT:
      begin
        if(timer_done)
          ball_state_nxt=HANG;
        else
          ball_state_nxt=WAIT;
      end
      default:
        ball_state_nxt=ball_state;
    endcase
  end
//

  localparam 	NON_COL = 3'b000,
              PL1_COL = 3'b001,
              PL2_COL = 3'b010,
              WALL_COL= 3'b011,
              GND_COL = 3'b100;


  reg [1:0] last_collision, last_collision_nxt;


  always @(posedge clk100Hz)
  begin
    if(rst_d)
      last_collision <= 2'b0;
    else
      last_collision <= last_collision_nxt;
  end

  always @*
  begin
    case(ball_state)
      HANG:
        last_collision_nxt = 	pl1_col_d ? PL1_COL :
          pl2_col_d ? PL2_COL : NON_COL;
      FLIGHT:
        last_collision_nxt = 	pl1_col_d ? PL1_COL :
          pl2_col_d ? PL2_COL :
            wall_col ? WALL_COL :
              GND_COL ? GND_COL : NON_COL;
      default:
        last_collision_nxt = last_collision;
    endcase
  end


  //checking collisions with objects
  assign wall_col = ((ball_posx_nxt[12:0] <= 5) || (ball_posx_nxt[12:0] >= 1018 - BALL_SIZE));
  assign gnd_col = (ball_posy_nxt[12:0] >= GND_LVL - BALL_SIZE) && ~ball_posy_nxt[12];

  //ball move
  always @(posedge clk100Hz)
  begin
    if(rst_d)
      ball_posx <= {START_POSX_PL1, 7'b0};
    else
      ball_posx <= ball_posx_nxt;
  end

  always @(posedge clk100Hz)
  begin
    if(rst_d)
      ball_posy <= {START_POSY, 7'b0};
    else
      ball_posy <= ball_posy_nxt;
  end

  always @*
  begin
    case(ball_state)
      HANG:
      begin
        ball_posx_nxt = {(last_touch==PLAYER1) ?  START_POSX_PL1 : START_POSX_PL2, 7'b0};
        ball_posy_nxt = {START_POSY, 7'b0};
      end
      FLIGHT:
      begin
        ball_posx_nxt = ball_posx + vel_x;
        ball_posy_nxt = ball_posy + ~vel_y + 1;
      end
      default:
      begin
        ball_posx_nxt = ball_posx;
        ball_posy_nxt = ball_posy;
      end
    endcase
  end

  always @(posedge clk100Hz)
  begin
    if(rst_d)
    begin
      vel_x <= 0;
      vel_y <= 0;
    end
    else
    begin
      vel_x <= vel_x_nxt;
      vel_y <= vel_y_nxt;
    end
  end

  wire [12:0] vel_x_calc, vel_y_calc;
  assign vel_x_calc = (~{1'b0, ((last_collision==PL1_COL) ? pl1_posx_int : pl2_posx_int)} +   ball_posx[12:0]  + (BALL_CENTER_POS + 1 - PL_CENTER_POSX));
  assign vel_y_calc = ( {1'b0, ((last_collision==PL1_COL) ? pl1_posy_int : pl2_posy_int)} + ~(ball_posy[12:0]) + (PL_CENTER_POSY + 1 - BALL_CENTER_POS));

  always @*
  begin
    case(ball_state)
      BOUNCE:
      begin
        case(last_collision)
          PL1_COL || PL2_COL:
          begin
            vel_x_nxt = vel_x_calc[12] ? {3'hF, vel_x_calc, 4'b0} : {3'h0, vel_x_calc, 4'b0};
            vel_y_nxt = vel_y_calc[12] ? {3'hF, vel_y_calc, 4'b0} : {3'h0, vel_y_calc, 4'b0};
          end
          WALL_COL:
          begin
            vel_x_nxt = ~vel_x + 1;
            vel_y_nxt = vel_y;
          end
          default:
          begin
            vel_x_nxt = vel_x;
            vel_y_nxt = vel_y;
          end
        endcase
      end
      FLIGHT:
      begin
        vel_x_nxt = vel_x;
        if(vel_y<=$signed(20'hFFE8F))
          vel_y_nxt = vel_y;
        else
          vel_y_nxt = vel_y  - 20'b10000; //+ 10'hFFF; - 1'b1
      end
      default:
      begin
        vel_x_nxt = 0;
        vel_y_nxt = 0;
      end
    endcase
  end

  //WAIT time counter

  always @(posedge clk100Hz)
  begin
    if(rst_d)
      timer <= 0;
    else
      timer <= timer_nxt;
  end

  always @*
  begin
    case(ball_state)
      WAIT:
      begin
        timer_nxt = timer + 1;
      end
      default:
      begin
        timer_nxt = 0;
      end
    endcase
  end

  assign timer_done = (timer==8'd250);

  //Ghost time counter

  reg [10:0] ghost_timer, ghost_timer_nxt;
  reg ghost_time_done;

  always @(posedge clk100Hz)
  begin
    if(rst_d)
      ghost_timer <= 0;
    else
      ghost_timer <= ghost_timer_nxt;
  end

  always @*
  begin
    case(ball_state)
      BOUNCE:
      begin
        ghost_time_done = 0;
        ghost_timer_nxt = 0;
      end
      FLIGHT:
      begin
        ghost_time_done = (ghost_timer=='d25);
        if(!ghost_time_done)
          ghost_timer_nxt = ghost_timer + 1;
        else
          ghost_timer_nxt = ghost_timer;
      end
      default:
      begin
        ghost_timer_nxt = 0;
        ghost_time_done = 0;
      end
    endcase
  end

  //

  always @(posedge clk100Hz)
  begin
    if(rst_d)
      last_touch <= PLAYER1;
    else
      last_touch <= last_touch_nxt;
  end

  always @*
  begin
    case(ball_state)
      BOUNCE:
      begin
        if(pl1_col_d)
          last_touch_nxt = PLAYER1;
        else if(pl2_col_d)
          last_touch_nxt = PLAYER2;
        else
          last_touch_nxt = last_touch;
      end
      default:
        last_touch_nxt = last_touch;
    endcase
  end

endmodule
