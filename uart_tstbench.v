`timescale 1ns/1ps

module uart_tb;

    parameter CLOCK_FREQ = 1_000_000;
    parameter BAUD_RATE = 9600;

    reg clk = 0;
    reg rst = 1;

    reg tx_start = 0;
    reg [7:0] tx_data = 8'hA5;
    wire tx_busy, tx, tick;

    wire [7:0] rx_data;
    wire rx_done;

    // Generate 1MHz clock
    always #500 clk = ~clk;

    uart_baud_gen #(
        .CLOCK_FREQ(CLOCK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) baud_gen (
        .clk(clk),
        .rst(rst),
        .tick(tick)
    );

    uart_tx tx_inst (
        .clk(clk),
        .rst(rst),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tick(tick),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    uart_rx rx_inst (
        .clk(clk),
        .rst(rst),
        .rx(tx),
        .tick(tick),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    initial begin
        $dumpfile("uart_tb.vcd");
        $dumpvars(0, uart_tb);

        #2000;
        rst = 0;
        #2000;

        @(posedge clk);
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;

        wait(rx_done);
        #1000;
        

        $display("Transmitted: %h | Received: %h", tx_data, rx_data);
        #100000;
        $display("Tick = %b", tick);
        #100000;
         // Run until 10ms (10_000_000 ns)
        #10000000;
        $finish;
    end

endmodule
