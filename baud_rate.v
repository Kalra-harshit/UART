module uart_baud_gen #(
    parameter CLOCK_FREQ = 1_000_000,  // 1 MHz
    parameter BAUD_RATE  = 9600
)(
    input wire clk,
    input wire rst,
    output reg tick
);

    localparam integer TICK_COUNT = CLOCK_FREQ / BAUD_RATE;
    reg [$clog2(TICK_COUNT)-1:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            tick <= 0;
        end else if (counter == TICK_COUNT - 1) begin
            counter <= 0;
            tick <= 1;
        end else begin
            counter <= counter + 1;
            tick <= 0;
        end
    end

endmodule
