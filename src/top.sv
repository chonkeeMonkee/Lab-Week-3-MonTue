`include "src/clock_divider.sv"
`include "src/decoder.sv"

module top (
    /** Input Ports */
    input clk, 
    input button, 
    input button2,
    input seg_display, 
    /** Output Ports */
    output wire LED,
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


wire sm_clock;
logic [3:0] passDisplay; 
logic [3:0] duty_cycle = 0; 
logic [3:0] duty_cycle_2 = 0; 
logic [3:0] pwm_clk_count = 0; 

/** Logic */
typedef enum logic [2:0] {START, OFF, INCREMENT, HOLD } state_t;

state_t state = START;
state_t state2 = START; 

always @(posedge sm_clock) begin
    
    case (state)
        START: begin
            state <= OFF;
        end
        OFF: state <= state_t'(button ? INCREMENT : OFF);
        INCREMENT: begin
            duty_cycle <= ((duty_cycle == 10 ) ? 0: (duty_cycle + 1));
            state <= HOLD;
        end
        HOLD: state <= state_t'(button ? HOLD : OFF);
        default: state <= START; 
    endcase

    case (state2)
        START: begin
            state2 <= OFF;
        end
        OFF: state2 <= state_t'(button2 ? INCREMENT : OFF);
        INCREMENT: begin
            duty_cycle_2 <= ((duty_cycle_2 == 10 ) ? 0: (duty_cycle_2 + 1));
            state2 <= HOLD;
        end
        HOLD: state2 <= state_t'(button2 ? HOLD : OFF);
        default: state2 <= START; 
    endcase
end 

//pwm generator
always @ (posedge clk) begin
    if (pwm_clk_count < duty_cycle)begin
        LED <= 1; 
    end else begin
        LED <= 0;
    end

    if (pwm_clk_count < duty_cycle_2)begin
        LED2 <= 1; 
    end else begin
        LED2 <= 0;
    end

    if (pwm_clk_count + 1 == 11) begin
        pwm_clk_count <= 0;
    end else begin
        pwm_clk_count <= pwm_clk_count + 1; 
    end
end

always @(*) begin
    if (seg_display) begin
        passDisplay <= duty_cycle_2;
        seg7[7] = 1'b0;
    end else begin
        passDisplay <= duty_cycle;
        seg7[7] = 1'b1;
    end
end

endmodule