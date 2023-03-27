`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/13 13:03:37
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
    reg x,clock,reset;
    wire z;
    
    integer i=0;
    reg[0:21] test_coin=22'b1010100010100010101000;
    //这是输入的硬币序列中 1 表示投入一枚硬币 0表示没有投入硬币 
    //要求的输出是投入四枚硬币后Z=1
    //输入序列1后面必定跟上一个0，因为1硬币投入的时间不可能是连续不断的投入
    parameter period = 10;
    
initial begin
    reset=1'b1;
    x =1'b0;
    //保证初始状态
    #(period);
    reset=1'b0;
    for(i=0;i<22;i=i+1)
    begin
        x = test_coin[i];
        //输入x从当前的硬币序列号转换成下一硬币序列号
        #period;
    end
end

    always 
    begin
        clock=1'b1;
        #(period);
        clock=1'b0;
        #(period);
    end
    
ex3 u_ex3(
    .X(x),
    .CLK(clock),
    .RESET(reset),
    .Z(z)
);
endmodule
