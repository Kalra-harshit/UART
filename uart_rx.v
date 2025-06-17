module uart_rx (
    input wire clk,
    input wire rst,
    input wire rx,
    input wire tick,
    output reg [7:0] rx_data,
    output reg rx_done
);

    reg [3:0] bit_index;
    reg [7:0] data_shift;
    reg receiving = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rx_done <= 0;
            rx_data <= 8'h00;
            data_shift <= 0;
            bit_index <= 0;
            receiving <= 0;
        end else begin
            rx_done <= 0;

            if (!receiving && !rx) begin
                receiving <= 1;
                bit_index <= 0;
            end else if (receiving && tick) begin
                bit_index <= bit_index + 1;

                if (bit_index >= 1 && bit_index <= 8) begin
                    data_shift <= {rx, data_shift[7:1]};
                end else if (bit_index == 9) begin
                    rx_data <= data_shift;
                    rx_done <= 1;
                    receiving <= 0;
                end
            end
        end
    end

endmodule
