/*--------------------------------------------------------------------------\
|A standard UART transmiter. When receving a byte, the content              |
|of the byte will be put in data_rx and a pule will be send from            |
|receive_done. To send a byte the content of the byte must be put in data_tx|
|and a pulse of at least a UART clock cycle must be send to start_transmit. |
\--------------------------------------------------------------------------*/

module uart(
    input clk,
    input reset,
    input rx,
    output tx,
    input [7:0] data_tx,          //Data to be send throught tx
    output reg [7:0] data_rx = 0, //data received on rx
    output receive_done,          //Rise for a clock when a message is recieved
    input start_transmit          //When set to 1 we transmit the message
    );

    //registers to count the number of byte we are at
    reg [4:0] rx_count = 0;
    reg [4:0] tx_count = 0;

    // transmit
    reg tx_buzy = 0;
    reg tx_r = 1;
    assign tx = tx_r;

    always @(posedge clk)
        if(!reset)
        begin
            tx_count = 0;
            tx_buzy = 0;
            tx_r = 1;
        end
        else
            if(tx_buzy)
            begin
                if(tx_count == 0) //start bit
                begin
                    tx_r = 0;
                    tx_count = tx_count + 1;
                end
                else if(tx_count > 8) //end bit
                begin
                    tx_r = 1;
                    tx_count = 0;
                    tx_buzy = 0;
                end    
                else //data bits
                begin
                    tx_r = data_tx[tx_count - 1];
                    tx_count = tx_count + 1;
                end
            end
            else 
                if(start_transmit)
                    tx_buzy = 1;
                else //rest value : 1
                    tx_r = 1;
    
    //assign transmit_free = !tx_buzy //We could do this if we needed to check
    //if the transmission is possible
    
    //receive
    reg rx_buzy = 0;
    reg receive_done_r = 0;
    reg [7:0] data_rx_r = 0;
    assign receive_done = receive_done_r;
    wire not_reset = !reset;
    /*always @ (posedge receive_done, negedge not_reset)
        if(reset)
            data_rx = 0;
        else
            data_rx = data_rx_r;*/

    always @ (posedge clk)
        if(!reset)
        begin
            rx_buzy = 0;
            rx_count = 0;
            data_rx_r = 0;
            receive_done_r = 0;
            data_rx = 0;
        end
        else
            if(rx_buzy)
            begin
                if(rx_count < 8) //receiving the 8 bits
                    data_rx_r[rx_count] = rx;
                else
                begin // end of the transmission
                    receive_done_r = 1;
                    rx_buzy = 0;
                    data_rx = data_rx_r;
                end    
                rx_count = rx_count + 1;
            end
            else
                if(rx) //The message is ended for at least a clock cycle
                    receive_done_r = 0;
                else //We received the start bit
                begin
                    receive_done_r = 0;
                    rx_count = 0;
                    rx_buzy = 1;
                end
    
endmodule

