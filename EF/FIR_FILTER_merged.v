module FIR_FILTER(clk, rst, data_valid, data, fir_d, fir_valid);
	input clk;
	input rst;
	input data_valid;
	input [15:0] data;
	output [15:0] fir_d;
	output fir_valid;
	
	// FIR coefficient
	parameter signed [19:0] FIR_C00 = 20'hFFF9E ;  //The FIR_coefficient value  0: -1.495361e-003
	parameter signed [19:0] FIR_C01 = 20'hFFF86 ;  //The FIR_coefficient value  1: -1.861572e-003
	parameter signed [19:0] FIR_C02 = 20'hFFFA7 ;  //The FIR_coefficient value  2: -1.358032e-003
	parameter signed [19:0] FIR_C03 = 20'h0003B ;  //The FIR_coefficient value  3:  9.002686e-004
	parameter signed [19:0] FIR_C04 = 20'h0014B ;  //The FIR_coefficient value  4:  5.050659e-003
	parameter signed [19:0] FIR_C05 = 20'h0024A ;  //The FIR_coefficient value  5:  8.941650e-003
	parameter signed [19:0] FIR_C06 = 20'h00222 ;  //The FIR_coefficient value  6:  8.331299e-003
	parameter signed [19:0] FIR_C07 = 20'hFFFE4 ;  //The FIR_coefficient value  7: -4.272461e-004
	parameter signed [19:0] FIR_C08 = 20'hFFBC5 ;  //The FIR_coefficient value  8: -1.652527e-002
	parameter signed [19:0] FIR_C09 = 20'hFF7CA ;  //The FIR_coefficient value  9: -3.207397e-002
	parameter signed [19:0] FIR_C10 = 20'hFF74E ;  //The FIR_coefficient value 10: -3.396606e-002
	parameter signed [19:0] FIR_C11 = 20'hFFD74 ;  //The FIR_coefficient value 11: -9.948730e-003
	parameter signed [19:0] FIR_C12 = 20'h00B1A ;  //The FIR_coefficient value 12:  4.336548e-002
	parameter signed [19:0] FIR_C13 = 20'h01DAC ;  //The FIR_coefficient value 13:  1.159058e-001
	parameter signed [19:0] FIR_C14 = 20'h02F9E ;  //The FIR_coefficient value 14:  1.860046e-001
	parameter signed [19:0] FIR_C15 = 20'h03AA9 ;  //The FIR_coefficient value 15:  2.291412e-001
	parameter signed [19:0] FIR_C16 = 20'h03AA9 ;  //The FIR_coefficient value 16:  2.291412e-001
	parameter signed [19:0] FIR_C17 = 20'h02F9E ;  //The FIR_coefficient value 17:  1.860046e-001
	parameter signed [19:0] FIR_C18 = 20'h01DAC ;  //The FIR_coefficient value 18:  1.159058e-001
	parameter signed [19:0] FIR_C19 = 20'h00B1A ;  //The FIR_coefficient value 19:  4.336548e-002
	parameter signed [19:0] FIR_C20 = 20'hFFD74 ;  //The FIR_coefficient value 20: -9.948730e-003
	parameter signed [19:0] FIR_C21 = 20'hFF74E ;  //The FIR_coefficient value 21: -3.396606e-002
	parameter signed [19:0] FIR_C22 = 20'hFF7CA ;  //The FIR_coefficient value 22: -3.207397e-002
	parameter signed [19:0] FIR_C23 = 20'hFFBC5 ;  //The FIR_coefficient value 23: -1.652527e-002
	parameter signed [19:0] FIR_C24 = 20'hFFFE4 ;  //The FIR_coefficient value 24: -4.272461e-004
	parameter signed [19:0] FIR_C25 = 20'h00222 ;  //The FIR_coefficient value 25:  8.331299e-003
	parameter signed [19:0] FIR_C26 = 20'h0024A ;  //The FIR_coefficient value 26:  8.941650e-003
	parameter signed [19:0] FIR_C27 = 20'h0014B ;  //The FIR_coefficient value 27:  5.050659e-003
	parameter signed [19:0] FIR_C28 = 20'h0003B ;  //The FIR_coefficient value 28:  9.002686e-004
	parameter signed [19:0] FIR_C29 = 20'hFFFA7 ;  //The FIR_coefficient value 29: -1.358032e-003
	parameter signed [19:0] FIR_C30 = 20'hFFF86 ;  //The FIR_coefficient value 30: -1.861572e-003
	parameter signed [19:0] FIR_C31 = 20'hFFF9E ;  //The FIR_coefficient value 31: -1.495361e-003
	
