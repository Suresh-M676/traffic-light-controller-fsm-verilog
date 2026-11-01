module moore_traffic_controller (
    input  wire clk,
    input  wire reset,
    input  wire timer_done,
    output reg  A_red, A_yellow, A_green,
    output reg  B_red, B_yellow, B_green
);

parameter A_GREEN  = 2'b00;
parameter A_YELLOW = 2'b01;
parameter B_GREEN  = 2'b10;
parameter B_YELLOW = 2'b11;

reg [1:0] state, next_state;

always @(posedge clk or posedge reset) begin
    if (reset)
        state <= A_GREEN;
    else
        state <= next_state;
end

always @(*) begin
    next_state = state;
    if (timer_done) begin
        case (state)
            A_GREEN:  next_state = A_YELLOW;
            A_YELLOW: next_state = B_GREEN;
            B_GREEN:  next_state = B_YELLOW;
            B_YELLOW: next_state = A_GREEN;
            default:  next_state = A_GREEN;
        endcase
    end
end

always @(*) begin
    A_red = 0; A_yellow = 0; A_green = 0;
    B_red = 0; B_yellow = 0; B_green = 0;
    case (state)
        A_GREEN:  begin A_green  = 1; B_red   = 1; end
        A_YELLOW: begin A_yellow = 1; B_red   = 1; end
        B_GREEN:  begin A_red    = 1; B_green = 1; end
        B_YELLOW: begin A_red    = 1; B_yellow = 1; end
        default:  begin A_red    = 1; B_red   = 1; end
    endcase
end

endmodule
