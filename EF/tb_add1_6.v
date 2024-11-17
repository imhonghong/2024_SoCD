`timescale 1ns/10ps
`include "add1_6.v"
module tb();
reg [5:0]A;
wire[5:0]S;


add1_6 dut1(A,S);

initial begin
	A = 2;
#10 A = 0;
#10 A = 4;
#10 A = 11;
#10 A = 21;
#10 A = 31;
#10 A = 32;
#10 A = 54;
#10 A = 63;
#10 A = 64;
end

initial begin
$monitor("%d %d",A,S);
end
initial begin
#150;
$finish;
end
endmodule
