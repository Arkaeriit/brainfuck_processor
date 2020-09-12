
module brainfuckCore_tb1();
    
    reg clk = 0;
    always #1 clk = !clk;

    reg reset = 0;
    wire [4:0] addr_array;
    wire [4:0] addr_code;
    wire write_rq;
    wire [7:0] data_in;  // ram  -> core
    wire [7:0] data_out; // core ->  ram
    wire [7:0] code_out; // rom  -> core
    wire [3:0] probe;   
    wire [7:0] sendedChar;
    wire sendingChar;
    reg [7:0] receivedChar = 0;
    reg receivingChar = 0;

    brainfuckCore #(5, 5) brainfuckCore(clk, reset, code_out, addr_code, data_in, addr_array, data_out, write_rq, receivingChar, receivedChar, sendingChar, sendedChar, probe);
    ramDualAccess #(5, 8) ramDualAccess(clk, reset, addr_array, data_out, write_rq, addr_array, data_in);
    testRom1 testRom1(clk, addr_code[3:0], code_out);

    initial
        begin
            #10;
            reset = 1;
            #15000;
            receivedChar = 8'h20;
            receivingChar = 1;
            #100;
            receivingChar = 0;
            //Uncomment to use with iverilog
            //$finish;
        end

    //Uncomment to use with iverilog
    /*initial
        $monitor("Clk:%h, reset:%h, data_in:%h, data_out:%h, addr:%h, addr_code:%h, code:%c, probe:%h, write_rq:%h", clk, reset, data_in, data_out, addr_array, addr_code, code_out, probe, write_rq);
    */

endmodule

