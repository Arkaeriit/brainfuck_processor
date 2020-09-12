
module loader_tb();

    reg clk = 0;
    always #1 clk = !clk;
    reg reset = 0;
    
    // external world -> loader
    reg newData = 0;      
    reg [7:0] dataIn = 0;

    // loader -> ram
    wire [7:0] data;
    wire [5:0] addr;
    wire write_rq;

    // ram -> external world
    wire [7:0] dataOut;
    reg [5:0] addr_out = 0;

    loader #(6) loader(clk, reset, dataIn, newData, write_rq, addr, data);
    ramDualAccess #(6, 8) ramDualAccess(clk, reset, addr, data, write_rq, addr_out, dataOut);

    initial
    begin
        #100;
        reset = 1;
        #100;
        dataIn = 7;
        newData = 1;
        #10;
        newData = 0;
        #100;
        dataIn = 8;
        newData = 1;
        #10;
        newData = 0;
        #100;
        dataIn = 18;
        newData = 1;
        #10;
        newData = 0;
        #100;
        dataIn = 22;
        newData = 1;
        #10;
        newData = 0;
        #100;
        dataIn = 77;
        newData = 1;
        #10;
        newData = 0;
        #100;
        dataIn = 123;
        newData = 1;
        #10;
        newData = 0;
        #100;
        dataIn = 124;
        newData = 1;
        #10;
        newData = 0;
    end

endmodule

