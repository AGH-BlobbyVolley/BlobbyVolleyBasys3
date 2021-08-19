`timescale 1ns / 1ps
module judge(
	    input wire clk, 
	    input wire rst,
	    input wire [11:0] yposball,
	    input wire [11:0] xposball,
	    input wire collisionsplayer1,
	    input wire collisionsplayer2,
        output reg [3:0] score_player1, 
        output reg [3:0] score_player2,
        //output reg sideofball
        output reg thirdtouched,
        output reg flag_point,
        output reg endgame
        
    );
    
   wire clk_div;
   reg thirdtouched_nxt;
   //reg sideofball_nxt; //0-player1 , 1 player2
   reg endgame_nxt;
   reg flag_point_nxt; //0-player1 , 1 player2
   reg score_player1_nxt,score_player2_nxt;
   reg [3:0] state,state_nxt; 
   reg [2:0] touchedplayer1 , touchedplayer1_nxt , touchedplayer2,touchedplayer2_nxt;
   //100hz
   clk_divider 
   #(.FREQ(100), .SRC_FREQ(65_000_000)) 
    my_clk_divider (
        .clk_in(clk),
        .clk_div(clk_div),
        .rst(rst)
    );
    
  
    
    localparam  PLAYINGFIELD1 = 500,
                    PLAYINGFIELD2 = 523,
                        GROUND_POSITION=750;
                    
    localparam   START = 4'b1000,
                    POINT = 4'b0001,
                        GAMECONT = 4'b0010,
                            ENDGAME = 4'b0100;
                            
    always @(posedge clk_div ) begin
        if(rst)begin
            score_player1<=0;
            score_player2<=0;
            flag_point<=1'b1;
            endgame<=1'bx;
            state<=START;
            touchedplayer1<=0;
            touchedplayer2<=0;
            thirdtouched<=0;
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
        
        end 
    end
    
    
    always @* begin 
        case(state)
            GAMECONT:begin 
                if (yposball == GROUND_POSITION || touchedplayer1 == 4 || touchedplayer2 == 4 ) state_nxt = POINT;
                else state_nxt = GAMECONT;
            end
           
            POINT: begin  
                if(score_player1==15 ||score_player2==15)state_nxt = ENDGAME;
                else state_nxt = START;     
            end  
            ENDGAME: begin  
                state_nxt=state;   
            end
            START: begin  
                if( collisionsplayer1 == 1 || collisionsplayer2 == 1) state_nxt = GAMECONT; // player 1 - 0 ; player 2 to 1 
                else state_nxt = START;          
            end        
            default: state_nxt=state;
        endcase
    end 
    
    always @* begin
        
         case(state)
            GAMECONT : begin  //licznik kolizji 
                touchedplayer1_nxt = ( collisionsplayer1 == 1 && xposball < PLAYINGFIELD1 + 24 && yposball != GROUND_POSITION )? touchedplayer1 + 1 : touchedplayer1;    
                touchedplayer2_nxt = ( collisionsplayer2 == 1 && xposball > PLAYINGFIELD2 - 24 && yposball != GROUND_POSITION )? touchedplayer2 + 1 : touchedplayer2;     
                endgame_nxt = endgame;
                score_player2_nxt=score_player2;
                score_player1_nxt=score_player1;
                flag_point_nxt = flag_point;
                thirdtouched_nxt = ( touchedplayer2 == 4 ||touchedplayer1 == 4 )? 1:0;
            end
            POINT: begin
                flag_point_nxt =  (( touchedplayer2 == 4 || (yposball == GROUND_POSITION && xposball > PLAYINGFIELD2 - 24 ))) ? 0 : 1;
                thirdtouched_nxt=thirdtouched;
                touchedplayer1_nxt= touchedplayer1;
                touchedplayer2_nxt= touchedplayer2;
                endgame_nxt =  endgame;
                //flag_point_nxt =  ( touchedplayer1 == 4 || (yposball == GROUND_POSITION && xposball < PLAYINGFIELD1 + 24 )) ? 1 : flag_point; 
                score_player2_nxt = (( touchedplayer1 == 4 || (yposball == GROUND_POSITION && xposball < PLAYINGFIELD1 + 24 ))&& flag_point == 1) ? score_player2 + 1 : score_player2;
                score_player1_nxt = (( touchedplayer2 == 4 || (yposball == GROUND_POSITION && xposball > PLAYINGFIELD2 - 24 ))&& flag_point == 0) ? score_player1 + 1 : score_player1;
            end
            START:begin
                touchedplayer1_nxt = 0;
                touchedplayer2_nxt = 0;
                endgame_nxt = 0;
                score_player2_nxt=score_player2;
                score_player1_nxt=score_player1;
                flag_point_nxt= flag_point;
                thirdtouched_nxt=0;
            end
            ENDGAME:begin
                touchedplayer1_nxt = touchedplayer1;                  
                touchedplayer2_nxt = touchedplayer2;                  
                score_player2_nxt=score_player2;         
                score_player1_nxt=score_player1;         
                flag_point_nxt= flag_point;              
                endgame_nxt = 1;
                thirdtouched_nxt=thirdtouched;
            end
            default: begin
                touchedplayer1_nxt = touchedplayer1;     
                touchedplayer2_nxt = touchedplayer2;     
                score_player2_nxt=score_player2;         
                score_player1_nxt=score_player1;         
                flag_point_nxt= flag_point; 
                endgame_nxt =  endgame; 
                thirdtouched_nxt=thirdtouched;           
            end
         endcase   
    end 
endmodule
