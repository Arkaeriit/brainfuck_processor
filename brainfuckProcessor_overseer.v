/*-------------------------------------------------\
|This module is used to link the brainfuckProcessor|
|to the IO of the Arty S7-50.                      |
\-------------------------------------------------*/

module brainfuckProcessor_overseer(
    input CLK12MHZ,
    input sw,
    input [1:0] btn,
    output [2:0] led_rgb,
    input rx,
    output tx);

    wire CLK1MHZ;
    clockDiviser #(12) cd(CLK12MHZ, CLK1MHZ);
    wire done;
    wire loading = sw; //The loading is controled by the sliding switch

    brainfuckProcessor #(10, 9) brainfuckProcessor( // 1 KiB de RAM et 512 B de code
    //brainfuckProcessor #(11, 10) brainfuckProcessor( // 2 KiB de RAM et 1 KiB de code
        CLK12MHZ, //Main clock at 12 MHz
        btn[1],   //The btn[1] is the main reset
        btn[0],   //The btn[0] is the core and RAM reset
        CLK1MHZ,  //The UART is at 1 MHz
        loading,
        rx,
        tx,
        done
    );

    assign led_rgb = {done, loading, !loading & !done}; //The led is green when loading, blue when processing and red when done

endmodule

