/*----------------------------------------------------------------\
|This module is used to divide the main clock into an other clock.|
\----------------------------------------------------------------*/

module clockDiviser #(
    parameter div = 12
    )(
    input clock_in,
    output clock_out
    );
    
    reg[27:0] counter=28'd0;

    always @(posedge clock_in)
    begin
        counter <= counter + 28'd1;
    if(counter>=(div-1))
        counter <= 28'd0;
    end

    assign clock_out = (counter<div/2)?1'b0:1'b1;

endmodule



/*--------------------------------------------------------------------------\
|Same as above but for dividing a periodic signal wich is not the main clock|
\--------------------------------------------------------------------------*/

module clockDiviser_sync
    #(parameter 
    div = 12 //the divisor
    )(
    input fast_clk,
    input clkIn,
    output clkOut
    //,output [5:0] probe
    );

    reg[27:0] counter = 28'h0;
    reg clkIn_buff = 0;

    always @ (posedge fast_clk)
        if(clkIn)
        begin
            if(!clkIn_buff)
            begin
                counter = counter + 1;
                clkIn_buff = 1;
                if(counter >= div)
                    counter = 0;
            end
        end
        else
            clkIn_buff = 0;

    assign clkOut = (counter<div/2)?1'b0:1'b1;

endmodule
    
