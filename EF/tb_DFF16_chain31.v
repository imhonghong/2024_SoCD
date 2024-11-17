`timescale 1ns/10ps
`include "DFF16_chain31.v"

module tb();
reg clk, rst, data_valid;
reg [15:0]din;
wire [15:0]	dout00, dout01, dout02, dout03, dout04, dout05, dout06, dout07,
			dout08, dout09, dout10, dout11, dout12, dout13, dout14, dout15,
			dout16, dout17, dout18, dout19, dout20, dout21, dout22, dout23,
			dout24, dout25, dout26, dout27, dout28, dout29, dout30, dout31;

DFF16_chain31 dut1(clk, rst, data_valid, din, 
					dout00, dout01, dout02, dout03, dout04, dout05, dout06, dout07,
					dout08,	dout09, dout10, dout11, dout12, dout13, dout14, dout15,
					dout16, dout17, dout18, dout19, dout20, dout21, dout22, dout23,
					dout24, dout25, dout26, dout27, dout28, dout29, dout30, dout31);
					
initial begin
	clk = 1;
	rst = 1;
	data_valid = 0;
	din = 16'h94;
	#5;		rst = 0; din = 16'hAA;
	#10;	din = 16'h00;
	#20;	data_valid = 1;
	#5; 	din = 16'h3333;
	#10;	din = 16'h0;
	#150;	din = 16'h4444;
	#10;	din = 16'h0;
	
end

always begin
	#5;
	clk = ~clk; 
end

initial begin
$monitor($time, "rst %b dv %b din = %h,\n,%h,%h,%h,%h,%h,%h,%h,%h,\n,%h,%h,%h,%h,%h,%h,%h,%h,\n,%h,%h,%h,%h,%h,%h,%h,%h,\n,%h,%h,%h,%h,%h,%h,%h,%h,\n",
			rst,data_valid, din,dout00, dout01, dout02, dout03, dout04, dout05, dout06, dout07,
					dout08,	dout09, dout10, dout11, dout12, dout13, dout14, dout15,
					dout16, dout17, dout18, dout19, dout20, dout21, dout22, dout23,
					dout24, dout25, dout26, dout27, dout28, dout29, dout30, dout31);
end
initial begin
#340;
$finish;
end
endmodule