`include "DFF16_chain31.v"
`include "add1_16.v"
`include "add1_6.v"
`include "counter_u1.v"
`include "add_mul.v"

module FIR_FILTER(clk, rst, data_valid, data, fir_d, fir_valid);
	input clk;
	input rst;
	input data_valid;
	input [15:0] data;
	output [15:0] fir_d;
	output fir_valid;
		
wire [5:0]	cnt;	
counter_u1 cnt1(.clk(clk), .rst(rst), .cnt(cnt), .data_valid(data_valid));
wire signed [15:0]	dout00, dout01, dout02, dout03, dout04, dout05, dout06, dout07,
					dout08,	dout09, dout10, dout11, dout12, dout13, dout14, dout15,
					dout16, dout17, dout18, dout19, dout20, dout21, dout22, dout23,
					dout24, dout25, dout26, dout27, dout28, dout29, dout30, dout31;
					
DFF16_chain31 Dchain1(.clk(clk), .rst(rst), .din(data), .data_valid(data_valid),
					.dout00(dout00), .dout01(dout01), .dout02(dout02), .dout03(dout03), .dout04(dout04), .dout05(dout05), .dout06(dout06), .dout07(dout07),
					.dout08(dout08), .dout09(dout09), .dout10(dout10), .dout11(dout11), .dout12(dout12), .dout13(dout13), .dout14(dout14), .dout15(dout15),
					.dout16(dout16), .dout17(dout17), .dout18(dout18), .dout19(dout19), .dout20(dout20), .dout21(dout21), .dout22(dout22), .dout23(dout23),
					.dout24(dout24), .dout25(dout25), .dout26(dout26), .dout27(dout27), .dout28(dout28), .dout29(dout29), .dout30(dout30), .dout31(dout31));

wire signed [40:0] sum_all;

add_mul am1(	.dout00(dout00), .dout01(dout01), .dout02(dout02), .dout03(dout03), .dout04(dout04), .dout05(dout05), .dout06(dout06), .dout07(dout07),
				.dout08(dout08), .dout09(dout09), .dout10(dout10), .dout11(dout11), .dout12(dout12), .dout13(dout13), .dout14(dout14), .dout15(dout15),
				.dout16(dout16), .dout17(dout17), .dout18(dout18), .dout19(dout19), .dout20(dout20), .dout21(dout21), .dout22(dout22), .dout23(dout23),
				.dout24(dout24), .dout25(dout25), .dout26(dout26), .dout27(dout27), .dout28(dout28), .dout29(dout29), .dout30(dout30), .dout31(dout31),
				.sum_all(sum_all)
				);

assign fir_valid = cnt[5]&cnt[0];	// FIR valid logic = (cnt==33)
wire [15:0]	sum_a1;
add1_16 a2(sum_all[31:16],sum_a1);
assign fir_d = (fir_valid)? (sum_all[40])? sum_a1 : sum_all[31:16] : 16'd0 ;
endmodule


