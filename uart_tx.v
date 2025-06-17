module uart_tx (
    input wire clk,
    input wire rst,
    input wire [7:0] tx_data,
    input wire tx_start,
    input wire tick,
    output reg tx,
    output reg tx_busy
);

    reg [3:0] bit_index;
    reg [9:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1;
            tx_busy <= 0;
            bit_index <= 0;
            shift_reg <= 10'b1111111111;
        end else if (tx_start && !tx_busy) begin
            shift_reg <= {1'b1, tx_data, 1'b0};  // stop, data, start
            tx_busy <= 1;
            bit_index <= 0;
        end else if (tick && tx_busy) begin
            tx <= shift_reg[0];
            shift_reg <= shift_reg >> 1;
            bit_index <= bit_index + 1;
            if (bit_index == 9) begin
                tx_busy <= 0;
            end
        end
    end

endmodule
