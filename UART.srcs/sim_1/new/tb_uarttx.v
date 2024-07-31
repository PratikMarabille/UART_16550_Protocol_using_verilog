`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2024 01:02:00
// Design Name: 
// Module Name: tb_uarttx
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


module tb_uarttx;

    // Parameters
    parameter clk_freq = 1000000;
    parameter baud_rate = 9600;

    // Testbench signals
    reg clk;
    reg rst;
    reg newd;
    reg [7:0] tx_data;
    wire tx;
    wire donetx;

    // Instantiate the UART transmitter
    uarttx #(
        .clk_freq(clk_freq),
        .baud_rate(baud_rate)
    ) uut (
        .clk(clk),
        .rst(rst),
        .newd(newd),
        .tx_data(tx_data),
        .tx(tx),
        .donetx(donetx)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // Test sequence
    initial begin
        // Initialize signals
        rst = 1;
        newd = 0;
        tx_data = 8'b0;

        // Reset the system
        #20;
        rst = 0;

        // Test case 1: Transmit a byte
        #20;
        tx_data = 8'b10101010; // Data to transmit
        newd = 1;
        #10;
        newd = 0;

        // Wait for the transmission to complete
        wait(donetx);
        #20;

        // Test case 2: Transmit another byte
        tx_data = 8'b11001100; // Data to transmit
        newd = 1;
        #10;
        newd = 0;

        // Wait for the transmission to complete
        wait(donetx);
        #20;

        // End of test
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time = %0t, rst = %b, newd = %b, tx_data = %b, tx = %b, donetx = %b", $time, rst, newd, tx_data, tx, donetx);
    end

endmodule

