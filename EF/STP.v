 `include "counter_16.v"
 `include "DFF16_chain15.v"
 module STP(
	clk, rst, fir_valid, fir_d, stp_valid,
	x_00, x_01, x_02, x_03, x_04, x_05, x_06, x_07,
	x_08, x_09, x_10, x_11, x_12, x_13, x_14, x_15
	);
	
	input clk, rst;
	input fir_valid;
	input signed [15:0] fir_d;
	output stp_valid;
	output signed [15:0] x_00, x_01, x_02, x_03, x_04, x_05, x_06, x_07, 
						x_08, x_09, x_10, x_11, x_12, x_13, x_14, x_15;
	
	
	
	counter_16 c16(.clk(clk), .rst(rst), .fir_valid(fir_valid), .cnt16(stp_valid));
	
	DFF16_chain15 Dchain2(.clk(clk), .rst(rst), .din(fir_d), .data_valid(fir_valid),
					.dout00(x_15), .dout01(x_14), .dout02(x_13), .dout03(x_12), .dout04(x_11), .dout05(x_10), .dout06(x_09), .dout07(x_08),
					.dout08(x_07), .dout09(x_06), .dout10(x_05), .dout11(x_04), .dout12(x_03), .dout13(x_02), .dout14(x_01), .dout15(x_00)
					);
endmodule