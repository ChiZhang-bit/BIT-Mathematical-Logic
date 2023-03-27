`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/08 14:47:39
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench(
    );
    reg [2:0] S;
    wire [5:0] Y;

initial begin
    S[2]=1'b0;
    #20 S[2]=1'b1;
end

initial begin
    S[1]=1'b0;
    #10 S[1]=1'b1;
    #10 S[1]=1'b0;
    #10 S[1]=1'b1;
end

initial begin
    S[0]=1'b0;
    #5 S[0]=1'b1;
    #5 S[0]=1'b0;
    #5 S[0]=1'b1;
    #5 S[0]=1'b0;
    #5 S[0]=1'b1;
    #5 S[0]=1'b0;
    #5 S[0]=1'b1;
end

ex2 ex2(
    .S(S),
    .Y(Y)
);
endmodule
