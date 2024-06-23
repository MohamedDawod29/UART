
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mohamed Mabrouk Dawod
// 
// Create Date: 08/18/2023 
// Design Name: 
// Module Name: Timer
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
module Timer 
				#(parameter n = 8)
				(
				input clk,reset_n,
				input [n-1:0] final_value,
				output reg done
				);
				
				reg [n-1:0] Q;
				
				always @ (posedge clk , negedge reset_n)
				begin
					if (~reset_n)
						Q <= 'b0;
					
					else
					begin
						if ( Q == final_value)
						begin
							done <= 1'b1;
							Q <= 'b0;
						end
						else 
						begin
							done <= 1'b0;
							Q <= Q+1;
						end
					end
				end
endmodule 					
					
