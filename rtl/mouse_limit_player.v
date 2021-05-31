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


module mouse_limit_player(
        input wire clk,
        input wire rst,
        input wire [11:0] xpos,
        input wire [11:0] ypos,
        input wire  click_mouse,
        
        
        output reg [11:0] xpos_limit,
        output reg [11:0] ypos_limit,
        output reg click_mouse_limit
    );
    localparam PLAYER1 = 0;
    localparam MAX_X_PLAYER1=500;
    localparam MIN_X_PLAYER1=0;
    localparam GROUND_POSITION=679;
    localparam JUMP_POSITION=350;
    
    localparam MOVE = 3'b000;
    localparam CLICK =3'b001;
    localparam JUMPUP =3'b011;
    localparam UP =3'b010;
    localparam FALLDOWN =3'b110;
    localparam DOWN =3'b111;
    wire clk_div;
    
    clk_divider
    #(.FREQ(100), .SRC_FREQ(65_000_000)) 
    my_clk_divider (
        .clk_in(clk),
        .clk_div(clk_div),
        .rst(rst)
    );
    
    reg [2:0] state, state_nxt;
    reg [11:0] xpos_nxt,ypos_nxt;
    reg click_mouse_nxt;
    reg [41:0] v,v_nxt;
    always @(posedge clk_div)begin
            if(rst) begin
                      xpos_limit <= MIN_X_PLAYER1;
                      ypos_limit <= GROUND_POSITION;
                      click_mouse_limit <= 0;
                      state <= MOVE;
                      v <= 42'h400_0000_0000;
                  end
              else begin
                      xpos_limit <= xpos_nxt;
                      ypos_limit <= ypos_nxt;
                      click_mouse_limit <= click_mouse;
                      state <= state_nxt;
                      v <= v_nxt;
             end
    end
    
    always @* begin 
          state_nxt = MOVE;
          xpos_nxt = xpos; 
          ypos_nxt = GROUND_POSITION;
          v_nxt=v;
          case (state)
               MOVE:begin 
               if (click_mouse )begin
                   state_nxt = CLICK ;
                   xpos_nxt = xpos_limit;
                   ypos_nxt = GROUND_POSITION;
                   v_nxt=v;
               end 
               else begin
                    if (( xpos > MIN_X_PLAYER1 ) && ( xpos < MAX_X_PLAYER1 ))begin
                        state_nxt = MOVE;
                        xpos_nxt = xpos; 
                        ypos_nxt = GROUND_POSITION;
                        v_nxt=v;
                    end
                    else if( xpos <= MIN_X_PLAYER1 )begin
                        state_nxt = MOVE;
                        xpos_nxt = MIN_X_PLAYER1;
                        ypos_nxt = GROUND_POSITION;
                        v_nxt=v;
                    end
                    else begin
                        xpos_nxt = MAX_X_PLAYER1;
                        state_nxt = MOVE;
                        ypos_nxt = GROUND_POSITION;
                        v_nxt=v;
                    end
                    end
               end
               CLICK:begin 
                    state_nxt = JUMPUP;
                    xpos_nxt = xpos_limit;
                    ypos_nxt = GROUND_POSITION;
                    v_nxt=42'h400_0000_0000;  
               end
              JUMPUP:begin 
                    if ( ypos_limit > JUMP_POSITION)begin
                        state_nxt = JUMPUP;
                        v_nxt=v-1000;
                        xpos_nxt = xpos_limit;
                        ypos_nxt = ypos_limit - (v>>38);
                    end
                    else begin
                        state_nxt = UP;       
                        v_nxt=v;
                        xpos_nxt = xpos_limit;                
                        ypos_nxt = ypos_limit;
                    end     
               end
               
                UP:begin 
                    state_nxt = FALLDOWN;
                    xpos_nxt = xpos_limit;
                    ypos_nxt = ypos_limit;
                    v_nxt=v;    
                end
                
                FALLDOWN:begin 
                    if(ypos_limit < GROUND_POSITION ) begin
                        state_nxt = FALLDOWN;
                        v_nxt=v+1000;
                        ypos_nxt = ypos_limit + (v>>38);
                        xpos_nxt = xpos_limit;  
                    end
                    else begin
                        state_nxt = DOWN;
                        v_nxt=v;                
                        ypos_nxt = ypos_limit;
                        xpos_nxt = xpos_limit;
                    end 
                end
                 UP:begin 
                        state_nxt = MOVE;
                        v_nxt=0;                
                        ypos_nxt = GROUND_POSITION;
                        xpos_nxt = xpos_limit;    
                 end
               default: begin
               end
           endcase
    end
endmodule
