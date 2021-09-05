`timescale 1ns / 1ps
module judge(
	    input wire clk, 
	    input wire rst,
	    input wire gnd_col,
	    input wire [11:0] yposball,
	    input wire [11:0] xposball,
        input wire collisionsplayer1,
	    input wire collisionsplayer2,
        output reg [3:0] score_player1, 
        output reg [3:0] score_player2,
        output reg thirdtouched,
        output reg flag_point,
        output reg endgame

 
    );
   
   reg [8:0] timer, timer_nxt; 
   wire clk_div, rst_d;
   reg thirdtouched_nxt;
   //reg sideofball_nxt; //0-player1 , 1 player2
   reg endgame_nxt;
   reg flag_point_nxt; //0-player1 , 1 player2
   reg [3:0] score_player1_nxt,score_player2_nxt;
   reg [3:0] state,state_nxt; 
   reg [2:0] touchedplayer1 , touchedplayer1_nxt , touchedplayer2,touchedplayer2_nxt;
   wire timer_done;
   reg [24:0] counter, counter_nxt;
   //100hz
   clk_divider 
   #(.FREQ(100), .SRC_FREQ(65_000_000)) 
    my_clk_divider (
        .clk_in(clk),
        .clk_div(clk_div),
        .rst(rst),
        .rst_d(rst_d)
    );
    
  
    
    localparam  PLAYINGFIELD1 = 500,
                    PLAYINGFIELD2 = 523,
                        GROUND_POSITION=750;
                    
    localparam   START = 4'b1000,
                    WAIT = 4'b1100,
                    POINT = 4'b0001,
                        GAMECONT = 4'b0010,
                            ENDGAME = 4'b0100;
    
                            
    always @(posedge clk ) begin
        if(rst_d)begin
            score_player1<=4'b0000;
            score_player2<=0;
            flag_point<=1'b0;
            endgame<=1'b0;
            state<=START;
            touchedplayer1<=0;
            touchedplayer2<=0;
            thirdtouched<=0;
            counter <= 0; 
        end
        else begin 
            score_player1<=score_player1_nxt;
            score_player2<=score_player2_nxt;
            flag_point<=flag_point_nxt;
            endgame<=endgame_nxt;
            state<=state_nxt;
            touchedplayer1<=touchedplayer1_nxt;
            touchedplayer2<=touchedplayer2_nxt;
            thirdtouched<=thirdtouched_nxt;
            counter <= counter_nxt;
        
        end 
    end
    
    
    always @* begin 
        case(state)
            GAMECONT:begin 
                if (gnd_col || touchedplayer1 == 4 || touchedplayer2 == 4 ) state_nxt = POINT;
                else state_nxt = GAMECONT;
            end
            WAIT:begin
                if(timer_done)  
                    state_nxt = START;
                else 
                    state_nxt = WAIT;
            end
            POINT: begin  
                state_nxt = WAIT;     
            end  
            ENDGAME: begin  
                state_nxt=state;   
            end
            START: begin  
                if(score_player1==15 ||score_player2==15)state_nxt = ENDGAME;
                else if( collisionsplayer1 == 1 || collisionsplayer2 == 1) state_nxt = GAMECONT; // player 1 - 0 ; player 2 to 1 
                else state_nxt = START;          
            end        
            default: state_nxt=state;
        endcase
    end 
    
    assign timer_done = (timer==9'd255);
    
    
      always @(posedge clk_div)
    begin
      if(rst_d)
        timer <= 0;
      else
        timer <= timer_nxt;
    end
  
    always @*
    begin
      case(state)
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
    
    
    always @* begin
        touchedplayer1_nxt = touchedplayer1;     
        touchedplayer2_nxt = touchedplayer2;     
        score_player2_nxt=score_player2;         
        score_player1_nxt=score_player1;         
        flag_point_nxt= flag_point; 
        endgame_nxt =  endgame; 
        thirdtouched_nxt=thirdtouched; 
        counter_nxt = counter ;
         case(state)
            GAMECONT : begin  //licznik kolizji
                counter_nxt = ( counter == 24'hF7F490 ) ? 0 : ( (counter == 0 && (collisionsplayer1 || collisionsplayer2)) || counter != 0  )? counter + 1 : counter; 
                touchedplayer1_nxt = ( collisionsplayer1 && counter == 0 )? touchedplayer1 + 1 : ( collisionsplayer2 && touchedplayer1 < 4  )? 0 : touchedplayer1;    
                touchedplayer2_nxt = ( collisionsplayer2 && counter == 0 )? touchedplayer2 + 1 : ( collisionsplayer1 && touchedplayer2 < 4  )? 0 : touchedplayer2;     
                thirdtouched_nxt = ( touchedplayer2 > 3 || touchedplayer1 > 3 )? 1 : 0;
            end
            POINT: begin
                counter_nxt = 0;
                flag_point_nxt =  ( touchedplayer2 == 4 || ( gnd_col &&  xposball > PLAYINGFIELD2 )) ? 0 :
                                    ( touchedplayer1 == 4 || ( gnd_col && xposball < PLAYINGFIELD1 )  )? 1 : flag_point ; 
                score_player2_nxt = (( touchedplayer1 == 4 || ( gnd_col && xposball < PLAYINGFIELD1) )&& flag_point == 1) ? score_player2 + 1 : score_player2;
                score_player1_nxt = (( touchedplayer2 == 4 ||  ( gnd_col && xposball > PLAYINGFIELD2 ) )&& flag_point == 0) ? score_player1 + 1 : score_player1;
            end
            START:begin
                touchedplayer1_nxt = 0;
                touchedplayer2_nxt = 0;
                thirdtouched_nxt=0;
            end
            ENDGAME:begin            
                endgame_nxt = 1;
            end
            default: begin
                touchedplayer1_nxt = touchedplayer1;     
                touchedplayer2_nxt = touchedplayer2;     
                score_player2_nxt=score_player2;         
                score_player1_nxt=score_player1;         
                flag_point_nxt= flag_point; 
                endgame_nxt =  endgame; 
                thirdtouched_nxt=thirdtouched;
                counter_nxt = counter ;           
            end
         endcase   
    end 
endmodule