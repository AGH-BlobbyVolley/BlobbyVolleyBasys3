/*--------------------------------------*/
/*      AUTHOR - Stanisław Klat         */
/*--------------------------------------*/

`timescale 1ns / 1ps

module reset (
	input wire rst,
	input wire pclk,
	output reg delay_rst
	);
	
	reg [1:0] delay_counter;
	reg [1:0] delay_counter_nxt;
	reg delay_int_nxt, delay_int, delay_int2, delay_int3;
	wire temp;
	
	assign temp = ~rst;
	
	always @(posedge pclk) begin
		delay_rst <= delay_int3;
		delay_int3 <= delay_int2;
		delay_int2 <= delay_int;
	end

	always @*
	    begin
		if(&delay_counter)            delay_int_nxt = 0;
		else if(~temp && ~|delay_counter) delay_int_nxt = 1;
	    else                          delay_int_nxt = delay_int;
	    end
	
	always @(posedge pclk, posedge temp)  begin
        if(temp)	begin
            delay_int <= 0;
            delay_counter <= 0;
        end
        else begin
            delay_int <= delay_int_nxt;
            delay_counter <= delay_counter_nxt;
        end
	end
	
	always @* begin
	   if(rst && ~&delay_counter) delay_counter_nxt = delay_counter + 1;
	   else delay_counter_nxt = delay_counter;
	end
	
endmodule