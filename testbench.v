`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ayush Aman
// 
// Create Date: 16.08.2025 10:03:22
// Design Name: 
// Module Name: testbench
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


`timescale 1ns/1ns

module testbench;

	reg [15:0] w_data;
	reg w_en, w_clk, w_rst_n;
	reg r_en, r_clk, r_rst_n;
	wire [15:0] r_data;
	wire fifo_full, fifo_empty;
	
	integer i;
	
	async_fifo dut_fifo (r_data,
				fifo_full,
				fifo_empty,
			        w_data,
			   	w_en,
				w_clk,
				w_rst_n,
			   	r_en,
				r_clk,
				r_rst_n);
	
	always
	begin
		r_clk = ~r_clk; 
		#25;
	end
	
	always
	begin
		w_clk = ~w_clk;
		#10;
	end
	
	initial
	begin
		r_clk = 0;
		w_clk = 0;
		r_rst_n = 0;
		w_rst_n = 0;
		w_en = 0;
		r_en = 0;
		#120;
		
		r_rst_n = 1;
		w_rst_n = 1;
		#30;
		
		//w_data = 420;
		w_en = 1;
		r_en = 1;
		//#20;
		for (i=1; i<207; i=i+1)
		begin
			w_data = i;
			#20;
		end
		w_en = 0;
		
		#6200;
		
		//w_data = 619;
		w_en = 1;
		//#20;
		for (i=1; i<207; i=i+1)
		begin
			w_data = 2*i + 3*i*i + 5;
			#20;
		end
		w_en = 0;
		
		#6200;
		
		//w_data = 2035;
		w_en = 1;
		//#20;
		for (i=1; i<207; i=i+1)
		begin
			w_data = i;
			#20;
		end
		w_en = 0;
		
		#6200;
		$stop;
	end
endmodule