wire [5:0]cnt;	
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
// FIR valid logic = (cnt==33)
assign fir_valid = cnt[5]&cnt[0];

// mul and add
wire signed [35:0] product00, product01, product02, product03, product04, product05, product06, product07,
					product08, product09, product10, product11, product12, product13, product14, product15,
					product16, product17, product18, product19, product20, product21, product22, product23,
					product24, product25, product26, product27, product28, product29, product30, product31;
					
assign product00 = dout00 * FIR_C00 ;
assign product01 = dout01 * FIR_C01 ;
assign product02 = dout02 * FIR_C02 ;
assign product03 = dout03 * FIR_C03 ;
assign product04 = dout04 * FIR_C04 ;
assign product05 = dout05 * FIR_C05 ;
assign product06 = dout06 * FIR_C06 ;
assign product07 = dout07 * FIR_C07 ;
assign product08 = dout08 * FIR_C08 ;
assign product09 = dout09 * FIR_C09 ;

assign product10 = dout10 * FIR_C10 ;
assign product11 = dout11 * FIR_C11 ;
assign product12 = dout12 * FIR_C12 ;
assign product13 = dout13 * FIR_C13 ;
assign product14 = dout14 * FIR_C14 ;
assign product15 = dout15 * FIR_C15 ;
assign product16 = dout16 * FIR_C16 ;
assign product17 = dout17 * FIR_C17 ;
assign product18 = dout18 * FIR_C18 ;
assign product19 = dout19 * FIR_C19 ;

assign product20 = dout20 * FIR_C20 ;
assign product21 = dout21 * FIR_C21 ;
assign product22 = dout22 * FIR_C22 ;
assign product23 = dout23 * FIR_C23 ;
assign product24 = dout24 * FIR_C24 ;
assign product25 = dout25 * FIR_C25 ;
assign product26 = dout26 * FIR_C26 ;
assign product27 = dout27 * FIR_C27 ;
assign product28 = dout28 * FIR_C28 ;
assign product29 = dout29 * FIR_C29 ;

assign product30 = dout30 * FIR_C30 ;
assign product31 = dout31 * FIR_C31 ;

wire signed [41:0] sum_all;
assign sum_all =  product00 + product01 + product02 + product03 + product04 + product05 + product06 + product07 +
					product08 + product09 + product10 + product11 + product12 + product13 + product14 + product15 +
					product16 + product17 + product18 + product19 + product20 + product21 + product22 + product23 +
					product24 + product25 + product26 + product27 + product28 + product29 + product30 + product31;
wire [15:0]sum_a1;
add1_16 a2(sum_all[31:16],sum_a1);
assign fir_d = (fir_valid)? (sum_all[41])? sum_a1 : sum_all[31:16] : 16'd0 ;
endmodule

//-------------- up-counter: stuck at 33 --------------//
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

//-------------- 6bit add1 ckt --------------//
module add1_6(A,S);
input [5:0]A;
output [5:0]S;
wire [5:0]C;
assign C[0]=1'b1;
assign C[1]=A[0];
assign C[2]=C[1]&A[1];
assign C[3]=C[2]&A[2];
assign C[4]=C[3]&A[3];
assign C[5]=C[4]&A[4];
assign S=A^C;
endmodule

//-------------- 16bit add1 ckt --------------//
module add1_16(A,S);
input [15:0]A;
output [15:0]S;
wire [15:0]C;
assign C[0]=1'b1;
assign C[1]=A[0];
assign C[2]=C[1]&A[1];
assign C[3]=C[2]&A[2];
assign C[4]=C[3]&A[3];
assign C[5]=C[4]&A[4];
assign C[6]=C[5]&A[5];
assign C[7]=C[6]&A[6];
assign C[8]=C[7]&A[7];
assign C[9]=C[8]&A[8];
assign C[10]=C[9]&A[9];
assign C[11]=C[10]&A[10];
assign C[12]=C[11]&A[11];
assign C[13]=C[12]&A[12];
assign C[14]=C[13]&A[13];
assign C[15]=C[14]&A[14];
assign S=A^C;
endmodule


