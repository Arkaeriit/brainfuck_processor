
module brainfuckProcessor_tb();
    
    reg sysClk = 0;
    always #1 sysClk = !sysClk;
    reg uartClk = 0;
    always #10 uartClk = !uartClk;

    reg extReset_full = 0;
    reg extReset_proc = 1;

    reg loading = 0;
    reg rx = 1;
    wire tx;
    wire done;
    wire [3:0] addrOut;

    brainfuckProcessor #(3, 4) brainfuckProcessor (sysClk, extReset_full, extReset_proc, uartClk, loading, rx, tx, done, addrOut);
    
    initial
    begin
        #100;
        extReset_full = 1;
        #100;
        loading = 1;
        #100;
        rx = 0; //sending 00101011 which is +
        #20;
        rx = 1;
        #20;
        rx = 1;
        #20;
        rx = 0;
        #20;
        rx = 1;
        #20;
        rx = 0;
        #20;
        rx = 1;
        #20;
        rx = 0;
        #20;
        rx = 0;
        #20;
        rx = 1;
        #20;
        rx = 0; //sending 01011011 which is [
        #20;
        rx = 1;
        #20;
        rx = 1;
        #20;
        rx = 0;
        #20;
        rx = 1;
        #20;
        rx = 1;
        #20;
        rx = 0;
        #20;
        rx = 1;
        #20;
        rx = 0;
        #20;
        rx = 1;
        #20;
        rx = 0; //sending 00101110 which is .
        #20;
        rx = 0;
        #20;
        rx = 1;
        #20;
        rx = 1;
        #20;
        rx = 1;
        #20;
        rx = 0;
        #20;
        rx = 1;
        #20;
        rx = 0;
        #20;
        rx = 0;
        #20;
        rx = 1;
        #20;
        rx = 0; //sending 00101011 which is +
        #20;
        rx = 1;
        #20;
        rx = 1;
        #20;
        rx = 0;
        #20;
        rx = 1;
        #20;
        rx = 0;
        #20;
        rx = 1;
        #20;
        rx = 0;
        #20;
        rx = 0;
        #20;
        rx = 1;
        #20;
        rx = 0; //sending 01011101 which is ]
        #20;
        rx = 1;
        #20;
        rx = 0;
        #20;
        rx = 1;
        #20;
        rx = 1;
        #20;
        rx = 1;
        #20;
        rx = 0;
        #20;
        rx = 1;
        #20;
        rx = 0;
        #20;
        rx = 1;
        #20;
        #200;
        loading = 0;
        #150000;
        extReset_proc = 0;
        #20;
        extReset_proc = 1;
    end

endmodule

