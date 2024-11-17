`timescale 1ns/10ps
`include "counter_u1.v"

module tb();
reg clk, rst, data_valid;
wire [5:0]cnt;

counter_u1 dut(clk, rst, cnt, data_valid);

initial begin
	rst = 1; clk = 1; data_valid = 0;
	#5; rst = 0;
	#10; data_valid = 1;
end

always begin
	#5; clk = ~clk;
	end

initial begin
	$monitor($time," rst %b dv %b cnt %d", rst, data_valid, cnt);
	end
	
initial begin
	#650;
	$finish;
	end

endmodule
