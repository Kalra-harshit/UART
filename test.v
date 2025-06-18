`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.06.2025 16:14:12
// Design Name: 
// Module Name: test
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





















module test;

    reg clk, rst, enable;
    reg mode_master, mode_slave;
    reg [7:0] master_data_in = 8'b10101010;
    reg [7:0] slave_data_in  = 8'b11001100;

    wire MOSI_line, SCLK_line, SS_line;
    wire [7:0] master_data_out, slave_data_out;
    wire done_master, done_slave;
    wire master_MISO_in;
    wire slave_MISO_out;
    wire MISO_line;

    // Fixed: MISO line correctly driven only by slave when selected
    assign MISO_line = (SS_line == 0) ? slave_MISO_out : 1'bz;
    assign master_MISO_in = MISO_line;

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        enable = 0;
        mode_master = 1;
        mode_slave = 0;

        #20 rst = 0;
        #10 enable = 1;

        // Wait long enough for transfer
        #300;

        $display("Master OUT = %b", master_data_out);
        $display("Slave  OUT = %b", slave_data_out);

        if (master_data_out == slave_data_in && slave_data_out == master_data_in)
            $display("? SUCCESS: SPI transfer correct");
        else
            $display("? ERROR: SPI transfer mismatch");

        $finish;
    end

    // Master instance
    SPI_FSM_BIDIR2 master (
        .clk(clk), .rst(rst),
        .mode_select(mode_master),
        .enable(enable),
        .data_in(master_data_in),
        .data_out(master_data_out),
        .done(done_master),
        .MOSI(MOSI_line),
        .MISO(master_MISO_in),
        .SCLK(SCLK_line),
        .SS(SS_line),
        .MISO_out()
    );

    // Slave instance
    SPI_FSM_BIDIR2 slave (
        .clk(clk), .rst(rst),
        .mode_select(mode_slave),
        .enable(enable),
        .data_in(slave_data_in),
        .data_out(slave_data_out),
        .done(done_slave),
        .MOSI(MOSI_line),
        .MISO(), 
        .SCLK(SCLK_line),
        .SS(SS_line),
        .MISO_out(slave_MISO_out)
    );

endmodule
