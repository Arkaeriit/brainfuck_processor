
module brainfuckCore_tb2();
    
    reg clk = 0;
    always #1 clk = !clk;

    reg reset = 0;
    wire [8:0] addr_array;
    wire [8:0] addr_code;
    wire done;
    wire write_rq;
    reg tx_ready = 1;
    wire [7:0] data_in;
    wire [7:0] data_out;
    wire [7:0] code_out;
    wire [3:0] probe;
    wire [7:0] sendedChar;
    wire sendingChar;
    reg [7:0] receivedChar = 0;
    reg receivingChar = 0;

    brainfuckCore #(5, 5) brainfuckCore(clk, reset, code_out, addr_code, done, data_in, addr_array, dataOut_array, write_rq, receivingChar, receivedChar, sendingChar, sendedChar, tx_ready/*, probe*/);
    ramDualAccess #(5, 8) ramDualAccess(clk, reset, addr_array, data_out, write_rq, addr_array, data_in);
    testRom2 testRom2(clk, addr_code[3:0], code_out);

    initial
        begin
            #10;
            reset = 1;
            #200;
            //Uncomment to use with iverilog
            //$finish;
        end

    //Uncomment to use with iverilog
    /*initial
        $monitor("Clk:%h, reset:%h, data_in:%h, data_out:%h, addr:%h, addr_code:%h, code:%c, probe:%h, write_rq:%h", clk, reset, data_in, data_out, addr_array, addr_code, code_out, probe, write_rq);
    */

endmodule

