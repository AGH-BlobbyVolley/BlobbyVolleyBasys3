/*--------------------------------------*/
/*      AUTHOR - Szymon Irla            */
/*      AUTHOR - Stanisław Klat         */
/*--------------------------------------*/

`timescale 1 ns / 1 ps

module mouse_top(
  inout ps2_clk,
  inout ps2_data,
  input wire clk100MHz,
  input wire clk65MHz,
  input wire rst,
  input wire rst_d,
  input wire mousectl,
  output wire [11:0] xpos_mux,
  output wire [11:0] ypos_mux,
  output wire limit_mux,
  output wire [11:0] my_xpos_buf,
  output wire [11:0] my_ypos_buf,
  output wire my_mouse_left_buf
);

 wire [11:0] my_xpos,my_ypos;
 wire my_mouse_left;

 MouseCtl my_MouseCtl
  (
  .clk(clk100MHz),        
  .rst(rst),        
  .xpos(my_xpos),
  .ypos(my_ypos),      
  .zpos(),       
  .left(my_mouse_left),       
  .middle(),     
  .right(),      
  .new_event(),  
  .value(0),      
  .setx(1'b0),       
  .sety(1'b0),       
  .setmax_x(0),   
  .setmax_y(0),   
  .ps2_clk(ps2_clk),
  .ps2_data(ps2_data) 
  );

 wire [11:0] my_xpos_limit,my_ypos_limit;
 wire my_mouse_left_limit;

 assign xpos_mux = (mousectl) ? my_xpos_limit : 50 ;   
 assign ypos_mux = (mousectl) ? my_ypos_limit : 679 ;
 assign limit_mux = (mousectl) ? my_mouse_left_limit : 0 ;
 
 delay #(.WIDTH(25), .CLK_DEL(2)) my_buffor_signal_mouse( 
 .clk(clk65MHz),            
 .rst(rst_d),             
 .din({my_mouse_left, my_xpos, my_ypos}),  
 .dout({my_mouse_left_buf, my_xpos_buf, my_ypos_buf})
 );

   mouse_limit_player #(.PLAYER(1'b0)) my_mouse_limit_player(
 .clk(clk65MHz),            
 .rst(rst_d),                                    
 .xpos(my_xpos_buf),            
 .ypos(my_ypos_buf),            
 .click_mouse(my_mouse_left_buf),                   
 .xpos_limit(my_xpos_limit),      
 .ypos_limit(my_ypos_limit),      
 .click_mouse_limit(my_mouse_left_limit)
  );

endmodule