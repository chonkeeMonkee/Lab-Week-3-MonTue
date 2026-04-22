module clock_divider(
    input wire clk,

    output wire new_clk
);

logic [63:0] clk_div_counter;

assign new_clk = clk_div_counter[16];

always_ff @ (posedge clk) begin
        clk_div_counter <= clk_div_counter + 1; 
end

endmodule