`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2024 00:38:52
// Design Name: 
// Module Name: uart_tx
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


module uarttx
#(
    parameter clk_freq = 1000000,
    parameter baud_rate = 9600
)
(
    input clk,
    input rst,
    input newd,
    input [7:0] tx_data,
    output reg tx,
    output reg donetx
);

localparam clkcount = (clk_freq / baud_rate);

// Define states using localparam
localparam [1:0] idle = 2'b00,
                 start = 2'b01,
                 transfer = 2'b10,
                 stop = 2'b11;

integer count = 0;
integer bit_count = 0;

reg uclk = 0;
reg [1:0] state = idle;

reg [7:0] din;

// UART clock generator
always @(posedge clk) begin
    if (count < clkcount / 2) begin
        count <= count + 1;
    end else begin
        count <= 0;
        uclk <= ~uclk;
    end
end

// UART state machine
always @(posedge uclk or posedge rst) begin
    if (rst) begin
        state <= idle;
        tx <= 1'b1;
        donetx <= 1'b0;
        bit_count <= 0;
    end else begin
        case (state)
            idle: begin
                tx <= 1'b1; // Idle state, TX line is high
                donetx <= 1'b0;

                if (newd) begin
                    din <= tx_data;
                    state <= start;
                    bit_count <= 0;
                end
            end

            start: begin
                tx <= 1'b0; // Start bit
                state <= transfer;
            end

            transfer: begin
                if (bit_count < 8) begin
                    tx <= din[bit_count];
                    bit_count <= bit_count + 1;
                end else begin
                    state <= stop;
                end
            end

            stop: begin
                tx <= 1'b1; // Stop bit
                state <= idle;
                donetx <= 1'b0;
                if (newd == 1'b0) begin
                    donetx <= 1'b1;
                end
            end

            default: state <= idle;
        endcase
    end
end

endmodule
