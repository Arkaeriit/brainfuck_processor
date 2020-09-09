
module brainfuckCore_tb1();
    
    reg clk = 0;
    always #1 clk = !clk;

    reg reset = 0;
    wire [8:0] addr_array;
    wire [8:0] addr_code;
    wire write_rq;
    wire [7:0] data_in;
    wire [7:0] data_out;
    wire [7:0] code_out;
    wire probe;

    brainfuckCore brainfuckCore(clk, reset, code_out, data_in, addr_code, addr_array, data_out, write_rq, probe);
    ramDualAccess ramDualAccess(clk, reset, addr_array, data_out, write_rq, addr_array, data_in);
    testRom2 testRom2(clk, addr_code[3:0], code_out);

    initial
        begin
            #10;
            reset = 1;
            #20;
            $finish;
        end

    initial
        $monitor("Clk:%h, reset:%h, data:%h, addr:%h, addr_code:%h, code:%c, probe:%h", clk, reset, data_out, addr_array, addr_code, code_out, probe);

endmodule

