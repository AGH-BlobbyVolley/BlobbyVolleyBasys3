/*--------------------------------------*/
/*      Modified by Szymon Irla         */
/*--------------------------------------*/

`timescale 1ns / 1ps
module bin2bcd (
        input  wire [3:0] bin,  // input binary number
        output reg  [3:0]  bcd0, // LSB
        output reg  [3:0]  bcd1// MSB
    );

    integer i;

    always @(bin)
    begin

        bcd0 = 0;
        bcd1 = 0;

        
        for ( i = 3; i >= 0; i = i - 1 )
        begin
            if( bcd0 > 4 ) bcd0 = bcd0 + 3;
            if( bcd1 > 4 ) bcd1 = bcd1 + 3;
            { bcd1[3:0], bcd0[3:0] } = { bcd1[2:0], bcd0[3:0],bin[i] };
        end

    end

endmodule
