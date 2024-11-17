/****************************************************************
  Top Module
  
  
*****************************************************************/
module FAS (data_valid, data, clk, rst, fir_d, fir_valid, fft_valid, done, freq,
  fft_d1, fft_d2, fft_d3, fft_d4, fft_d5, fft_d6, fft_d7, fft_d8,
  fft_d9, fft_d10, fft_d11, fft_d12, fft_d13, fft_d14, fft_d15, fft_d0);
  input clk, rst;
  input data_valid;
  input [15:0] data; 

  output fir_valid, fft_valid;
  output [15:0] fir_d;
  output [31:0] fft_d1, fft_d2, fft_d3, fft_d4, fft_d5, fft_d6, fft_d7, fft_d8;
  output [31:0] fft_d9, fft_d10, fft_d11, fft_d12, fft_d13, fft_d14, fft_d15, fft_d0;
  output done;
  output [3:0] freq;

  wire stp_valid;
  // stp outputs; fft inputs
  wire signed [15:0] x_00, x_01, x_02, x_03, x_04, x_05, x_06, x_07,
                     x_08, x_09, x_10, x_11, x_12, x_13, x_14, x_15;  
  
  FIR_FILTER fas_fir(
    .clk(clk), 
    .rst(rst),
    .data_valid(data_valid),
    .data(data),
    .fir_valid(fir_valid),
    .fir_d(fir_d)
  );

  STP fas_stp(
    .clk(clk), 
    .rst(rst),
    .fir_valid(fir_valid),
    .fir_d(fir_d),
    .stp_valid(stp_valid),
    .x_00(x_00), .x_01(x_01), .x_02(x_02), .x_03(x_03), 
    .x_04(x_04), .x_05(x_05), .x_06(x_06), .x_07(x_07),
    .x_08(x_08), .x_09(x_09), .x_10(x_10), .x_11(x_11), 
    .x_12(x_12), .x_13(x_13), .x_14(x_14), .x_15(x_15)
  );

  FFT fas_fft(
    .clk(clk), 
    .rst(rst),
    .stp_valid(stp_valid),
    .x_00(x_00), .x_01(x_01), .x_02(x_02), .x_03(x_03), .x_04(x_04), .x_05(x_05), .x_06(x_06), .x_07(x_07), 
    .x_08(x_08), .x_09(x_09), .x_10(x_10), .x_11(x_11), .x_12(x_12), .x_13(x_13), .x_14(x_14), .x_15(x_15),
    .fft_valid(fft_valid),
    .fft_d00(fft_d0), .fft_d01(fft_d1), .fft_d02(fft_d2), .fft_d03(fft_d3), 
    .fft_d04(fft_d4), .fft_d05(fft_d5), .fft_d06(fft_d6), .fft_d07(fft_d7),
    .fft_d08(fft_d8), .fft_d09(fft_d9), .fft_d10(fft_d10), .fft_d11(fft_d11),
    .fft_d12(fft_d12), .fft_d13(fft_d13), .fft_d14(fft_d14), .fft_d15(fft_d15)
  );

  ANALYST fsa_analyst(
    .clk(clk), 
    .rst(rst),
    .fft_valid(fft_valid), 
    .fft_d00(fft_d0), .fft_d01(fft_d1), .fft_d02(fft_d2), .fft_d03(fft_d3), 
    .fft_d04(fft_d4), .fft_d05(fft_d5), .fft_d06(fft_d6), .fft_d07(fft_d7),
    .fft_d08(fft_d8), .fft_d09(fft_d9), .fft_d10(fft_d10), .fft_d11(fft_d11),
    .fft_d12(fft_d12), .fft_d13(fft_d13), .fft_d14(fft_d14), .fft_d15(fft_d15),
    .done(done),
    .freq(freq)
  );

endmodule

/****************************************************************
  FIR_filter
*****************************************************************/

