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
    input clk;              //板子上内置时钟，100MHz
    input pause_key;        //暂停按键
    input reset_key;        //重置按键
    input start_key;        //开始计时按键
    output [7:0] sig_seg;   //表示数码管
    output [3:0] CS;        //段选信号
    output light;       //表示分钟的LED灯
    output alert;       //蜂鸣器

    reg min =2'b00;         //分钟
    reg started = 1'b0;     //表示当前状态，1表示正常计时，0表示暂停
    reg temp = 4'd1;        //temp与started相关，1和0表示另外一个时钟信号的增加或暂停状态
    reg [7:0] sig_seg = 8'b0000_0000;       //数码管
    reg [3:0] CS = 4'b1000;     //段选信号，1000 表示选择第一个数字
    reg light = 1'b0;
    reg alert = 1'b0;
    reg [16:0] ctr1 = 17'd0;    
    reg [16:0] ctr0 = 17'd0;    //自定义时钟变量，每1ms循环一次
    reg [1:0] ctr2 = 2'd0;      
    reg [3:0] ms = 4'd0;        //毫秒位
    reg [3:0] tms = 4'd0;       //十毫秒位
    reg [3:0] hms = 4'd0;       //百毫秒位
    reg [3:0] s = 4'd0;         //秒位
    reg [3:0] ts = 4'd0;        //十秒位

    reg [16:0] count_end = 17'd50618; //蜂鸣器的频率 表示低音7
    reg [16:0] ctr_beep = 17'd0;//蜂鸣器计数器

    always@ (posedge clk or negedge reset_key or posedge start_key or posedge pause_key) begin      //clk上升沿、重置键下降沿、开始键上升沿和暂停键上升沿开始执行操作
        ctr_beep <= ctr_beep + 1'b1;
        
        //蜂鸣器按照一定的频率进行蜂鸣
        if(ctr_beep == count_end)begin
            ctr_beep <= 17'd0;
            if(temp == 4'd0)begin
                alert <= !alert;
            end
        end
        
        if(min == 2'b01) begin      //如果分钟为1，则亮起LED灯光
            light <= 1;
        end

        if(!reset_key) begin        //如果按下重置按键，则清空现有所有与时钟显示有关的寄存器变量
            started <= 1'b0;        //进入暂停状态，其余数字归零，按下开始键重新计时       
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
            if(start_key) begin         //如果按下开始键，表示正常计时
                started <= 1'b1;
            end
            
            if(pause_key) begin         //如果按下暂停按键，started寄存器变量置为0，表示暂停状态
                started <= 1'b0;
            end

            if(ctr0 == 17'd10_0000) begin       //ctr0随着系统时钟变化，每跃变10_0000次代表1ms
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
            if(ctr1 == 17'd10_0000 && started == 1'b1 ) begin          //ctr1每跃变10_0000次，代表过1ms，ms位加1
                ctr1 <= 17'd1;                                         //其实ctr1与ctr0代表的意义相同，只不过ctr0控制段选，不随着started变化
                ms <= ms + temp;
            end

            else if (ctr1 !=17'd10_0000 && started == 1'b1 ) begin     
                ctr1 <= ctr1 + 1;
            end

            //==================
            if(ms == 4'd10 && ctr1 == 17'd10_0000 && started == 1'b1 ) begin       //计时状态且ms达到10，则十毫秒位进1
                ms <= 4'd0;
                tms <= tms + 4'd1;
            end

            if(tms == 4'd10 && ctr1 == 17'd10_0000 && started == 1'b1 ) begin       //计时状态且tms达到10，则百毫秒位进1
                tms <= 4'd0;
                hms <= hms + 4'd1;
            end

            if(hms == 4'd10 && ctr1 == 17'd10_0000 && started == 1'b1 ) begin       //计时状态且hms达到10，则秒位进1
                hms <= 4'd0;
                s <= s + 4'd1;
            end

            if(s == 4'd10 && ctr1 == 17'd10_0000 && started == 1'b1 ) begin         //计时状态且s达到10，则十秒位进1
                s <= 4'd0;
                ts <= ts + 4'd1;
            end

            //计时状态且十秒位达到6，则其余位置0.分位进1
            if(ts == 4'd6 && ctr1 == 17'd10_0000 && started == 1'b1 && min == 2'b00) begin  
                min <= 2'b01;
                ms <= 4'd0;
                tms <= 4'd0;
                hms <= 4'd0;
                s <= 4'd0;
                ts <= 4'd0;
            end
            //计时状态且十秒位达到6，分位达到1，即处于两分钟位置
            if(ts == 4'd6 && ctr1 == 17'd10_0000 && started == 1'b1 && min == 2'b01) begin   
                temp <= 4'd0;
            end
            
            //==============================
            case (ctr2)     //ctr2代表段选信号，0，1，2，3分别表示选择一段数码管
            2'd0:begin      //ctr2=0时，选择第1段
                CS <= 4'b1000;
                case(ts)
                //////////////gfedcba////////////////////////////////////////////sig_seg最后一位表示小数点      
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
            2'd1:begin      //ctr2=1时，选择第2段,
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
            2'd2:begin      //ctr2=2时，选择第3段
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
            2'd3:begin      //ctr2=3时，选择第4段
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