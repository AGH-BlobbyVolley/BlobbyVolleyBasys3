`timescale 1ns / 1ps

module score(
    input wire rst,
    input wire pclk,
    input wire [7:0] char_pixel,
    input wire [7:0] char_pixel2,
    input wire       flag_point,
    input wire [3:0] bcd01,
    input wire [3:0] bcd02,
    input wire [3:0] bcd11,
    input wire [3:0] bcd12,
    input  wire [`VGA_BUS_SIZE-1:0] vga_in,   
    output wire [`VGA_BUS_SIZE-1:0] vga_out,
    output reg [3:0] char_line,
    output reg [6:0] char_code,
    output reg [6:0] char_code2
    );
    
    wire [11:0] hcount_buf;
    wire hsync_buf;
    wire hblnk_buf;
    wire [11:0]vcount_buf;
    wire vsync_buf;
    wire vblnk_buf;
    wire [11:0] rgb_buf;
    reg  [3:0] char_line_nxt;
    
    `VGA_SPLIT_INPUT(vga_in)
    `VGA_OUT_REG
    `VGA_MERGE_OUTPUT(vga_out)
    localparam  POSX = 1, 
                  POSY = 0,
                  POSX2 = 922, 
                  POSY2 = 0,
                  WIDTH = 100,
                  HEIGHT = 50,
                  COLOR = 12'hf_f_3;
                  
    delay #(.WIDTH(40), .CLK_DEL(2))
    my_delay
    (
        .din( { hcount_in, hs_in, hblnk_in, vcount_in, vs_in, vblnk_in, rgb_in } ),
        .dout({hcount_buf,hsync_buf,hblnk_buf,vcount_buf,vsync_buf,vblnk_buf, rgb_buf}),
        .rst(rst),
        .clk(pclk)
    );
    always @(posedge pclk) begin
        if (rst) begin
        hcount_out <= 0;
        hs_out <= 0;
        hblnk_out <= 0;
        vcount_out <= 0;
        vs_out <= 0;
        vblnk_out <= 0;
        char_line  <= 0;
        end
        else begin
        hcount_out <= hcount_buf;
        hs_out <= hsync_buf;
        hblnk_out <= hblnk_buf;
        vcount_out <= vcount_buf;
        vs_out <= vsync_buf;
        vblnk_out <= vblnk_buf;
        char_line  <= char_line_nxt;
        end
    end
    
    reg [11:0] rgb_out_char_nxt;
    
    always @(posedge pclk) begin
        if(rst) rgb_out <= 0;
        else rgb_out <= rgb_out_char_nxt;
    end
    reg [11:0] vcount_rect , hcount_rect,vcount_rect2 , hcount_rect2;
    reg [7:0]  char_xy_nxt,char_xy_nxt2;
    always  @* begin 
    
            char_line_nxt = vcount_in[5:2];
            if ((hcount_in >= POSX && hcount_in <=POSX+WIDTH)&&(vcount_in >= POSY && vcount_in <=POSY+HEIGHT))begin                            
                  if (char_pixel[8-hcount_buf[4:2]%8])
                      rgb_out_char_nxt = COLOR;
                  else
                      rgb_out_char_nxt = 12'h3BE; 
            end else if ((hcount_in >= POSX2 && hcount_in <=POSX2+WIDTH)&&(vcount_in >= POSY2 && vcount_in <=POSY2+HEIGHT))begin   
                  if (char_pixel2[8-hcount_buf[4:2]%8])                                                                         
                      rgb_out_char_nxt = COLOR;                                                                           
                  else                                                                                                    
                      rgb_out_char_nxt = 12'h3BE;                                                                       
           end else                                                                                                         
                      rgb_out_char_nxt = rgb_buf ;
              
            
    end
    
    reg [6:0] char_code_nxt;
    reg [6:0] char_code_nxt2;
    
     always @(posedge pclk)begin
               if (rst)
                   char_code<=0;
               else
                   char_code <= char_code_nxt;
     end 
     
     always @(posedge pclk)begin
               if (rst)
                   char_code2<=0;
               else
                   char_code2 <= char_code_nxt2;
     end 

    always @* begin
       
          case(hcount_in[6:5])
            2'b00 : begin 
                char_code_nxt = 7'h30+bcd11;
                    char_code_nxt2 = 7'h00;
                end 
            2'b01 : begin  
                char_code_nxt = 7'h30+bcd01;
                if (flag_point)
                    char_code_nxt2 = 7'h21;
                else
                    char_code_nxt2 = 7'h00;
            end
            2'b10 : begin
                char_code_nxt2 = 7'h30+bcd12;
                if (flag_point)  
                    char_code_nxt = 7'h00;
                else  
                    char_code_nxt = 7'h21;
            end
            default:begin
                char_code_nxt = 7'h00;
                char_code_nxt2 = 7'h30+bcd02;
            end
          endcase
                                  
    end
endmodule