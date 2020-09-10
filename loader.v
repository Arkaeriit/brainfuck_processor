/*-----------------------------------------------------------\
|This module is ment to transfer a message send in a parallel|
|format to a ram block                                       |
\-----------------------------------------------------------*/

module loader #(
    parameter addrSize = 9
    )(
    input clk,
    input reset,
    input [7:0] dataIn,
    input newData,
    output reg write_rq = 0,
    output reg [addrSize-1:0] addrOut = 0,
    output reg [7:0] dataOut = 0
    );

    reg newData_ark = 0;

    always @ (posedge clk)
        if(!reset)
        begin
            addrOut = 0;
            dataOut = 0;
            newData_ark = 0;
            write_rq = 0;
        end
        else
        begin
            if(newData)
            begin
                dataOut = dataIn;
                write_rq = 1;
                newData_ark = 1;
            end
            else
                if(newData_ark)
                begin
                    newData_ark = 0;
                    addrOut = addrOut + 1;
                end
        end

endmodule

