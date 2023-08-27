
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mohamed Mabrouk Dawod
// 
// Create Date: 08/24/2023 
// Design Name: 
// Module Name: MyUART
// Project Name: UART
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
module MyUART_TB;
				  parameter DataBits = 9, ClkTicks = 16;

				reg clk,reset_n;
				
				//for timer
				
				reg [11:0] FinalValue;
				
				//for transmitter
				
				reg [DataBits-2:0] w_data;
				reg wr_en;
				wire T_full;

				//for reciever
				
				wire [DataBits-2:0] r_data;
				reg rd_en;
				wire R_empty;

				wire [$clog2(ClkTicks)-1:0] c_T;
				wire [$clog2(DataBits)-1:0] n_T;
				wire [$clog2(ClkTicks)-1:0] c_R;                            
				wire [$clog2(DataBits)-1:0] n_R;
			   wire error_check;

				  // Instantiation
				  MyUART #(.DataBits(DataBits), .ClkTicks(ClkTicks))
				  DUT (
					 .clk(clk),
					 .reset_n(reset_n),
					 .FinalValue(FinalValue),
					 .w_data(w_data),
					 .wr_en(wr_en),
					 .T_full(T_full),
					 .error_check(error_check),
					 .c_T(c_T),
					 .n_T(n_T),
					 .c_R(c_R),
					 .n_R(n_R),
					 .r_data(r_data),
					 .rd_en(rd_en),
					 .R_empty(R_empty)
				  );

				  initial begin
					 reset_n = 1'b0;
					 clk = 0;
					 rd_en = 0;
					 wr_en = 0;
					 FinalValue = 650;
					 #10;
					 reset_n = 1'b1;
				  end

				  always #5 clk = ~clk;

				  initial begin
					 #100;
					 w_data = 8'b00011101; // 29 in decimal
					 wr_en = 1'b1;
					 #10;
					 wr_en = 1'b0;
					 #1090000;
					 	
					 w_data = 8'b10000010; // 130 in decimal
					 wr_en = 1'b1;
					 #10;
					 wr_en = 1'b0;
					 #1090000;
					 
					 w_data = 8'b00010001; // 17 in decimal
					 wr_en = 1'b1;
					 #10;
					 wr_en = 1'b0;
					 #1090000;
					 
					 w_data = 8'b00000000; // 0 in decimal
					 wr_en = 1'b1;
					 #10;
					 wr_en = 1'b0;
					 #1090000;
					 
					 w_data = 8'b01110000; // 112 in decimal
					 wr_en = 1'b1;
					 #10;
					 wr_en = 1'b0;
					 #1090000;
					 
					 
					 w_data = 8'b11010100; // 212 in decimal
					 wr_en = 1'b1;
					 #10;
					 wr_en = 1'b0;
					 #1090000;
					 
					 					
				  	 w_data = 8'b00000111; // 7 in decimal
					 wr_en = 1'b1;
					 #10;
					 wr_en = 1'b0;
					 #1090000;
					 
					 w_data = 8'b00011011; // 27 in decimal
					 wr_en = 1'b1;
					 #10;
					 wr_en = 1'b0;
				  end


				
					 initial 
					 begin
					 #10000;
					 rd_en = 1'b1;
					 #10;
					 rd_en = 1'b0;
					 #1090000;
					 	
					 rd_en = 1'b1;
					 #10;
					 rd_en = 1'b0;
					 #1090000;
					 
					 rd_en = 1'b1;
					 #10;
					 rd_en = 1'b0;
					 #1090000;
					 
					 rd_en = 1'b1;
					 #10;
					 rd_en = 1'b0;
					 #1090000;
					 
					 rd_en = 1'b1;
					 #10;
					 rd_en = 1'b0;
					 #1090000;
					 
					  rd_en = 1'b1;
					 #10;
					 rd_en = 1'b0;
					 #1090000;
					 
					  rd_en = 1'b1;
					 #10;
					 rd_en = 1'b0;
					 #1090000;
					 
					  rd_en = 1'b1;
					 #10;
					 rd_en = 1'b0;
					 end


				  
endmodule
