/*--------------------------------------\
|This is a wrapper around a block of RAM|
|making a stack.                        |
\--------------------------------------*/

module stack(
    parameter addrSize = 9,
    contentSize = 8
    )(
    input clk,
    input reset,
    input [7:0] dataIn,
    input write_rq,
    input read_rq,
    output [7:0] dataOut
    );

    reg [addrSize-1:0] addrIn = 0;
    reg [addrSize-1:0] addrOut = !0;

    always @ (posedge clk)
        if(!reset)
        begin
            addrIn = 0;
            addrOut = !0;
        end
        else
        begin
            if(read_rq)
                addrOut = addrOut + 1;
            if(write_rq)
                addrIn = addrIn + 1;
        end

    ramDualAccess #(addrSize, contentSize) ram(clk, reset, dataIn, write_rq, addrOut, dataOut);

endmodule

