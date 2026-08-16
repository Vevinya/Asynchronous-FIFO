`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ayush Aman
// 
// Create Date: 16.08.2025 10:01:01
// Design Name: 
// Module Name: async_fifo
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


module async_fifo (output [15:0] r_data,
			  output fifo_full,
			  output fifo_empty,
			  input [15:0] w_data,
			  input w_en, w_clk, w_rst_n,
			  input r_en, r_clk, r_rst_n);
	
	wire [6:0] w_addr, r_addr;
	wire [7:0] w_ptr, r_ptr, w_sync_rptr, r_sync_wptr;

	rptr_to_wclk_sync u_rptr_sync (w_sync_rptr, r_ptr, w_clk, w_rst_n);

	wptr_to_rclk_sync u_wptr_sync (r_sync_wptr, w_ptr, r_clk, r_rst_n);

	fifo_memory u_mem (r_data, w_data, w_addr, r_addr, w_en, fifo_full, w_clk);

	read_ptr_empty_gen u_rd_ctrl (fifo_empty, r_addr, r_ptr, r_sync_wptr, r_en, r_clk, r_rst_n);

	write_ptr_full_gen u_wr_ctrl (fifo_full, w_addr, w_ptr, w_sync_rptr, w_en, w_clk, w_rst_n);

endmodule

