`timescale 1ns / 1ps

module reset (
	input wire rst,
	input wire pclk,
	output reg delay_rst
	);
	
	reg [1:0] delay_counter;
	reg [1:0] delay_counter_nxt;
	reg delay_rst_nxt;
	wire temp;
	
	assign temp = ~rst;
	
	always @*
	    begin
		if(&delay_counter)            delay_rst_nxt = 0;
		else if(~temp && ~|delay_counter) delay_rst_nxt = 1;
	    else                          delay_rst_nxt = delay_rst;
	    end
	
	always @(posedge pclk, posedge temp)  begin
        if(temp)	begin
            delay_rst <= 0;
            delay_counter <= 0;
        end
        else begin
            delay_rst <= delay_rst_nxt;
            delay_counter <= delay_counter_nxt;
        end
	end
	
	always @* begin
	   if(rst && ~&delay_counter) delay_counter_nxt = delay_counter + 1;
	   else delay_counter_nxt = delay_counter;
	end
	
endmodule