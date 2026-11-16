`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2025 10:02:11
// Design Name: 
// Module Name: rptr_to_wclk_sync
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


module rptr_to_wclk_sync (output reg [7:0] w_sync_rptr,
		      input [7:0] r_ptr,
		      input w_clk, w_rst_n);
				 
	reg [7:0] meta_ptr;
	
	// 2 flop synchronizer for read point with respect to write clock
	always @(posedge w_clk or negedge w_rst_n)
		if (!w_rst_n) 
			{w_sync_rptr, meta_ptr} <= 0;
		else 
			{w_sync_rptr, meta_ptr} <= {meta_ptr, r_ptr};
			
endmodule
