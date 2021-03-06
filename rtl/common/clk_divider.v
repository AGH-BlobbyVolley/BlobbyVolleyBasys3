`timescale 1ns / 1ns
/******************************************************************************
 * (C) Copyright 2016 AGH UST All Rights Reserved
 *
 * MODULE:    clk_divider
 * DEVICE:    general
 * PROJECT:   stopwatch
 *
 * ABSTRACT:  The clock divider module. Assuming 100MHz input clock
 *
 * HISTORY:
 * 1 Jan 2016, RS - initial version
 * 20 Jan 2020, SK - added FREQ and DIVISOR parameter
 * 23 Jan 2020, SK - added SRC_FREQ
 *******************************************************************************/
module clk_divider
    # ( parameter
        FREQ = 100, // output divided clock frequency in Hz
        SRC_FREQ = 100_000_000 //source clock frequency in Hz
    )
    (
        input  wire clk_in, // input clock 100 MHz
        input  wire rst,       // async reset active high
        output reg  clk_div,    // output clock
        output reg rst_d,
		output reg [clog2((SRC_FREQ / FREQ)/2)-1:0]	count
    );
    // how many times clk_in should be divided
    localparam DIVISOR = SRC_FREQ / FREQ;
    // when the counter should restart from zero
    localparam LOOP_COUNTER_AT = DIVISOR / 2 ;

    reg rst_d_nxt;
    //reg [clog2(LOOP_COUNTER_AT)-1:0] count;

    always @(posedge(clk_in))
    begin
        if(rst) rst_d <= 1;
        else rst_d <= rst_d_nxt;
    end

    always @*
    begin
        if(clk_div==1'b1) rst_d_nxt <= 0;
        else rst_d_nxt <= rst_d;
    end

    always @( posedge(clk_in), posedge(rst) )
    begin

        if(rst)
        begin : counter_reset
            count   <= #1 0;
            clk_div <= #1 1'b0;
        end

        else
        begin : counter_operate

            if (count == (LOOP_COUNTER_AT - 1))
            begin : counter_loop
                count   <= #1 0;
                clk_div <= #1 ~clk_div;
            end

            else
            begin : counter_increment
                count   <= #1 count + 1;
                clk_div <= #1 clk_div;
            end

        end
    end

    // function to calculate number of bits necessary to store the number
    // (ceiling of base 2 logarithm)
    function integer clog2(input integer number);
        begin
            clog2 = 0;
            while (number)
            begin
                clog2  = clog2 + 1;
                number = number >> 1;
            end
        end
    endfunction
endmodule
