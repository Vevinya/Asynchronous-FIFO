`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
// 
// Create Date: 16.08.2025 10:01:49
// Design Name: 
// Module Name: read_ptr_empty_gen
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


module read_ptr_empty_gen (output reg fifo_empty,
		     output [6:0] r_addr,
		     output reg [7:0] r_ptr,
		     input [7:0] r_sync_wptr,
		     input r_en, r_clk, r_rst_n);
	
	reg [7:0] r_bin;
	wire [7:0] r_gray_next, r_bin_next;
	wire fifo_empty_next;
	
	// Gray Style 2 pointer (both gray code and binary code registers are present)
	always @(posedge r_clk or negedge r_rst_n)
		if (!r_rst_n) 
			{r_bin, r_ptr} <= 0;
		else 
			{r_bin, r_ptr} <= {r_bin_next, r_gray_next};
	
	assign r_bin_next = r_bin + (r_en & ~fifo_empty);
	assign r_gray_next = (r_bin_next>>1) ^ r_bin_next;
	
	// Memory read-address pointer (binary is used to address memory)
	assign r_addr = r_bin[6:0];
	
	// FIFO fifo_empty when the next r_ptr == synchronized w_ptr or on reset
	assign fifo_empty_next = (r_gray_next == r_sync_wptr);
	
	always @(posedge r_clk or negedge r_rst_n)
		if (!r_rst_n)
			fifo_empty <= 1'b1;
		else 
			fifo_empty <= fifo_empty_next;
	
endmodule

