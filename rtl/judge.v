`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2021 13:26:05
// Design Name: 
// Module Name: judge
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


module judge(
	    input wire clk, 
	    input wire rst,
	    input wire [11:0] yposball,
	    input wire [11:0] xposball,
	    input wire collisionsplayer1,
	    input wire collisionsplayer2,
        output reg [3:0] score_player1, 
        output reg [3:0] score_player2
    );
    
   wire clk_div;
   reg [3:0] state,state_nxt; 
   reg thirdtouched;
   reg [2:0] touched;
   clk_divider 
   #(.FREQ(100), .SRC_FREQ(65_000_000)) 
    my_clk_divider (
        .clk_in(clk),
        .clk_div(clk_div),
        .rst(rst)
    );
    
  
    
    localparam  PLAYINGFIELD1 = 500,
                    PLAYINGFIELD2 = 523,
                        GROUND_POSITION=679;
                    
    localparam   START = 4'b1000,
                    POINT = 4'b0001,
                        GAMECONT = 4'b0010,
                            ENDGAME = 4'b0100;
    always @* begin 
        case(state)
            GAMECONT:begin 
                if (yposball == GROUND_POSITION || thirdtouched == 1 ) state_nxt = POINT;
                else state_nxt = GAMECONT;
            end
           
            POINT: begin  
                if(score_player1==15 ||score_player2==15)state_nxt = ENDGAME;
                else state_nxt = START;     
            end  
            ENDGAME: begin  
                     
            end
            START: begin  
                if( collisionsplayer1 == 1 || collisionsplayer2 == 1) state_nxt = GAMECONT;
                else state_nxt = START;          
            end        
            default: state_nxt=state;
        endcase
    end 
    
    always @* begin 
         case(state)
            GAMECONT : begin  //licznik kolizji 
                if( collisionsplayer1 == 1  ) 
            end
         endcase   
    end 
endmodule
