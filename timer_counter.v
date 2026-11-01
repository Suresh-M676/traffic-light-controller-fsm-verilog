module timer_counter #(
    parameter MAX_COUNT = 10
)(
    input  wire clk,
    input  wire reset,
    input  wire enable,
    output reg  timer_done
);

reg [31:0] count;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count      <= 0;
        timer_done <= 0;
    end
    else if (enable) begin
        if (count == MAX_COUNT - 1) begin
            count      <= 0;
            timer_done <= 1;
        end
        else begin
            count      <= count + 1;
            timer_done <= 0;
        end
    end
    else begin
        count      <= 0;
        timer_done <= 0;
    end
end

endmodule
