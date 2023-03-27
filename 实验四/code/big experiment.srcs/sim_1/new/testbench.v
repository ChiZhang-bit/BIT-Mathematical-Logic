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
		//初始状态，全按钮弹起
		
		#5000				 
		start <= 1'b1;			//按下开始按钮
		#100			
		start <= 1'b0;			//松开开始按钮
		
		#5000
		pause <= 1'b1;			//按下暂停按钮
		#100				
		pause <= 1'b0;			//松开暂停按钮
		
		#5000
		start <= 1'b1;			//按下继续按钮
		#100				
		start <= 1'b0;			//松开继续按钮
		
		#5000
		pause <= 1'b1;			//按下暂停按钮
		#100			
		pause <= 1'b0;			//松开暂停按钮

		#5000
		reset <= 1'b0;			//按下重置按钮
		#100			
		reset <= 1'b1;			//松开重置按钮

		#5000			 
		start <= 1'b1;			//按下开始按钮
		#100				
		start <= 1'b0;			//松开开始按钮

		#5000
		pause <= 1'b1;			//按下暂停按钮
		#100				
		pause <= 1'b0;			//松开暂停按钮

		#5000
		reset <= 1'b0;			//按下重置按钮
		#100			
		reset <= 1'b1;			//松开重置按钮
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