//-------------- 16bit DFF chain, length=32 --------------//
module DFF16_chain31(clk, rst, data_valid, din, 
					dout00, dout01, dout02, dout03, dout04, dout05, dout06, dout07,
					dout08,	dout09, dout10, dout11, dout12, dout13, dout14, dout15,
					dout16, dout17, dout18, dout19, dout20, dout21, dout22, dout23,
					dout24, dout25, dout26, dout27, dout28, dout29, dout30, dout31);
input clk, rst, data_valid;
input [15:0] din;
output [15:0]	dout00, dout01, dout02, dout03, dout04, dout05, dout06, dout07,
				dout08, dout09, dout10, dout11, dout12, dout13, dout14, dout15,
				dout16, dout17, dout18, dout19, dout20, dout21, dout22, dout23,
				dout24, dout25, dout26, dout27, dout28, dout29, dout30, dout31;
reg signed [15:0]	dout00, dout01, dout02, dout03, dout04, dout05, dout06, dout07,
				dout08, dout09, dout10, dout11, dout12, dout13, dout14, dout15,
				dout16, dout17, dout18, dout19, dout20, dout21, dout22, dout23,
				dout24, dout25, dout26, dout27, dout28, dout29, dout30, dout31;
				
wire signed [15:0]	din00, din01, din02, din03, din04, din05, din06, din07,
				din08, din09, din10, din11, din12, din13, din14, din15,
				din16, din17, din18, din19, din20, din21, din22, din23,
				din24, din25, din26, din27, din28, din29, din30, din31;
			
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
		dout16 <= 16'h0;
		dout17 <= 16'h0;
		dout18 <= 16'h0;
		dout19 <= 16'h0;
		dout20 <= 16'h0;
		dout21 <= 16'h0;
		dout22 <= 16'h0;
		dout23 <= 16'h0;
		dout24 <= 16'h0;
		dout25 <= 16'h0;
		dout26 <= 16'h0;
		dout27 <= 16'h0;
		dout28 <= 16'h0;
		dout29 <= 16'h0;
		dout30 <= 16'h0;
		dout31 <= 16'h0;
		end
	else if (data_valid) begin
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
		dout16 <= din16;
		dout17 <= din17;
		dout18 <= din18;
		dout19 <= din19;
		dout20 <= din20;
		dout21 <= din21;
		dout22 <= din22;
		dout23 <= din23;
		dout24 <= din24;
		dout25 <= din25;
		dout26 <= din26;
		dout27 <= din27;
		dout28 <= din28;
		dout29 <= din29;
		dout30 <= din30;
		dout31 <= din31;
		end
	else begin
		dout00 <= dout00;
		dout01 <= dout01;
		dout02 <= dout02;
		dout03 <= dout03;
		dout04 <= dout04;
		dout05 <= dout05;
		dout06 <= dout06;
		dout07 <= dout07;
		dout08 <= dout08;
		dout09 <= dout09;
		dout10 <= dout10;
		dout11 <= dout11;
		dout12 <= dout12;
		dout13 <= dout13;
		dout14 <= dout14;
		dout15 <= dout15;
		dout16 <= dout16;
		dout17 <= dout17;
		dout18 <= dout18;
		dout19 <= dout19;
		dout20 <= dout20;
		dout21 <= dout21;
		dout22 <= dout22;
		dout23 <= dout23;
		dout24 <= dout24;
		dout25 <= dout25;
		dout26 <= dout26;
		dout27 <= dout27;
		dout28 <= dout28;
		dout29 <= dout29;
		dout30 <= dout30;
		dout31 <= dout31;
		end
end
// comb part
assign din00 = din;
assign din01 = dout00;
assign din02 = dout01;
assign din03 = dout02;
assign din04 = dout03;
assign din05 = dout04;
assign din06 = dout05;
assign din07 = dout06;
assign din08 = dout07;
assign din09 = dout08;

assign din10 = dout09;
assign din11 = dout10;
assign din12 = dout11;
assign din13 = dout12;
assign din14 = dout13;
assign din15 = dout14;
assign din16 = dout15;
assign din17 = dout16;
assign din18 = dout17;
assign din19 = dout18;

assign din20 = dout19;
assign din21 = dout20;
assign din22 = dout21;
assign din23 = dout22;
assign din24 = dout23;
assign din25 = dout24;
assign din26 = dout25;
assign din27 = dout26;
assign din28 = dout27;
assign din29 = dout28;

assign din30 = dout29;
assign din31 = dout30;

endmodule
