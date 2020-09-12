/*-----------------------------------\
|A ROM with a small brainfuck program|
|The program is +[.+]>-[.-]          |
\-----------------------------------*/

module testRom1(
    input clk,
    input [3:0] addrIn,
    output reg [7:0] dataOut = 0
    );

    always @ (posedge clk)
        case (addrIn)
            4'h0 : dataOut = 8'h2B;
            4'h1 : dataOut = 8'h5B;
            4'h2 : dataOut = 8'h2E;
            4'h3 : dataOut = 8'h2B;
            4'h4 : dataOut = 8'h5D;
            4'h5 : dataOut = 8'h3E;
            4'h6 : dataOut = 8'h2D;
            4'h7 : dataOut = 8'h5B;
            4'h8 : dataOut = 8'h2E;
            4'h9 : dataOut = 8'h2D;
            4'hA : dataOut = 8'h5D;
            default : dataOut = 8'h00;
        endcase

endmodule

