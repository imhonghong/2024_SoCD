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