`include "DFF16_chain31.v"
`include "add1_6.v"
`include "counter_u1.v"

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

assign fir_d = (fir_valid)? (sum_all[41])? sum_all[31:16]+16'd1 : sum_all[31:16] : 16'd0 ;
endmodule


/****************************************************************
  STP (Serial to Parallel)
*****************************************************************/

module STP (clk, rst, fir_valid, fir_d, stp_valid,
  x_00, x_01, x_02, x_03, x_04, x_05, x_06, x_07, 
  x_08, x_09, x_10, x_11, x_12, x_13, x_14, x_15);
  input clk, rst;
  input fir_valid;
  input signed [15:0] fir_d;
  output stp_valid;
  output signed [15:0] x_00, x_01, x_02, x_03, x_04, x_05, x_06, x_07, 
                       x_08, x_09, x_10, x_11, x_12, x_13, x_14, x_15;

  /* ============================================ */
  reg [5:0] stp_cnt_r, stp_cnt_w;
  reg [15:0] x_r[15:0];
  reg [15:0] x_w[15:0];

  /* ============================================ */
  integer i;

  /* ============================================ */
  assign stp_valid = (stp_cnt_r >= 16);
  assign x_00 = x_r[ 0];
  assign x_01 = x_r[ 1];
  assign x_02 = x_r[ 2];
  assign x_03 = x_r[ 3];
  assign x_04 = x_r[ 4];
  assign x_05 = x_r[ 5];
  assign x_06 = x_r[ 6];
  assign x_07 = x_r[ 7];
  assign x_08 = x_r[ 8];
  assign x_09 = x_r[ 9];
  assign x_10 = x_r[10];
  assign x_11 = x_r[11];
  assign x_12 = x_r[12];
  assign x_13 = x_r[13];
  assign x_14 = x_r[14];
  assign x_15 = x_r[15];

  /* ============================================ */
  always@ (*) begin

    stp_cnt_w = stp_cnt_r;
    for (i = 0; i < 16; i = i + 1)
      x_w[i] = x_r[i];

    if (fir_valid || stp_cnt_r > 0) begin
      if (stp_cnt_r >= 16) begin
        stp_cnt_w = 1;
        x_w[0] = fir_d;
      end else begin 
        stp_cnt_w = stp_cnt_r + 1;
        x_w[stp_cnt_r] = fir_d;
      end
    end else begin 
      stp_cnt_w = 0;
    end
  end

  /* ============================================ */
  always@ (posedge clk or posedge rst) begin
    if (rst) begin 
      for (i = 0; i < 16; i = i + 1)
        x_r[i] <= 0;
      stp_cnt_r <= 0;
    end else begin 
      for (i = 0; i < 16; i = i + 1)
        x_r[i] <= x_w[i];
      stp_cnt_r <= stp_cnt_w;
    end
  end 

endmodule

/****************************************************************
  FFT
*****************************************************************/

module FFT (clk, rst, stp_valid,
  x_00, x_01, x_02, x_03, x_04, x_05, x_06, x_07, 
  x_08, x_09, x_10, x_11, x_12, x_13, x_14, x_15,
  fft_valid,
  fft_d00, fft_d01, fft_d02, fft_d03, fft_d04, fft_d05, fft_d06, fft_d07, 
  fft_d08, fft_d09, fft_d10, fft_d11, fft_d12, fft_d13, fft_d14, fft_d15);
  input clk, rst;
  input stp_valid;
  input signed [15:0] x_00, x_01, x_02, x_03, x_04, x_05, x_06, x_07, 
                      x_08, x_09, x_10, x_11, x_12, x_13, x_14, x_15;
  output fft_valid;
  output signed [31:0] fft_d00, fft_d01, fft_d02, fft_d03, fft_d04, fft_d05, fft_d06, fft_d07, 
                       fft_d08, fft_d09, fft_d10, fft_d11, fft_d12, fft_d13, fft_d14, fft_d15;

  /* ============================================ */
  parameter signed [31:0]  CONST1     = 32'h00010000;   // Constant 1
  parameter signed [147:0] CONST1_148 = {83'b0, 1'b1, 64'b0};  // Constant 1
  parameter signed [31:0] W_REAL_0 = 32'h00010000;  // The real part of the reference table about COS(x)+i*SIN(x) value , 0: 001
  parameter signed [31:0] W_REAL_1 = 32'h0000EC83;  // The real part of the reference table about COS(x)+i*SIN(x) value , 1: 9.238739e-001
  parameter signed [31:0] W_REAL_2 = 32'h0000B504;  // The real part of the reference table about COS(x)+i*SIN(x) value , 2: 7.070923e-001
  parameter signed [31:0] W_REAL_3 = 32'h000061F7;  // The real part of the reference table about COS(x)+i*SIN(x) value , 3: 3.826752e-001
  parameter signed [31:0] W_REAL_4 = 32'h00000000;  // The real part of the reference table about COS(x)+i*SIN(x) value , 4: 000
  parameter signed [31:0] W_REAL_5 = 32'hFFFF9E09;  // The real part of the reference table about COS(x)+i*SIN(x) value , 5: -3.826752e-001
  parameter signed [31:0] W_REAL_6 = 32'hFFFF4AFC;  // The real part of the reference table about COS(x)+i*SIN(x) value , 6: -7.070923e-001
  parameter signed [31:0] W_REAL_7 = 32'hFFFF137D;  // The real part of the reference table about COS(x)+i*SIN(x) value , 7: -9.238739e-001

  parameter signed [31:0] W_IMAG_0 = 32'h00000000;  // The imag part of the reference table about COS(x)+i*SIN(x) value , 0: 000
  parameter signed [31:0] W_IMAG_1 = 32'hFFFF9E09;  // The imag part of the reference table about COS(x)+i*SIN(x) value , 1: -3.826752e-001
  parameter signed [31:0] W_IMAG_2 = 32'hFFFF4AFC;  // The imag part of the reference table about COS(x)+i*SIN(x) value , 2: -7.070923e-001
  parameter signed [31:0] W_IMAG_3 = 32'hFFFF137D;  // The imag part of the reference table about COS(x)+i*SIN(x) value , 3: -9.238739e-001
  parameter signed [31:0] W_IMAG_4 = 32'hFFFF0000;  // The imag part of the reference table about COS(x)+i*SIN(x) value , 4: -01
  parameter signed [31:0] W_IMAG_5 = 32'hFFFF137D;  // The imag part of the reference table about COS(x)+i*SIN(x) value , 5: -9.238739e-001
  parameter signed [31:0] W_IMAG_6 = 32'hFFFF4AFC;  // The imag part of the reference table about COS(x)+i*SIN(x) value , 6: -7.070923e-001
  parameter signed [31:0] W_IMAG_7 = 32'hFFFF9E09;  // The imag part of the reference table about COS(x)+i*SIN(x) value , 7: -3.826752e-001

  /* ============================================ */
  reg signed [31:0] W_REAL_r[7:0], W_REAL_w[7:0]; 
  reg signed [31:0] W_IMAG_r[7:0], W_IMAG_w[7:0]; 
  reg signed [147:0] stage1_real_r[15:0], stage1_real_w[15:0];
  reg signed [147:0] stage2_real_r[15:0], stage2_real_w[15:0];
  reg signed [147:0] stage3_real_r[15:0], stage3_real_w[15:0];
  reg signed [147:0] stage4_real_r[15:0], stage4_real_w[15:0];
  reg signed [147:0] stage1_imag_r[15:0], stage1_imag_w[15:0];
  reg signed [147:0] stage2_imag_r[15:0], stage2_imag_w[15:0];
  reg signed [147:0] stage3_imag_r[15:0], stage3_imag_w[15:0];
  reg signed [147:0] stage4_imag_r[15:0], stage4_imag_w[15:0];
  reg signed [15:0] truncate_real_r[15:0], truncate_real_w[15:0];
  reg signed [15:0] truncate_imag_r[15:0], truncate_imag_w[15:0];
  reg [4:0] fft_cnt_r, fft_cnt_w;

  /* ============================================ */
  integer i, j;

  /* ============================================ */
  assign fft_valid = (fft_cnt_r > 4);
  assign fft_d00 = { truncate_real_r[ 0], truncate_imag_r[ 0] };
  assign fft_d08 = { truncate_real_r[ 1], truncate_imag_r[ 1] };
  assign fft_d04 = { truncate_real_r[ 2], truncate_imag_r[ 2] };
  assign fft_d12 = { truncate_real_r[ 3], truncate_imag_r[ 3] };
  assign fft_d02 = { truncate_real_r[ 4], truncate_imag_r[ 4] };
  assign fft_d10 = { truncate_real_r[ 5], truncate_imag_r[ 5] };
  assign fft_d06 = { truncate_real_r[ 6], truncate_imag_r[ 6] };
  assign fft_d14 = { truncate_real_r[ 7], truncate_imag_r[ 7] };
  assign fft_d01 = { truncate_real_r[ 8], truncate_imag_r[ 8] };
  assign fft_d09 = { truncate_real_r[ 9], truncate_imag_r[ 9] };
  assign fft_d05 = { truncate_real_r[10], truncate_imag_r[10] };
  assign fft_d13 = { truncate_real_r[11], truncate_imag_r[11] };
  assign fft_d03 = { truncate_real_r[12], truncate_imag_r[12] };
  assign fft_d11 = { truncate_real_r[13], truncate_imag_r[13] };
  assign fft_d07 = { truncate_real_r[14], truncate_imag_r[14] };
  assign fft_d15 = { truncate_real_r[15], truncate_imag_r[15] };
                    
  /* ============================================ */
  always@ (*) begin
    fft_cnt_w = fft_cnt_r;
    for (i = 0; i < 8; i = i + 1) begin 
      W_REAL_w[i] = W_REAL_r[i];
      W_IMAG_w[i] = W_IMAG_r[i];
    end
    for (i = 0; i < 16; i = i + 1) begin 
      stage1_real_w[i]   = stage1_real_r[i];
      stage2_real_w[i]   = stage2_real_r[i];
      stage3_real_w[i]   = stage3_real_r[i];
      stage4_real_w[i]   = stage4_real_r[i];
      stage1_imag_w[i]   = stage1_imag_r[i];
      stage2_imag_w[i]   = stage2_imag_r[i];
      stage3_imag_w[i]   = stage3_imag_r[i];
      stage4_imag_w[i]   = stage4_imag_r[i];
      truncate_real_w[i] = truncate_real_r[i];
      truncate_imag_w[i] = truncate_imag_r[i];
    end

    if (stp_valid || fft_cnt_r > 0) begin
      fft_cnt_w = (fft_cnt_r > 4 ? 0 : fft_cnt_r + 1);

      case (fft_cnt_r)
        //////////////////////// 
        // STAGE 1:
        //////////////////////// 
        5'd0: begin
          stage1_real_w[0] = (x_00 + x_08) * CONST1;
          stage1_real_w[1] = (x_01 + x_09) * CONST1;
          stage1_real_w[2] = (x_02 + x_10) * CONST1;
          stage1_real_w[3] = (x_03 + x_11) * CONST1;
          stage1_real_w[4] = (x_04 + x_12) * CONST1;
          stage1_real_w[5] = (x_05 + x_13) * CONST1;
          stage1_real_w[6] = (x_06 + x_14) * CONST1;
          stage1_real_w[7] = (x_07 + x_15) * CONST1;

          stage1_imag_w[0] = 0; 
          stage1_imag_w[1] = 0; 
          stage1_imag_w[2] = 0; 
          stage1_imag_w[3] = 0; 
          stage1_imag_w[4] = 0; 
          stage1_imag_w[5] = 0; 
          stage1_imag_w[6] = 0; 
          stage1_imag_w[7] = 0; 

          stage1_real_w[ 8] = (x_00 - x_08) * W_REAL_r[0];
          stage1_real_w[ 9] = (x_01 - x_09) * W_REAL_r[1];
          stage1_real_w[10] = (x_02 - x_10) * W_REAL_r[2];
          stage1_real_w[11] = (x_03 - x_11) * W_REAL_r[3];
          stage1_real_w[12] = (x_04 - x_12) * W_REAL_r[4];
          stage1_real_w[13] = (x_05 - x_13) * W_REAL_r[5];
          stage1_real_w[14] = (x_06 - x_14) * W_REAL_r[6];
          stage1_real_w[15] = (x_07 - x_15) * W_REAL_r[7];

          stage1_imag_w[ 8] = (x_00 - x_08) * W_IMAG_r[0];
          stage1_imag_w[ 9] = (x_01 - x_09) * W_IMAG_r[1];
          stage1_imag_w[10] = (x_02 - x_10) * W_IMAG_r[2];
          stage1_imag_w[11] = (x_03 - x_11) * W_IMAG_r[3];
          stage1_imag_w[12] = (x_04 - x_12) * W_IMAG_r[4];
          stage1_imag_w[13] = (x_05 - x_13) * W_IMAG_r[5];
          stage1_imag_w[14] = (x_06 - x_14) * W_IMAG_r[6];
          stage1_imag_w[15] = (x_07 - x_15) * W_IMAG_r[7];
        end  

        //////////////////////// 
        // STAGE 2:
        ////////////////////////
        5'd1: begin
          for (i = 0; i < 2; i = i + 1) begin 
            for (j = i * 8; j < i * 8 + 4; j = j + 1) begin 
              stage2_real_w[j] = (stage1_real_r[j] + stage1_real_r[j + 4]) * CONST1;
              stage2_imag_w[j] = (stage1_imag_r[j] + stage1_imag_r[j + 4]) * CONST1;
              stage2_real_w[j + 4] = ((stage1_real_r[j] - stage1_real_r[j + 4]) * W_REAL_r[(j - i * 8) * 2])
                                   + ((stage1_imag_r[j + 4] - stage1_imag_r[j]) * W_IMAG_r[(j - i * 8) * 2]);
              stage2_imag_w[j + 4] = ((stage1_real_r[j] - stage1_real_r[j + 4]) * W_IMAG_r[(j - i * 8) * 2])
                                   + ((stage1_imag_r[j] - stage1_imag_r[j + 4]) * W_REAL_r[(j - i * 8) * 2]);
            end
          end
        end

        //////////////////////// 
        // STAGE 3:
        //////////////////////// 
        5'd2: begin
          for (i = 0; i < 4; i = i + 1) begin 
            for (j = i * 4; j < i * 4 + 2; j = j + 1) begin 
              stage3_real_w[j] = (stage2_real_r[j] + stage2_real_r[j + 2]) * CONST1;
              stage3_imag_w[j] = (stage2_imag_r[j] + stage2_imag_r[j + 2]) * CONST1;
              stage3_real_w[j + 2] = ((stage2_real_r[j] - stage2_real_r[j + 2]) * W_REAL_r[(j - i * 4) * 4])
                                   + ((stage2_imag_r[j + 2] - stage2_imag_r[j]) * W_IMAG_r[(j - i * 4) * 4]);
              stage3_imag_w[j + 2] = ((stage2_real_r[j] - stage2_real_r[j + 2]) * W_IMAG_r[(j - i * 4) * 4])
                                   + ((stage2_imag_r[j] - stage2_imag_r[j + 2]) * W_REAL_r[(j - i * 4) * 4]);
            end
          end
        end

        //////////////////////// 
        // STAGE 4:
        //////////////////////// 
        5'd3: begin
          for (i = 0; i < 8; i = i + 1) begin 
            for (j = i * 2; j < i * 2 + 1; j = j + 1) begin 
              stage4_real_w[j] = (stage3_real_r[j] + stage3_real_r[j + 1]) * CONST1;
              stage4_imag_w[j] = (stage3_imag_r[j] + stage3_imag_r[j + 1]) * CONST1;
              stage4_real_w[j + 1] = ((stage3_real_r[j] - stage3_real_r[j + 1]) * W_REAL_r[0])
                                   + ((stage3_imag_r[j + 1] - stage3_imag_r[j]) * W_IMAG_r[0]);
              stage4_imag_w[j + 1] = ((stage3_real_r[j] - stage3_real_r[j + 1]) * W_IMAG_r[0])
                                   + ((stage3_imag_r[j] - stage3_imag_r[j + 1]) * W_REAL_r[0]);
            end
          end
        end

        //////////////////////// 
        // Truncate
        //////////////////////// 
        5'd4: begin
          for (i = 0; i < 16; i = i + 1) begin 
            truncate_real_w[i] = stage4_real_r[i] < 0 ?
                                 {stage4_real_r[i][147], stage4_real_r[i][78:72], stage4_real_r[i][71:64]} :
                                 {stage4_real_r[i][147], stage4_real_r[i][78:72], stage4_real_r[i][71:64]} ;
            truncate_imag_w[i] = stage4_imag_r[i] < 0 ? 
                                 {stage4_imag_r[i][147], stage4_imag_r[i][78:72], stage4_imag_r[i][71:64]} :
                                 {stage4_imag_r[i][147], stage4_imag_r[i][78:72], stage4_imag_r[i][71:64]} ;
          end
        end
      endcase
    end else begin 
      fft_cnt_w = 0;
      for (i = 0; i < 16; i = i + 1) begin 
        stage1_real_w[i] = 0;
        stage2_real_w[i] = 0;
        stage3_real_w[i] = 0;
        stage4_real_w[i] = 0;
        stage1_imag_w[i] = 0;
        stage2_imag_w[i] = 0;
        stage3_imag_w[i] = 0;
        stage4_imag_w[i] = 0;
      end
    end 
  end

  /* ============================================ */
  always@ (posedge clk or posedge rst) begin
    if (rst) begin 
      W_REAL_r[0] <= W_REAL_0;
      W_REAL_r[1] <= W_REAL_1;
      W_REAL_r[2] <= W_REAL_2;
      W_REAL_r[3] <= W_REAL_3;
      W_REAL_r[4] <= W_REAL_4;
      W_REAL_r[5] <= W_REAL_5;
      W_REAL_r[6] <= W_REAL_6;
      W_REAL_r[7] <= W_REAL_7;
      W_IMAG_r[0] <= W_IMAG_0;
      W_IMAG_r[1] <= W_IMAG_1;
      W_IMAG_r[2] <= W_IMAG_2;
      W_IMAG_r[3] <= W_IMAG_3;
      W_IMAG_r[4] <= W_IMAG_4;
      W_IMAG_r[5] <= W_IMAG_5;
      W_IMAG_r[6] <= W_IMAG_6;
      W_IMAG_r[7] <= W_IMAG_7;
      for (i = 0; i < 16; i = i + 1) begin 
        stage1_real_r[i]   <= 0;
        stage2_real_r[i]   <= 0;
        stage3_real_r[i]   <= 0;
        stage4_real_r[i]   <= 0;
        stage1_imag_r[i]   <= 0;
        stage2_imag_r[i]   <= 0;
        stage3_imag_r[i]   <= 0;
        stage4_imag_r[i]   <= 0;
        truncate_real_r[i] <= 0;
        truncate_imag_r[i] <= 0;
      end
      fft_cnt_r <= 0;
    end else begin 
      for (i = 0; i < 8; i = i + 1) begin 
        W_REAL_r[i] <= W_REAL_w[i];
        W_IMAG_r[i] <= W_IMAG_w[i];
      end
      for (i = 0; i < 16; i = i + 1) begin 
        stage1_real_r[i]   <= stage1_real_w[i];
        stage2_real_r[i]   <= stage2_real_w[i];
        stage3_real_r[i]   <= stage3_real_w[i];
        stage4_real_r[i]   <= stage4_real_w[i];
        stage1_imag_r[i]   <= stage1_imag_w[i];
        stage2_imag_r[i]   <= stage2_imag_w[i];
        stage3_imag_r[i]   <= stage3_imag_w[i];
        stage4_imag_r[i]   <= stage4_imag_w[i];
        truncate_real_r[i] <= truncate_real_w[i];
        truncate_imag_r[i] <= truncate_imag_w[i];
      end
      fft_cnt_r <= fft_cnt_w;      
    end
  end 

endmodule

/****************************************************************
  ANALYST
*****************************************************************/
module ANALYST(clk, rst, fft_valid, 
  fft_d00, fft_d01, fft_d02, fft_d03, fft_d04, fft_d05, fft_d06, fft_d07, 
  fft_d08, fft_d09, fft_d10, fft_d11, fft_d12, fft_d13, fft_d14, fft_d15,
  done, freq);
  input clk, rst;
  input fft_valid;
  input [31:0] fft_d00, fft_d01, fft_d02, fft_d03, fft_d04, fft_d05, fft_d06, fft_d07, 
               fft_d08, fft_d09, fft_d10, fft_d11, fft_d12, fft_d13, fft_d14, fft_d15;
  output done;
  output [3:0] freq;

  /* ============================================ */
  reg [3:0] analyst_cnt_r, analyst_cnt_w;

  reg [32:0] value_d1_r[15:0], value_d1_w[15:0];
  reg [32:0] value_d2_r[ 7:0], value_d2_w[ 7:0];
  reg [32:0] value_d3_r[ 3:0], value_d3_w[ 3:0];
  reg [32:0] value_d4_r[ 1:0], value_d4_w[ 1:0];
  reg [32:0] value_d5_r, value_d5_w;
  
  reg [3:0] freq_d1_r[15:0], freq_d1_w[15:0];
  reg [3:0] freq_d2_r[ 7:0], freq_d2_w[ 7:0];
  reg [3:0] freq_d3_r[ 3:0], freq_d3_w[ 3:0];
  reg [3:0] freq_d4_r[ 1:0], freq_d4_w[ 1:0];
  reg [3:0] freq_d5_r, freq_d5_w;

  /* ============================================ */
  integer i;

  /* ============================================ */
  assign done = (analyst_cnt_r > 4);
  assign freq = freq_d5_r;

  /* ============================================ */
  always@ (*) begin
    
    for (i = 0; i < 16; i = i + 1)
      value_d1_w[i] = value_d1_r[i];
    for (i = 0; i < 8; i = i + 1)
      value_d2_w[i] = value_d2_r[i];
    for (i = 0; i < 4; i = i + 1)
      value_d3_w[i] = value_d3_r[i];
    for (i = 0; i < 2; i = i + 1)
      value_d4_w[i] = value_d4_r[i];
    value_d5_w = value_d5_r;

    for (i = 0; i < 16; i = i + 1)
      freq_d1_w[i] = freq_d1_r[i];
    for (i = 0; i < 8; i = i + 1)
      freq_d2_w[i] = freq_d2_r[i];
    for (i = 0; i < 4; i = i + 1)
      freq_d3_w[i] = freq_d3_r[i];
    for (i = 0; i < 2; i = i + 1)
      freq_d4_w[i] = freq_d4_r[i];
    freq_d5_w = freq_d5_r;

    analyst_cnt_w = analyst_cnt_r;

    if (fft_valid || analyst_cnt_r > 0) begin
      analyst_cnt_w = analyst_cnt_r > 4 ? 0 : analyst_cnt_r + 1;
      case (analyst_cnt_r)
        //////////////////////// 
        // STAGE 1:
        //////////////////////// 
        4'd0: begin
          value_d1_w[ 0] = $signed({fft_d00[31:16]}) * $signed({fft_d00[31:16]}) 
                         + $signed({fft_d00[15: 0]}) * $signed({fft_d00[15: 0]});
          value_d1_w[ 1] = $signed({fft_d01[31:16]}) * $signed({fft_d01[31:16]}) 
                         + $signed({fft_d01[15: 0]}) * $signed({fft_d01[15: 0]});
          value_d1_w[ 2] = $signed({fft_d02[31:16]}) * $signed({fft_d02[31:16]}) 
                         + $signed({fft_d02[15: 0]}) * $signed({fft_d02[15: 0]});
          value_d1_w[ 3] = $signed({fft_d03[31:16]}) * $signed({fft_d03[31:16]}) 
                         + $signed({fft_d03[15: 0]}) * $signed({fft_d03[15: 0]});
          value_d1_w[ 4] = $signed({fft_d04[31:16]}) * $signed({fft_d04[31:16]}) 
                         + $signed({fft_d04[15: 0]}) * $signed({fft_d04[15: 0]});
          value_d1_w[ 5] = $signed({fft_d05[31:16]}) * $signed({fft_d05[31:16]}) 
                         + $signed({fft_d05[15: 0]}) * $signed({fft_d05[15: 0]});
          value_d1_w[ 6] = $signed({fft_d06[31:16]}) * $signed({fft_d06[31:16]}) 
                         + $signed({fft_d06[15: 0]}) * $signed({fft_d06[15: 0]});
          value_d1_w[ 7] = $signed({fft_d07[31:16]}) * $signed({fft_d07[31:16]}) 
                         + $signed({fft_d07[15: 0]}) * $signed({fft_d07[15: 0]});
          value_d1_w[ 8] = $signed({fft_d08[31:16]}) * $signed({fft_d08[31:16]}) 
                         + $signed({fft_d08[15: 0]}) * $signed({fft_d08[15: 0]});
          value_d1_w[ 9] = $signed({fft_d09[31:16]}) * $signed({fft_d09[31:16]}) 
                         + $signed({fft_d09[15: 0]}) * $signed({fft_d09[15: 0]});
          value_d1_w[10] = $signed({fft_d10[31:16]}) * $signed({fft_d10[31:16]}) 
                         + $signed({fft_d10[15: 0]}) * $signed({fft_d10[15: 0]});
          value_d1_w[11] = $signed({fft_d11[31:16]}) * $signed({fft_d11[31:16]}) 
                         + $signed({fft_d11[15: 0]}) * $signed({fft_d11[15: 0]});
          value_d1_w[12] = $signed({fft_d12[31:16]}) * $signed({fft_d12[31:16]}) 
                         + $signed({fft_d12[15: 0]}) * $signed({fft_d12[15: 0]});
          value_d1_w[13] = $signed({fft_d13[31:16]}) * $signed({fft_d13[31:16]}) 
                         + $signed({fft_d13[15: 0]}) * $signed({fft_d13[15: 0]});
          value_d1_w[14] = $signed({fft_d14[31:16]}) * $signed({fft_d14[31:16]}) 
                         + $signed({fft_d14[15: 0]}) * $signed({fft_d14[15: 0]});
          value_d1_w[15] = $signed({fft_d15[31:16]}) * $signed({fft_d15[31:16]}) 
                         + $signed({fft_d15[15: 0]}) * $signed({fft_d15[15: 0]});
          
          freq_d1_w[ 0] =  0;
          freq_d1_w[ 1] =  1;
          freq_d1_w[ 2] =  2;
          freq_d1_w[ 3] =  3;
          freq_d1_w[ 4] =  4;
          freq_d1_w[ 5] =  5;
          freq_d1_w[ 6] =  6;
          freq_d1_w[ 7] =  7;
          freq_d1_w[ 8] =  8;
          freq_d1_w[ 9] =  9;
          freq_d1_w[10] = 10;
          freq_d1_w[11] = 11;
          freq_d1_w[12] = 12;
          freq_d1_w[13] = 13;
          freq_d1_w[14] = 14;
          freq_d1_w[15] = 15;

        end
        //////////////////////// 
        // STAGE 2:
        //////////////////////// 
        4'd1: begin
          for (i = 0; i < 8; i = i + 1) begin
            if (value_d1_r[i * 2] > value_d1_r[i * 2 + 1]) begin
              value_d2_w[i] = value_d1_r[i * 2];
              freq_d2_w [i] = freq_d1_r [i * 2];
            end else begin
              value_d2_w[i] = value_d1_r[i * 2 + 1];
              freq_d2_w [i] = freq_d1_r [i * 2 + 1];
            end
          end
        end
        //////////////////////// 
        // STAGE 3:
        //////////////////////// 
        4'd2: begin
          for (i = 0; i < 4; i = i + 1) begin
            if (value_d2_r[i * 2] > value_d2_r[i * 2 + 1]) begin
              value_d3_w[i] = value_d2_r[i * 2];
              freq_d3_w [i] = freq_d2_r [i * 2];
            end else begin
              value_d3_w[i] = value_d2_r[i * 2 + 1];
              freq_d3_w [i] = freq_d2_r [i * 2 + 1];
            end
          end
        end
        //////////////////////// 
        // STAGE 4:
        //////////////////////// 
        4'd3: begin
          for (i = 0; i < 2; i = i + 1) begin
            if (value_d3_r[i * 2] > value_d3_r[i * 2 + 1]) begin
              value_d4_w[i] = value_d3_r[i * 2];
              freq_d4_w [i] = freq_d3_r [i * 2];
            end else begin
              value_d4_w[i] = value_d3_r[i * 2 + 1];
              freq_d4_w [i] = freq_d3_r [i * 2 + 1];
            end
          end
        end
        //////////////////////// 
        // STAGE 5:
        //////////////////////// 
        4'd4: begin
          if (value_d4_r[0] > value_d4_r[1]) begin
            value_d5_w = value_d4_r[0];
            freq_d5_w  = freq_d4_r [0];
          end else begin
            value_d5_w = value_d4_r[1];
            freq_d5_w  = freq_d4_r [1];
          end
        end
      endcase
    end else begin
      analyst_cnt_w = 0;
    end
  end

  /* ============================================ */
  always@ (posedge clk or posedge rst) begin
    if (rst) begin 
      for (i = 0; i < 16; i = i + 1)
        value_d1_r[i] <= 0;
      for (i = 0; i < 8; i = i + 1)
        value_d2_r[i] <= 0;
      for (i = 0; i < 4; i = i + 1)
        value_d3_r[i] <= 0;
      for (i = 0; i < 2; i = i + 1)
        value_d4_r[i] <= 0;
      value_d5_r <= 0;

      for (i = 0; i < 16; i = i + 1)
        freq_d1_r[i] <= 0;
      for (i = 0; i < 8; i = i + 1)
        freq_d2_r[i] <= 0;
      for (i = 0; i < 4; i = i + 1)
        freq_d3_r[i] <= 0;
      for (i = 0; i < 2; i = i + 1)
        freq_d4_r[i] <= 0;
      freq_d5_r <= 0;

      analyst_cnt_r <= 0;
    end else begin
      for (i = 0; i < 16; i = i + 1)
        value_d1_r[i] <= value_d1_w[i];
      for (i = 0; i < 8; i = i + 1)
        value_d2_r[i] <= value_d2_w[i];
      for (i = 0; i < 4; i = i + 1)
        value_d3_r[i] <= value_d3_w[i];
      for (i = 0; i < 2; i = i + 1)
        value_d4_r[i] <= value_d4_w[i];
      value_d5_r <= value_d5_w;

      for (i = 0; i < 16; i = i + 1)
        freq_d1_r[i] <= freq_d1_w[i];
      for (i = 0; i < 8; i = i + 1)
        freq_d2_r[i] <= freq_d2_w[i];
      for (i = 0; i < 4; i = i + 1)
        freq_d3_r[i] <= freq_d3_w[i];
      for (i = 0; i < 2; i = i + 1)
        freq_d4_r[i] <= freq_d4_w[i];
      freq_d5_r <= freq_d5_w;

      analyst_cnt_r <= analyst_cnt_w;
    end
  end 

endmodule
