`include "add1_5.v"
module counter_16(clk, rst, fir_valid, cnt16);
input clk, rst, fir_valid;
output cnt16;

reg [4:0] cnt;

// comb part
wire [4:0] ncnt, cnt1;
add1_5 a2(cnt, cnt1);
assign ncnt = (fir_valid)? (cnt16)? 5'b1: cnt1 : cnt;
wire cnt16 = cnt[4] & (~|cnt[3:0]);

//seq part
always@(posedge clk or posedge rst) begin
	if (rst) begin
		cnt <= 5'd0;
		end
	else begin
		cnt <= ncnt;
		end
end
endmodule