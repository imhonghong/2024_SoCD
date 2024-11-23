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

//------- counter:1~16--------------//
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


//-------- 5bit +1 circuit-----------//
module add1_5(A,S);
input [4:0]A;
output [4:0]S;
wire [4:0]C;
assign C[0]=1'b1;
assign C[1]=A[0];
assign C[2]=C[1]&A[1];
assign C[3]=C[2]&A[2];
assign C[4]=C[3]&A[3];

assign S=A^C;
endmodule

//-------- DFF chain, 16bit, length=16--------------//
module DFF16_chain15(clk, rst, data_valid, din, 
					dout00, dout01, dout02, dout03, dout04, dout05, dout06, dout07,
					dout08,	dout09, dout10, dout11, dout12, dout13, dout14, dout15);
					
input clk, rst, data_valid;

input [15:0] din;

output [15:0]	dout00, dout01, dout02, dout03, dout04, dout05, dout06, dout07,
				dout08, dout09, dout10, dout11, dout12, dout13, dout14, dout15;
				
reg  [15:0]	dout00, dout01, dout02, dout03, dout04, dout05, dout06, dout07,
				dout08, dout09, dout10, dout11, dout12, dout13, dout14, dout15;
				
wire [15:0]	din00, din01, din02, din03, din04, din05, din06, din07,
				din08, din09, din10, din11, din12, din13, din14, din15;
			
// seq part
always@(posedge clk or posedge rst) begin
	if (rst) begin
		dout00 <= 16'h0;
		dout01 <= 16'h0;
		dout02 <= 16'h0;
		dout03 <= 16'h0;
		dout04 <= 16'h0;
		dout05 <= 16'h0;
		dout06 <= 16'h0;
		dout07 <= 16'h0;
		dout08 <= 16'h0;
		dout09 <= 16'h0;
		dout10 <= 16'h0;
		dout11 <= 16'h0;
		dout12 <= 16'h0;
		dout13 <= 16'h0;
		dout14 <= 16'h0;
		dout15 <= 16'h0;

		end
	else begin
		dout00 <= din00;
		dout01 <= din01;
		dout02 <= din02;
		dout03 <= din03;
		dout04 <= din04;
		dout05 <= din05;
		dout06 <= din06;
		dout07 <= din07;
		dout08 <= din08;
		dout09 <= din09;
		dout10 <= din10;
		dout11 <= din11;
		dout12 <= din12;
		dout13 <= din13;
		dout14 <= din14;
		dout15 <= din15;
		end

end
// comb part
assign din00 = (data_valid)? din : dout00;
assign din01 = (data_valid)? dout00 : dout01;
assign din02 = (data_valid)? dout01 : dout02;
assign din03 = (data_valid)? dout02 : dout03;
assign din04 = (data_valid)? dout03 : dout04;
assign din05 = (data_valid)? dout04 : dout05;
assign din06 = (data_valid)? dout05 : dout06;
assign din07 = (data_valid)? dout06 : dout07;
assign din08 = (data_valid)? dout07 : dout08;
assign din09 = (data_valid)? dout08 : dout09;

assign din10 = (data_valid)? dout09 : dout10;
assign din11 = (data_valid)? dout10 : dout11;
assign din12 = (data_valid)? dout11 : dout12;
assign din13 = (data_valid)? dout12 : dout13;
assign din14 = (data_valid)? dout13 : dout14;
assign din15 = (data_valid)? dout14 : dout15;


endmodule
