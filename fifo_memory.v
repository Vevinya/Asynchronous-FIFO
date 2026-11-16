`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2025 10:01:28
// Design Name: 
// Module Name: fifo_memory
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

module fifo_memory (output [15:0] r_data,
		 input [15:0] w_data,
		 input [6:0] w_addr, r_addr,
		 input w_en, fifo_full, w_clk);

	// RTL Verilog memory model
	reg [15:0] fifo_ram [0:127];
	
	assign r_data = fifo_ram [r_addr];
	
	always @(posedge w_clk)
	begin
		if (w_en & (~fifo_full)) 
			fifo_ram [w_addr] <= w_data;
	end
	
endmodule

