`timescale 1ns / 1ps
module testbench ();
	reg clk_100M = 1'b0;
	reg reset = 1'b1;
	reg pause = 1'b0;
	reg start = 1'b0;
	wire [7:0] sig;
	wire [3:0] cs;
	wire light_60s;
	wire alert_120s;
	
	always #1 clk_100M <= ~clk_100M;
	
	initial begin
		//��ʼ״̬��ȫ��ť����
		
		#5000				 
		start <= 1'b1;			//���¿�ʼ��ť
		#100			
		start <= 1'b0;			//�ɿ���ʼ��ť
		
		#5000
		pause <= 1'b1;			//������ͣ��ť
		#100				
		pause <= 1'b0;			//�ɿ���ͣ��ť
		
		#5000
		start <= 1'b1;			//���¼�����ť
		#100				
		start <= 1'b0;			//�ɿ�������ť
		
		#5000
		pause <= 1'b1;			//������ͣ��ť
		#100			
		pause <= 1'b0;			//�ɿ���ͣ��ť

		#5000
		reset <= 1'b0;			//�������ð�ť
		#100			
		reset <= 1'b1;			//�ɿ����ð�ť

		#5000			 
		start <= 1'b1;			//���¿�ʼ��ť
		#100				
		start <= 1'b0;			//�ɿ���ʼ��ť

		#5000
		pause <= 1'b1;			//������ͣ��ť
		#100				
		pause <= 1'b0;			//�ɿ���ͣ��ť

		#5000
		reset <= 1'b0;			//�������ð�ť
		#100			
		reset <= 1'b1;			//�ɿ����ð�ť
	end
	
	time_counter TC(
		.clk( clk_100M ),
		.pause_key( pause ),
		.reset_key( reset ),
		.start_key( start ),
		.sig_seg( sig ),
		.CS( cs ),
		.light( light_60s ),
		.alert( alert_120s )
	);
	
endmodule