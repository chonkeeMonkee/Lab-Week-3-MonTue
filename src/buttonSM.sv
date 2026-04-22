module buttonSM(
    input clk, 
    input button,

    output logic [3:0] Hval
);

typedef enum logic [2:0] {START, OFF, INCREMENT, HOLD } state_t;

state_t state = START;

always @ (posedge clk) begin
    case (state)
        START: begin
            Hval <= 0; 
            state <= OFF;
        end
        OFF: state <= state_t'(button ? INCREMENT : OFF);
        INCREMENT: begin
            Hval <= ((Hval == 10 ) ? 0: (Hval + 1));
            state <= HOLD;
        end
        HOLD: state <= state_t'(button ? HOLD : OFF);
        default: state <= START; 
    endcase
end

endmodule