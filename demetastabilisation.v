
module demetastabilisation(
    input clk,
    input in,
    output reg out
    );

    reg buff;
    always @ (posedge clk)
    begin
        out <= buff;
        buff <= in;
    end

endmodule

