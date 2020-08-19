/*-------------------------------------\
|This module codes for a ram block with|
|separate input and output addresses   |
\-------------------------------------*/

module ramDualAccess
    #(parameter size = 512,
    addrSize = 9
    )(
    input clk,
    input [addrSize-1:0] addr_in,
    input [7:0] dataIn,
    input write_rq,
    input clear,
    input [addrSize-1:0] addr_out,
    output [7:0] dataOut
    );
    
	integer i;

	// Declare memory 
	reg [7:0] memory_ram_d [size-1:0];
	reg [7:0] memory_ram_q [size-1:0];
	
	always @(posedge clk)
		if (clear)
			for (i=0;i<size; i=i+1)
            begin
				memory_ram_q[i] = 0;
				memory_ram_d[i] = 0;
            end
		else
        begin
			for (i=0;i<size; i=i+1)
				 memory_ram_q[i] = memory_ram_d[i];
            if (write_rq)
                memory_ram_d[addr_in] = dataIn;
        end
        
   assign dataOut = memory_ram_q[addr_out];

endmodule


