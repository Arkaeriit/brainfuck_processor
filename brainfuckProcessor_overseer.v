/*-------------------------------------------------\
|This module is used to link the brainfuckProcessor|
|to the IO of the Arty S7-50.                      |
\-------------------------------------------------*/

module brainfuckProcessor_overseer(
    input CLK12MHZ,
    input sw,
    input [1:0] btn,
    output [2:0] led_rgb,
    output [3:0] led,
    input rx,
    output tx);

    wire uartEn;
    counter #(12) cnt(CLK12MHZ, 1'b1, 1'b1, uartEn);
    wire done;
    
    //demetastabilisation
    wire loading; //The loading is controled by the sliding switch
    demetastabilisation demet0(CLK12MHZ, sw, loading);
    wire mainReset, coreReset;
    demetastabilisation demet1(CLK12MHZ, !btn[1], mainReset); //The btn[1] is the main reset
    demetastabilisation demet2(CLK12MHZ, !btn[0], coreReset); //The btn[0] is the core and RAM reset
    wire rx_demet;
    demetastabilisation demet3(CLK12MHZ, rx, rx_demet);

    brainfuckProcessor #(10, 9) brainfuckProcessor( // 1 KiB de RAM et 512 B de code
    //brainfuckProcessor #(11, 10) brainfuckProcessor( // 2 KiB de RAM et 1 KiB de code
        CLK12MHZ,  //Main clock at 12 MHz
        mainReset,   
        coreReset,   
        uartEn,    //The UART is at 1 MHz
        loading,
        rx_demet,
        tx,
        done,
        led
    );

    assign led_rgb = {!loading & !done, loading, done}; //The led is green when loading, blue when processing and red when done

endmodule

