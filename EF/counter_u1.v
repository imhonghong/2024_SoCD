`include "add1_6.v"

// stuck at 32
module counter_u1(clk, rst, cnt, data_valid);
input clk, rst, data_valid;
output [5:0] cnt;

reg [5:0] cnt;
// comb part
wire [5:0] cnt1, ncnt;
add1_6 a1(cnt,cnt1);
wire cnt33 = cnt[5] & cnt[0];
assign ncnt = (data_valid & ~cnt33)? cnt1: cnt;

//seq part
always@(posedge clk or posedge rst) begin
	if (rst) begin
		cnt <= 6'd0;
		end
	else begin
		cnt <= ncnt;
		end
end
endmodule
