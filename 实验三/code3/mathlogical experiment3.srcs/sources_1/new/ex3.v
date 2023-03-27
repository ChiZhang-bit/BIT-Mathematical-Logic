`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2021/05/11 14:12:05
// Designer Name:Chi Zhang
// Student ID: 1120191600 
// Module Name: ex3
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ex3(X,Z,CLK,RESET);
    input X;
    input CLK;
    input RESET;
    output Z;
    reg[1:0] state , next_state;
    parameter A=2'b00 , B=2'b01 , C=2'b10 , D=2'b11;//Ϊÿ��״̬�����Ӧ�Ķ�������
    reg Z;
    
    //state register:implements positive edge-triggered
    //ֻ��ʱ������͸�λ����������ش���
    always @(posedge CLK or posedge RESET)
    begin
        if(RESET)//��λת���ɳ�ʼ��״̬
            state<=A;
        else//����ǰ״̬ת��Ϊ��һ״̬?
            state<=next_state;
    end  
    
    //output function: implements output as function
    //of X and state
    always @(X or state)
    begin
        case(state)
            A: Z = 1'b0;
            B: Z = 1'b0;
            C: Z = 1'b0;
            D: Z = X ? 1'b1 : 1'b0;
        endcase
    end
    
    //function : implements next state as function
    //of X and state    
    always @(X or state)
    begin
        case(state)
            A:next_state <= X ? B : A;//ǰ��Ϊ����X=1����һ״̬������Ϊ����X=0����һ״̬??
            B:next_state <= X ? C : B;
            C:next_state <= X ? D : C;
            D:next_state <= X ? A : D;
        endcase
    end

endmodule
