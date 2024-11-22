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