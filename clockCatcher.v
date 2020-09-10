/*--------------------------------------------------------------\
|This module is ment to take a signal of an arbitrary length and|
|reduce it to a single pulse of a clock                         |
\--------------------------------------------------------------*/

module clockCatcher(
    input clk,
    input in,
    output reg out = 0);

    reg in_buff = 0;

    always @ (posedge clk)
        if(!in)
        begin
            in_buff = 0;
            out = 0;
        end
        else
        begin
            if(in_buff)
                out = 0;
            else
                if(in)
                begin
                    in_buff = 1;
                    out = 1;
                end
        end

endmodule        

