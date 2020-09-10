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
    //debug
    ,output [3:0] probe
    );

    reg [1:0] until_ready = 1;
    //until_ready is the number of clock cycles until the next instruction is runable
    reg [1:0] browsing = 0;
    //For browsing, 
    // * 0 means usual behaviour,
    // * 1 means browsing the code left to right between [ and ]
    // * 2 means browsing the code right to left between ] and [
    // * 3 means that we reached a non usual code char, the end of the code
    reg [addrSize-1:0] crossedBrackets = 0; //Number of brackets we crossed while browsing

    always @ (posedge clk)
        if(!reset)
        begin
            until_ready = 1;
            addr_code = 0;
            addr_array = 0;
            dataOut_array = 0;
            writeRq_array = 0;
            browsing = 0;
            crossedBrackets = 0;
        end
        else
        begin
            if(until_ready)
                until_ready = until_ready - 1;
            else
                case(browsing)
                    2'b00:
                        case(data_code)
                            // +
                            8'h2B : 
                                begin
                                    dataOut_array = dataIn_array + 1 ;
                                    writeRq_array = 1;
                                    addr_code = addr_code + 1;
                                    until_ready = 2;
                                end
                            // -
                            8'h2D : 
                                begin
                                    dataOut_array = dataIn_array - 1;
                                    writeRq_array = 1;
                                    addr_code = addr_code + 1;
                                    until_ready = 2;
                                end
                            // >
                            8'h3E :
                                begin
                                    addr_array = addr_array + 1;
                                    writeRq_array = 0;
                                    addr_code = addr_code + 1;
                                    until_ready = 2;
                                end
                            // <
                            8'h3C :
                                begin
                                    addr_array = addr_array - 1;
                                    writeRq_array = 0;
                                    addr_code = addr_code + 1;
                                    until_ready = 2;
                                end
                            //[
                            8'h5B :
                                begin
                                    if(dataOut_array) //not 0, we keep going
                                    begin
                                        addr_code = addr_code + 1;
                                        until_ready = 2;
                                    end
                                    else //0, we go to the matching [
                                    begin
                                        browsing = 1;
                                        addr_code = addr_code + 1;
                                        until_ready = 2;
                                    end
                                end
                            //]
                            8'h5D :
                                begin
                                    if(!dataOut_array) //0, we keep going
                                    begin
                                        addr_code = addr_code + 1;
                                        until_ready = 2;
                                    end
                                    else //not 0, we go to the matching [
                                    begin
                                        browsing = 2;
                                        addr_code = addr_code - 1;
                                        until_ready = 2;
                                    end
                                end
                            
                            //null byte might means the end of the code, we stop
                            8'h00 : 
                                begin
                                    writeRq_array = 0;
                                    browsing = 3;
                                end
                            //not code, probabely a comment, we pass
                            default :
                                begin
                                    addr_code = addr_code + 1;
                                    writeRq_array = 0;
                                    until_ready = 2;
                                end
                        endcase
                    2'b01 :
                        begin
                            until_ready = 2;
                            addr_code = addr_code + 1;
                            if(data_code == 8'h5D)
                            begin
                                if(crossedBrackets)
                                    crossedBrackets = crossedBrackets - 1;
                                else
                                begin
                                    browsing = 0;
                                    addr_code = addr_code + 1;
                                end
                            end
                            else if(data_code == 8'h5B)
                                crossedBrackets = crossedBrackets + 1;
                        end
                    2'b10 :
                        begin
                            until_ready = -2;
                            addr_code = addr_code - 1;
                            if(data_code == 8'h5B)
                            begin
                                if(crossedBrackets)
                                    crossedBrackets = crossedBrackets - 1;
                                else
                                begin 
                                    browsing = 0;
                                    addr_code = addr_code + 1;
                                end
                            end
                            else if(data_code == 8'h5D)
                                crossedBrackets = crossedBrackets + 1;
                        end
                    2'b11 : writeRq_array = 0;
                endcase
        end

    //Debug
    //assign probe[0] = ready;
    //assign probe[2:1] = browsing;
    //assign probe[3:0] = crossedBrackets[3:0];
    assign probe[3:0] = {1'b0, 1'b0, 1'b0, until_ready == 0};

endmodule
