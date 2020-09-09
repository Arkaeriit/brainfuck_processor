/*-----------------------------------------------------\
|A brainfuck processor core. The code and the array are|
|assumed to be comming from two different blocks of RAM|
\-----------------------------------------------------*/

module brainfuckCore #(
    parameter addrSize = 9
    )(
    input clk,
    input reset,
    input [7:0] data_code,
    input [7:0] dataIn_array,
    output reg [addrSize-1:0] addr_code = 0,
    output reg [addrSize-1:0] addr_array = 0,
    output reg [7:0] dataOut_array = 0,
    output reg writeRq_array = 0
    ,output probe
    );

    reg ready = 1;

    always @ (posedge clk)
        if(!reset)
        begin
            ready = 1;
            addr_code = 0;
            addr_array = 0;
            dataOut_array = 0;
            writeRq_array = 0;
        end
        else
        begin
            case(data_code)
                // +
                8'h2B : 
                    if(ready)
                    begin
                        dataOut_array = dataIn_array + 1 ;
                        writeRq_array = 1;
                        addr_code = addr_code + 1;
                        ready = 0;
                    end
                    else
                        ready = 1;
                // -
                8'h2D : 
                    if(ready)
                    begin
                        dataOut_array = dataIn_array - 1;
                        writeRq_array = 1;
                        addr_code = addr_code + 1;
                        ready = 0;
                    end
                    else
                        ready = 1;
                // >
                8'h3E :
                    if(ready)
                    begin
                        addr_array = addr_array + 1;
                        writeRq_array = 0;
                        addr_code = addr_code + 1;
                        ready = 0;
                    end
                    else
                        ready = 1;
                // <
                8'h3C :
                    if(ready)
                    begin
                        addr_array = addr_array - 1;
                        writeRq_array = 0;
                        addr_code = addr_code + 1;
                        ready = 0;
                    end
                    else
                        ready = 1;
                default : writeRq_array = 0;
            endcase
        end

    //Debug
    assign probe = ready;

endmodule

