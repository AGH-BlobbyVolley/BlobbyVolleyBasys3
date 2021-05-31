`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2021 12:23:00
// Design Name: 
// Module Name: clk_divider
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


module clk_divider
    #( parameter
        FREQ   = 100, // bit width of the input/output data
        SRC_FREQ = 65_000_000  // number of clock cycles the data is delayed
    )
    (
        input wire rst,
        input wire clk_in,
        output reg clk_div
        
    );
    
      reg [30:0] counter=0;
  
      always @(posedge clk_in) begin
          counter = counter +1;
           if (counter ==650000) begin
              counter = 0;
              clk_div = !clk_div;
           end
      end
endmodule
