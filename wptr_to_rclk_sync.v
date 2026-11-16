`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2025 10:02:35
// Design Name: 
// Module Name: wptr_to_rclk_sync
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


module wptr_to_rclk_sync (output reg [7:0] r_sync_wptr,
		      input [7:0] w_ptr,
		      input r_clk, r_rst_n);
				 
	reg [7:0] meta_ptr;
	
	// 2 flop synchronizer for write point with respect to read clock
	always @(posedge r_clk or negedge r_rst_n)
		if (!r_rst_n) 
			{r_sync_wptr, meta_ptr} <= 0;
		else 
			{r_sync_wptr, meta_ptr} <= {meta_ptr, w_ptr};
			
endmodule
