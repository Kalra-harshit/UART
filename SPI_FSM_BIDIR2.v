`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.06.2025 16:09:44
// Design Name: 
// Module Name: SPI_FSM_BIDIR2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////








module SPI_FSM_BIDIR2 (
    input clk, rst,
    input mode_select,      // 1 = Master, 0 = Slave
    input enable,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg done,
    output MOSI,            // Driven only by master
    input MISO,             // Master receives
    output reg SCLK,
    output reg SS,
    output reg MISO_out     // Slave drives this
);

    reg [2:0] bit_cnt;
    reg [7:0] shift_reg_tx;
    reg [7:0] shift_reg_rx;
    reg [1:0] state;

    reg mosi_internal;
    assign MOSI = (mode_select) ? mosi_internal : 1'bz;

    localparam IDLE     = 2'b00;
    localparam START    = 2'b01;
    localparam TRANSFER = 2'b10;
    localparam DONE     = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            mosi_internal <= 0;
            SCLK <= 0;
            SS <= 1;
            done <= 0;
            bit_cnt <= 0;
            shift_reg_tx <= 0;
            shift_reg_rx <= 0;
            data_out <= 0;
            MISO_out <= 1'bZ;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    SCLK <= 0;
                    bit_cnt <= 3'd7;
                    if (enable) begin
                        shift_reg_tx <= data_in;
                        SS <= 0;
                        state <= START;
                    end
                end

                START: begin
                    SCLK <= 0;
                    mosi_internal <= shift_reg_tx[bit_cnt];
                    if (!mode_select)
                        MISO_out <= shift_reg_tx[bit_cnt];
                    state <= TRANSFER;
                end

                TRANSFER: begin
                    SCLK <= 1;
                    if (mode_select) begin
                        shift_reg_rx[bit_cnt] <= MISO;  // Master samples MISO
                    end else begin
                        shift_reg_rx[bit_cnt] <= MOSI;  // Slave samples MOSI
                    end
                    state <= DONE;
                end

                DONE: begin
                    SCLK <= 0;
                    if (bit_cnt == 0) begin
                        data_out <= shift_reg_rx;
                        done <= 1;
                        state <= IDLE;
                        SS <= 1;
                        if (!mode_select)
                            MISO_out <= 1'bZ;  // Only slave releases MISO
                    end else begin
                        bit_cnt <= bit_cnt - 1;
                        mosi_internal <= shift_reg_tx[bit_cnt - 1];
                        if (!mode_select)
                            MISO_out <= shift_reg_tx[bit_cnt - 1];
                        state <= TRANSFER;
                    end
                end
            endcase
        end
    end
endmodule
