/*-------------------------------------\
|This module codes for a ram block with|
|separate input and output addresses   |
\-------------------------------------*/

module ramDualAccess
    #(parameter addrSize = 9,
    contentSize = 8
    )(
    input clk,
    input reset,
    input [addrSize-1:0] addr_in,
    input [contentSize-1:0] dataIn,
    input write_rq,
    input [addrSize-1:0] addr_out,
    output [contentSize-1:0] dataOut
    );
    
	integer i;

	// Declare memory 
	reg [7:0] memory_ram_d [(2**addrSize)-1:0];
	reg [7:0] memory_ram_q [(2**addrSize)-1:0];
	
	always @(posedge clk)
		if(!reset)
			for (i=0;i<(2**addrSize); i=i+1)
            begin
				memory_ram_q[i] = 0;
				memory_ram_d[i] = 0;
            end
		else
        begin
			for (i=0;i<(2**addrSize); i=i+1)
				 memory_ram_q[i] = memory_ram_d[i];
            if (write_rq)
                memory_ram_d[addr_in] = dataIn;
        end
        
   assign dataOut = memory_ram_q[addr_out];

endmodule

