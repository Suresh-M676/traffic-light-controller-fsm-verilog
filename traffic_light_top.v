module top_traffic_light (
    input  wire clk,
    input  wire reset,
    input  wire mode_sel,
    output wire A_red, A_yellow, A_green,
    output wire B_red, B_yellow, B_green
);

wire timer_done;
wire m_A_red, m_A_yellow, m_A_green;
wire m_B_red, m_B_yellow, m_B_green;
wire y_A_red, y_A_yellow, y_A_green;
wire y_B_red, y_B_yellow, y_B_green;

timer_counter #(.MAX_COUNT(10)) TIMER (
    .clk(clk),
    .reset(reset),
    .enable(1'b1),
    .timer_done(timer_done)
);

moore_traffic_controller MOORE (
    .clk(clk),
    .reset(reset),
    .timer_done(timer_done),
    .A_red(m_A_red),
    .A_yellow(m_A_yellow),
    .A_green(m_A_green),
    .B_red(m_B_red),
    .B_yellow(m_B_yellow),
    .B_green(m_B_green)
);

mealy_traffic_controller MEALY (
    .clk(clk),
    .reset(reset),
    .timer_done(timer_done),
    .A_red(y_A_red),
    .A_yellow(y_A_yellow),
    .A_green(y_A_green),
    .B_red(y_B_red),
    .B_yellow(y_B_yellow),
    .B_green(y_B_green)
);

assign A_red    = mode_sel ? y_A_red    : m_A_red;
assign A_yellow = mode_sel ? y_A_yellow : m_A_yellow;
assign A_green  = mode_sel ? y_A_green  : m_A_green;
assign B_red    = mode_sel ? y_B_red    : m_B_red;
assign B_yellow = mode_sel ? y_B_yellow : m_B_yellow;
assign B_green  = mode_sel ? y_B_green  : m_B_green;

endmodule
