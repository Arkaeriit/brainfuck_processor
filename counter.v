/*-------------------------------------------\
|This module is  counter. When enabled,       |
|it will increase a gregister until a certain|
|value is reached. Then it will start again  |
|and send a pulse.                           |
\-------------------------------------------*/

module counter #(
    parameter max = 10
    )(
    input clk,
    input reset,
    input enable,
    output reg out = 0
    );

    reg [31:0] counter = 0;

    always @ (posedge clk)
        if(!reset)
        begin
            counter = 0;
            out = 0;    
        end
        else if(enable)
        begin
            if(counter == max - 1)
            begin
                counter = 0;
                out = 1;
            end
            else
            begin
                counter = counter + 1;
                out = 0;
            end
        end

endmodule

