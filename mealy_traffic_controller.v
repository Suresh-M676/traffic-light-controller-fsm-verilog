module mealy_traffic_controller (
    input  wire clk,
    input  wire reset,
    input  wire timer_done,
    output reg  A_red, A_yellow, A_green,
    output reg  B_red, B_yellow, B_green
);

localparam A_GREEN_PHASE = 1'b0;
localparam B_GREEN_PHASE = 1'b1;

reg state, next_state;

always @(posedge clk or posedge reset) begin
    if (reset)
        state <= A_GREEN_PHASE;
    else
        state <= next_state;
end

always @(*) begin
    next_state = state;
    if (timer_done) begin
        case (state)
            A_GREEN_PHASE: next_state = B_GREEN_PHASE;
            B_GREEN_PHASE: next_state = A_GREEN_PHASE;
            default:       next_state = A_GREEN_PHASE;
        endcase
    end
end

always @(*) begin
    A_red = 0; A_yellow = 0; A_green = 0;
    B_red = 0; B_yellow = 0; B_green = 0;
    case (state)
        A_GREEN_PHASE: begin
            if (timer_done) begin
                A_yellow = 1; B_red = 1;
            end
            else begin
                A_green = 1; B_red = 1;
            end
        end
        B_GREEN_PHASE: begin
            if (timer_done) begin
                A_red = 1; B_yellow = 1;
            end
            else begin
                A_red = 1; B_green = 1;
            end
        end
        default: begin
            A_red = 1; B_red = 1;
        end
    endcase
end

endmodule
