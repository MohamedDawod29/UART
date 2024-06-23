
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mohamed Mabrouk Dawod
// 
// Create Date: 08/22/2023 
// Design Name: 
// Module Name: MyFIFO
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

module MyFIFO 
				#(parameter Adress = 8, // Depth of the FIFO
				parameter DataBits = 9) // Width of the data
				(
				input clk,reset_n,
				input rd_en,wr_en,
				input [DataBits-2:0] data_wr,
				output reg [DataBits-2:0] data_rd,
				output reg full,empty
				);
				
				reg [DataBits-2:0] MyFIFO [Adress-1:0];
				reg [2:0] wr_ptr,rd_ptr;
				reg [3:0] count;

				
				
				always @ (count)
				begin
					empty <= (count == 0);
					full <= (count == 8);
				end
				
				always @ (posedge clk,negedge reset_n)      //counter
				begin
					if (~reset_n)
						count <= 0;
					else if (!empty && rd_en)
						count <= count - 1;
					else if (!full && wr_en)
						count <= count + 1;
					else
						count <= count;
				end
				
				always @ (posedge clk,negedge reset_n)     //read
				begin
					if (~reset_n)
						data_rd <= 0;
					else
					begin
						if (!empty && rd_en)
							data_rd <= MyFIFO[rd_ptr];
						else
							data_rd <= data_rd;
					end
				end
				
				always @ (posedge clk)   //(write) Hint : there is no condition in reset because if it's asserted then we already write in FIFO and we don't need that
				begin
					if (!full && wr_en)
						MyFIFO[wr_ptr] <= data_wr ;
					else
						MyFIFO[wr_ptr] <= MyFIFO[wr_ptr];
				end
				
				always @ (posedge clk ,negedge reset_n)        //pointers
				begin
					if (~reset_n)
					begin
						wr_ptr <= 0;
						rd_ptr <= 0;
					end
					else
				   begin	
						if (!full && wr_en)
							wr_ptr <= wr_ptr + 1;
						else
							wr_ptr <= wr_ptr;
							
						if (!empty && rd_en)
							rd_ptr <= rd_ptr + 1;
						else
							rd_ptr <= rd_ptr;
					end
				end	
endmodule
						
								
