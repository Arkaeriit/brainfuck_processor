
module brainfuckProcessor #(
    parameter addrSize_array = 9,
    addrSize_code = 9
    )(
    input sysClk,        // main clock
    input extReset_full, // exteral order for a complete reset
    input extReset_proc, // external order for a reset of the processing part
    input uartClk,       // clock for the uart module
    input loading,       // are we running the code or loading it
    input rx,            // uart input
    output tx,           // uart output
    output done          // tell if the end of the code is reached
    );

    // When we are activating the loading input we want a full reset
    reg loading_ark = 0;
    reg loading_pulse = 0;
    always @ (posedge sysClk)
        if(loading)
        begin
            if(loading_ark)
                loading_pulse = 0;
            else
            begin
                loading_pulse = 1;
                loading_ark = 1;
            end
        end
        else
            loading_ark = 0;

    wire sysReset = extReset_full & !loading_pulse;
    wire reset_proc = sysReset & !loading & extReset_proc;
    wire reset_load = sysReset & loading;

    //UART
    wire [7:0] data_tx;
    wire [7:0] data_rx;
    wire [7:0] data_rx_meta;
    wire receive_done, start_transmit, tx_ready, tx_ready_meta, receive_done_meta, sysReset_meta, start_transmit_meta;
    uart uart(uartClk, sysReset_meta, rx, tx, data_tx, data_rx_meta, receive_done_meta, start_transmit_meta, tx_ready_meta);
        
    //Clock domains linking
    demetastabilisation demet0(sysClk, receive_done_meta, receive_done);
    demetastabilisation demet1(sysClk, tx_ready_meta, tx_ready);
    demetastabilisation_byte deme2(sysClk, data_rx_meta, data_rx);
    clockCatcher cc1(sysClk, sysReset, uartClk, sysReset_meta);
    clockCatcher cc2(sysClk, start_transmit, uartClk, start_transmit_meta);

    //loader
    wire [7:0] data_loader;
    wire[addrSize_code-1:0] addrCode_loader;
    wire writeRq_loader;
    loader #(addrSize_code) loader(sysClk, reset_load, data_rx, receive_done, writeRq_loader, addrCode_loader, data_loader);

    //code ROM
    wire [7:0] codeOut;
    wire [addrSize_code-1:0] addrCode_proc;
    ramDualAccess #(addrSize_code, 8) codeRom(sysClk, sysReset, addrCode_loader, data_loader, writeRq_loader, addrCode_proc, codeOut);

    //array RAM
    wire [addrSize_array-1:0] addrAray;
    wire [7:0] dataIn_proc;
    wire [7:0] dataOut_proc;
    wire writeRq_proc;
    ramDualAccess #(addrSize_array, 8) arrayRam(sysClk, reset_proc, addrAray, dataOut_proc, writeRq_proc, addrAray, dataIn_proc);

    //processor core
    wire [7:0] data_tx_proc;
    wire start_transmit_proc;
    brainfuckCore #(addrSize_array, addrSize_code) brainfuckCore(sysClk, reset_proc, codeOut, addrCode_proc, done, dataIn_proc, addrAray, dataOut_proc, writeRq_proc, receive_done, data_rx, start_transmit_proc, data_tx_proc, tx_ready);

    //UART wiring
    assign data_tx = (loading ? data_rx : data_tx_proc); //When loading, we want a loop-back
    assign start_transmit = (loading ? receive_done : start_transmit_proc);

endmodule

