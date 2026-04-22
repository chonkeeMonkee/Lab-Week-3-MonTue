module pwm(
    input clk,
    input logic [3:0] duty_cycle,

    output LED
);

logic [3:0] pwm_clk_count = 0; 

always @ (posedge clk) begin 
    if (pwm_clk_count < duty_cycle)begin
        LED <= 1; 
    end else begin
        LED <= 0;
    end

    if (pwm_clk_count == 10) begin
        pwm_clk_count <= 0;
    end else begin
        pwm_clk_count <= pwm_clk_count + 1; 
    end
end

endmodule