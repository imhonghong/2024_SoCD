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
`include "FIR_FILTER.v"


/****************************************************************
  STP (Serial to Parallel)
*****************************************************************/
`include "STP.v"


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
