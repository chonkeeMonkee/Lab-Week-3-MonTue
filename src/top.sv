`include "src/clock_divider.sv"
`include "src/decoder.sv"
`include "src/buttonSM.sv"
`include "src/pwm.sv"

module top (
    /** Input Ports */
    input clk, 
    input button1, 
    input button2,
    input seg_display, 
    /** Output Ports */
    output wire LED1,
    output wire LED2, 
    output logic [7:0] seg7
);

clock_divider divider(
    .clk(clk),
    .new_clk(sm_clock)
);

decoder decode(
    .bcd(passDisplay),
    .seg7(seg7[6:0])
);

buttonSM leftButton(
    .clk(sm_clock),
    .button(button1),
    .Hval(duty_cycle_1)
);

buttonSM rightButton(
    .clk(sm_clock),
    .button(button2),
    .Hval(duty_cycle_2)
);

pwm left(
    .clk(clk),
    .duty_cycle(duty_cycle_1),
    .LED(LED1)
);

pwm right(
    .clk(clk),
    .duty_cycle(duty_cycle_2),
    .LED(LED2)
);

wire sm_clock;
logic [3:0] passDisplay; 
logic [3:0] duty_cycle_1; 
logic [3:0] duty_cycle_2; 

always @(*) begin
    if (seg_display) begin
        passDisplay <= duty_cycle_2;
        seg7[7] = 1'b0;
    end else begin
        passDisplay <= duty_cycle_1;
        seg7[7] = 1'b1;
    end
end

endmodule