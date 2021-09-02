`timescale 1ns / 1ps

`include "_vga_macros.vh"


module menu(
        input wire  clk,
        input wire  rst,
        input  wire left,     
        input  wire [11:0] xpos,
        input  wire [11:0] ypos,
        input  wire enable_game,
        input  wire [`VGA_BUS_SIZE-1:0] vga_in_menu,   
        output wire [`VGA_BUS_SIZE-1:0] vga_out,
        output reg  mousecontrol,
        output  reg enable_menu
    );
    wire [7:0] char_xy,rgb_char;
    wire [6:0] char_code;
    wire [3:0] char_line;
    reg mousecontrol_nxt,enable_menu_nxt;  
    localparam 	WIDTH = 350,
                  POSY = 360,
                  POSX = 360,
                  COLOR = 12'hf_f_3, 
                  HEIGHT = 50;  
    wire [`VGA_BUS_SIZE-1:0] vga_bus [5:0];
        grey_out my_grey_out(
        .rst(rst),                         
        .pclk(clk),                        
        .char_pixel(rgb_char),
        .char_xy(char_xy),    
        .char_line(char_line),                      
        .vga_in(vga_in_menu),  
        .vga_out(vga_bus[0]) 
        );
      
       start_writing my_start_writing(
        .clk(clk),
        .rst(rst),
        .char_xy(char_xy),        
        .char_code(char_code)
        );
        
         font_rom start_font_rom(
          .clk(clk),
          .rst(rst),
          .addr({char_code,char_line}),
          .char_line_pixels(rgb_char)
          );   
    `VGA_SPLIT_INPUT(vga_bus[0])
    `VGA_OUT_WIRE
    `VGA_MERGE_OUTPUT(vga_bus[1])  
    
        MouseDisplay my_MouseDisplay(
                    .pixel_clk(clk),
                    .xpos(xpos),               
                    .ypos(ypos),
                    .hcount_in(hcount_in),         
                    .vcount_in(vcount_in),            
                    .vblnk_in(vblnk_in),
                    .hblnk_in(hblnk_in),           
                    .red_in(rgb_in[3:0]),   
                    .green_in(rgb_in[7:4]), 
                    .blue_in(rgb_in[11:8]),
                    .enable_mouse_display_out(),            
                    .red_out(rgb_out[3:0]),  
                    .green_out(rgb_out[7:4]),
                    .blue_out(rgb_out[11:8]),                    
                    .hcount_out(hcount_out),
                    .vcount_out(vcount_out),
                    .vsync_in(vs_in),
                    .hsync_in(hs_in),       
                    .vsync_out(vs_out),
                    .hsync_out(hs_out),         
                    .vblnk_out(vblnk_out),
                    .hblnk_out(hblnk_out)
        );


        always @(posedge clk) begin
            if(rst)begin
                mousecontrol<=0;
                enable_menu<=1;
            end
            else begin
                mousecontrol<= mousecontrol_nxt;
                enable_menu <= enable_menu_nxt;
            end
        
        end
        
        
        always @* begin
            if ( (xpos>=POSX && xpos<=POSX+WIDTH) && (ypos>=POSY && ypos<=POSY+HEIGHT)) begin 
                    if(left)begin
                        mousecontrol_nxt = 1;
                        enable_menu_nxt = 0;
                    end
                    else begin
                        mousecontrol_nxt = mousecontrol ;
                        enable_menu_nxt = enable_menu;             
                    end
            end else begin
                    mousecontrol_nxt = mousecontrol ;
                    enable_menu_nxt = enable_menu;                
            end

         end
    
    assign vga_out=vga_bus[1];
    //assign enable_menu=1;
endmodule
