`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/06 13:33:18
// Design Name: 
// Module Name: ex2
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


module ex2(S,Y);
    input [2:0] S;
    output [5:0] Y;
    wire middle4_1,middle4_2;
    wire middle3_1,middle3_2;
    wire not3,not4;
nor
    nor5(Y[5],~S[2],~S[1]),
    nor2(Y[2],~S[1],S[0]),
    
    nor41(middle4_1,~S[2],S[1]),
    nor42(middle4_2,~S[2],~S[0]),
    nor4(not4,middle4_1,middle4_2),

    nor31(middle3_1,~S[2],S[1],~S[0]),
    nor32(middle3_2,S[2],~S[1],~S[0]),
    nor3(not3,middle3_1,middle3_2);

not 
    no3(Y[3],not3),
    no4(Y[4],not4);
    
assign Y[1]=0;
assign Y[0]=S[0];
    
endmodule
