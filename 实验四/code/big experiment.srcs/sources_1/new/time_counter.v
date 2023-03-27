`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/06 09:12:15
// Design Name: 
// Module Name: time_counter
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
module time_counter(clk, pause_key, reset_key, start_key, sig_seg, CS, light, alert);
    input clk;              //����������ʱ�ӣ�100MHz
    input pause_key;        //��ͣ����
    input reset_key;        //���ð���
    input start_key;        //��ʼ��ʱ����
    output [7:0] sig_seg;   //��ʾ�����
    output [3:0] CS;        //��ѡ�ź�
    output light;       //��ʾ���ӵ�LED��
    output alert;       //������

    reg min =2'b00;         //����
    reg started = 1'b0;     //��ʾ��ǰ״̬��1��ʾ������ʱ��0��ʾ��ͣ
    reg temp = 4'd1;        //temp��started��أ�1��0��ʾ����һ��ʱ���źŵ����ӻ���ͣ״̬
    reg [7:0] sig_seg = 8'b0000_0000;       //�����
    reg [3:0] CS = 4'b1000;     //��ѡ�źţ�1000 ��ʾѡ���һ������
    reg light = 1'b0;
    reg alert = 1'b0;
    reg [16:0] ctr1 = 17'd0;    
    reg [16:0] ctr0 = 17'd0;    //�Զ���ʱ�ӱ�����ÿ1msѭ��һ��
    reg [1:0] ctr2 = 2'd0;      
    reg [3:0] ms = 4'd0;        //����λ
    reg [3:0] tms = 4'd0;       //ʮ����λ
    reg [3:0] hms = 4'd0;       //�ٺ���λ
    reg [3:0] s = 4'd0;         //��λ
    reg [3:0] ts = 4'd0;        //ʮ��λ

    reg [16:0] count_end = 17'd50618; //��������Ƶ�� ��ʾ����7
    reg [16:0] ctr_beep = 17'd0;//������������

    always@ (posedge clk or negedge reset_key or posedge start_key or posedge pause_key) begin      //clk�����ء����ü��½��ء���ʼ�������غ���ͣ�������ؿ�ʼִ�в���
        ctr_beep <= ctr_beep + 1'b1;
        
        //����������һ����Ƶ�ʽ��з���
        if(ctr_beep == count_end)begin
            ctr_beep <= 17'd0;
            if(temp == 4'd0)begin
                alert <= !alert;
            end
        end
        
        if(min == 2'b01) begin      //�������Ϊ1��������LED�ƹ�
            light <= 1;
        end

        if(!reset_key) begin        //����������ð��������������������ʱ����ʾ�йصļĴ�������
            started <= 1'b0;        //������ͣ״̬���������ֹ��㣬���¿�ʼ�����¼�ʱ       
            ctr1 <= 17'd0;          
            ctr2 <= 2'd0;
            ms <= 4'd0; 
            tms <= 4'd0;
            hms <= 4'd0;
            s <= 4'd0;
            ts <= 4'd0;
            min <= 2'b00;
            light <= 0;
            temp <= 4'd1;
            alert <= 0;
        end

        else begin
            if(start_key) begin         //������¿�ʼ������ʾ������ʱ
                started <= 1'b1;
            end
            
            if(pause_key) begin         //���������ͣ������started�Ĵ���������Ϊ0����ʾ��ͣ״̬
                started <= 1'b0;
            end

            if(ctr0 == 17'd10_0000) begin       //ctr0����ϵͳʱ�ӱ仯��ÿԾ��10_0000�δ���1ms
                ctr0 <= 17'd1;                  
                if(ctr2 != 2'd3) 
                    ctr2 <= ctr2 + 2'd1;
                else 
                    ctr2 <= 2'd0;
            end

            else begin
                ctr0 <= ctr0 + 1;
            end
            //==================
            if(ctr1 == 17'd10_0000 && started == 1'b1 ) begin          //ctr1ÿԾ��10_0000�Σ������1ms��msλ��1
                ctr1 <= 17'd1;                                         //��ʵctr1��ctr0�����������ͬ��ֻ����ctr0���ƶ�ѡ��������started�仯
                ms <= ms + temp;
            end

            else if (ctr1 !=17'd10_0000 && started == 1'b1 ) begin     
                ctr1 <= ctr1 + 1;
            end

            //==================
            if(ms == 4'd10 && ctr1 == 17'd10_0000 && started == 1'b1 ) begin       //��ʱ״̬��ms�ﵽ10����ʮ����λ��1
                ms <= 4'd0;
                tms <= tms + 4'd1;
            end

            if(tms == 4'd10 && ctr1 == 17'd10_0000 && started == 1'b1 ) begin       //��ʱ״̬��tms�ﵽ10����ٺ���λ��1
                tms <= 4'd0;
                hms <= hms + 4'd1;
            end

            if(hms == 4'd10 && ctr1 == 17'd10_0000 && started == 1'b1 ) begin       //��ʱ״̬��hms�ﵽ10������λ��1
                hms <= 4'd0;
                s <= s + 4'd1;
            end

            if(s == 4'd10 && ctr1 == 17'd10_0000 && started == 1'b1 ) begin         //��ʱ״̬��s�ﵽ10����ʮ��λ��1
                s <= 4'd0;
                ts <= ts + 4'd1;
            end

            //��ʱ״̬��ʮ��λ�ﵽ6��������λ��0.��λ��1
            if(ts == 4'd6 && ctr1 == 17'd10_0000 && started == 1'b1 && min == 2'b00) begin  
                min <= 2'b01;
                ms <= 4'd0;
                tms <= 4'd0;
                hms <= 4'd0;
                s <= 4'd0;
                ts <= 4'd0;
            end
            //��ʱ״̬��ʮ��λ�ﵽ6����λ�ﵽ1��������������λ��
            if(ts == 4'd6 && ctr1 == 17'd10_0000 && started == 1'b1 && min == 2'b01) begin   
                temp <= 4'd0;
            end
            
            //==============================
            case (ctr2)     //ctr2�����ѡ�źţ�0��1��2��3�ֱ��ʾѡ��һ�������
            2'd0:begin      //ctr2=0ʱ��ѡ���1��
                CS <= 4'b1000;
                case(ts)
                //////////////gfedcba////////////////////////////////////////////sig_seg���һλ��ʾС����      
                    4'd0:sig_seg <= 8'b0111_1110;               
                    4'd1:sig_seg <= 8'b0000_1100;//             a
                    4'd2:sig_seg <= 8'b1011_0110;//            __
                    4'd3:sig_seg <= 8'b1001_1110;//         f/   /b
                    4'd4:sig_seg <= 8'b1100_1100;//           g 
                    4'd5:sig_seg <= 8'b1101_1010;//          __
                    4'd6:sig_seg <= 8'b1111_1010;//       e /   /c
                    4'd7:sig_seg <= 8'b0000_1110;//          __     
                    4'd8:sig_seg <= 8'b1111_1110;//           d
                    4'd9:sig_seg <= 8'b1101_1110;
                    default:;
                endcase
            end
            2'd1:begin      //ctr2=1ʱ��ѡ���2��,
                CS <= 4'b0100;
                case(s)
                    4'd0:sig_seg <= 8'b0111_1111;
                    4'd1:sig_seg <= 8'b0000_1101;
                    4'd2:sig_seg <= 8'b1011_0111;
                    4'd3:sig_seg <= 8'b1001_1111;
                    4'd4:sig_seg <= 8'b1100_1101;
                    4'd5:sig_seg <= 8'b1101_1011;
                    4'd6:sig_seg <= 8'b1111_1011;
                    4'd7:sig_seg <= 8'b0000_1111;
                    4'd8:sig_seg <= 8'b1111_1111;
                    4'd9:sig_seg <= 8'b1101_1111;
                    default:;
                endcase
            end
            2'd2:begin      //ctr2=2ʱ��ѡ���3��
                CS <= 4'b0010;
                case(hms)
                    4'd0:sig_seg <= 8'b0111_1110;
                    4'd1:sig_seg <= 8'b0000_1100;
                    4'd2:sig_seg <= 8'b1011_0110;
                    4'd3:sig_seg <= 8'b1001_1110;
                    4'd4:sig_seg <= 8'b1100_1100;
                    4'd5:sig_seg <= 8'b1101_1010;
                    4'd6:sig_seg <= 8'b1111_1010;
                    4'd7:sig_seg <= 8'b0000_1110;
                    4'd8:sig_seg <= 8'b1111_1110;
                    4'd9:sig_seg <= 8'b1101_1110;
                    default:;
                endcase
            end
            2'd3:begin      //ctr2=3ʱ��ѡ���4��
                CS <= 4'b0001;
                case(tms)
                    4'd0:sig_seg <= 8'b0111_1110;
                    4'd1:sig_seg <= 8'b0000_1100;
                    4'd2:sig_seg <= 8'b1011_0110;
                    4'd3:sig_seg <= 8'b1001_1110;
                    4'd4:sig_seg <= 8'b1100_1100;
                    4'd5:sig_seg <= 8'b1101_1010;
                    4'd6:sig_seg <= 8'b1111_1010;
                    4'd7:sig_seg <= 8'b0000_1110;
                    4'd8:sig_seg <= 8'b1111_1110;
                    4'd9:sig_seg <= 8'b1101_1110;
                    default:;
                endcase
            end
            default:;
            endcase
        end
    end

endmodule