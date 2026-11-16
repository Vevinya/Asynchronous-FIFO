`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2025 10:03:02
// Design Name: 
// Module Name: write_ptr_full_gen
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


module write_ptr_full_gen (output reg fifo_full,
		     output [6:0] w_addr,
		     output reg [7:0] w_ptr,
		     input [7:0] w_sync_rptr,
		     input w_en, w_clk, w_rst_n);
	
	reg [7:0] w_bin;
	wire [7:0] w_gray_next, w_bin_next;
	wire fifo_full_next;
	
	// Gray Style 2 pointer (both gray code and binary code registers are present)
	always @(posedge w_clk or negedge w_rst_n)
	if (!w_rst_n) 
		{w_bin, w_ptr} <= 0;
	else
		{w_bin, w_ptr} <= {w_bin_next, w_gray_next};
	
	assign w_bin_next = w_bin + (w_en & ~fifo_full);
	assign w_gray_next = (w_bin_next>>1) ^ w_bin_next;
	
	// Memory write-address pointer (binary is used to address memory)
	assign w_addr = w_bin[6:0];

	assign fifo_full_next = (w_gray_next=={~w_sync_rptr[7:6], w_sync_rptr[5:0]});
	
	always @(posedge w_clk or negedge w_rst_n)
		if (!w_rst_n) 
			fifo_full <= 1'b0;
		else 
			fifo_full <= fifo_full_next;
	
endmodule

