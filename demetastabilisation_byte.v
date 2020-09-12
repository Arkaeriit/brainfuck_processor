
module demetastabilisation_byte(
    input clk,
    input [7:0] in,
    output [7:0] out
    );
        
    demetastabilisation demet_0(clk, in[0], out[0]);
    demetastabilisation demet_1(clk, in[1], out[1]);
    demetastabilisation demet_2(clk, in[2], out[2]);
    demetastabilisation demet_3(clk, in[3], out[3]);
    demetastabilisation demet_4(clk, in[4], out[4]);
    demetastabilisation demet_5(clk, in[5], out[5]);
    demetastabilisation demet_6(clk, in[6], out[6]);
    demetastabilisation demet_7(clk, in[7], out[7]);

endmodule

