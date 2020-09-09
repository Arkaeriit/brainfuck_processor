
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
    wire [3:0] probe;

    brainfuckCore brainfuckCore(clk, reset, code_out, data_in, addr_code, addr_array, data_out, write_rq, probe);
    ramDualAccess ramDualAccess(clk, reset, addr_array, data_out, write_rq, addr_array, data_in);
    testRom1 testRom1(clk, addr_code[3:0], code_out);

    initial
        begin
            #10;
            reset = 1;
            #200;
            $finish;
        end

    initial
        $monitor("Clk:%h, reset:%h, data_in:%h, data_out:%h, addr:%h, addr_code:%h, code:%c, probe:%h, write_rq:%h", clk, reset, data_in, data_out, addr_array, addr_code, code_out, probe, write_rq);

endmodule

