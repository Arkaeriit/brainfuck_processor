/*---------------------------------------------------------\
|This module let a signal comming from a quick clock domain|
|be noticed from a slow clock domain.                      |
\---------------------------------------------------------*/

module clockCatcher(
    input clk,
    input in,
    input slowClk,
    output reg out
    );

    reg low_ark = 0;
    reg high_ark = 0;

    always @ (posedge clk)
        if(out)
        begin
            if(high_ark & low_ark & !in) //We have been detected and no input signal is given
            begin
                high_ark = 0;
                low_ark = 0;
                out = 0;
            end
            else
            begin
                if(!slowClk) // The signal is present when the slow clock is low
                    low_ark = 1;
                if(slowClk & low_ark) //We have been detected
                    high_ark = 1;
            end
        end
        else
        begin
            high_ark = 0;
            low_ark = 0;
            if(in)
                out = 1;
        end

endmodule

