module uart_top #(parameter CLOCK_FREQ = 50000000, BAUD_RATE = 9600)(
    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,
    output tx,
    output tx_busy,
    output [7:0] rx_data,
    output rx_done
);

    wire tick;

    uart_baud_gen #(CLOCK_FREQ, BAUD_RATE) baud_gen (
        .clk(clk),
        .rst(rst),
        .tick(tick)
    );

    uart_tx tx_module (
        .clk(clk),
        .rst(rst),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tick(tick),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    uart_rx rx_module (
        .clk(clk),
        .rst(rst),
        .rx(tx),
        .tick(tick),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

endmodule
