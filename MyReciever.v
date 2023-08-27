
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mohamed Mabrouk Dawod
// 
// Create Date: 08/23/2023 
// Design Name: 
// Module Name: MyReceiver
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
module MyReceiver 
						 #(parameter DataBits = 9,ClkTicks = 16)
						 (
						 input clk,reset_n,
						 input tick,
						 input DataR,
						 output reg DataDone,
						 output reg error_check,                                           //shows that the recieved data are correct or incorrect
						 output [DataBits-2:0] DataROut,
						 output [$clog2(ClkTicks)-1:0] c,                            
						 output [$clog2(DataBits)-1:0] n
						 );
						 
						 // registers for the present state and next state
						 
						 reg [1:0] Q_next , Q_present;
						 
						 reg [$clog2(ClkTicks)-1:0] c_next, c_present;                                 //counter for the clock ticks 
						 
						 reg [$clog2(DataBits)-1:0] n_next, n_present;                         //counter for the number of shifted bits from the data
						 
						 reg [DataBits-2:0] st_next, st_present;                                  //register to store the data from transmitter during the process			 
						 
						 reg parity_next,parity_present;
						 
						 //states
						 
						 localparam idle = 0, start = 1, recieve = 2, stop = 3;
						 
						 
	                //present state
						 
						 always @ (posedge clk,negedge reset_n)
						 begin
							
							if (~reset_n)
							begin
								
								Q_present <= idle;
								c_present <= 0;
								n_present <= 0;
								st_present <= 0;
								parity_present <= 0;
							end
							
							else
							begin
							
								Q_present <= Q_next;
								c_present <= c_next;
								n_present <= n_next;
								st_present <= st_next;
								parity_present	<=	parity_next;			
								
							end
							
						end
						
						
						//next state
						
						always @ (*)
						begin
						
							Q_next = Q_present;
							st_next = st_present;
							c_next = c_present;
							n_next = n_present;
							DataDone = 1'b0;
							parity_next = parity_present;
							error_check = 0;
							
							case (Q_present)
								
								idle:                                      // First state in which the transmitter prepared to transmit the data
								begin
								
									if (~DataR)
									begin
										c_next = 0;
										Q_next = start;
									end
									
									else
										Q_next = idle;
									
								end
								
								start:                                      // Second state in which start transmitting the data
								begin
									
									if (tick)
									begin
									
										if (c_next == 7)
										begin
										
											c_next = 0;
											n_next = 0;
											Q_next = recieve;
											
										end
										else
										begin
										
											c_next = c_next + 1;
											Q_next = start;
										
										end
										
									end
									else
									
										Q_next = start;
								end
								
								recieve:                                              // Third state in which transimtting the data process is happened
								begin
								
									if (tick)
									begin
									
										if (c_next == (ClkTicks-1))
										begin
											
											st_next = {DataR,st_next[DataBits-2:1]};
											c_next = 0;
											parity_next = parity_next ^ DataR;

											if (n_next == (DataBits-1))
											begin
												DataDone = 1'b1;
												Q_next = stop;
												error_check = (parity_next == DataR);
											end
												
											else
											begin
												n_next = n_next + 1;
												Q_next = recieve;
											end
											
										end
										
										else
										begin
											c_next = c_next + 1;
											Q_next = recieve;
										end
									
									end
									
									else
										Q_next = recieve;
								end
			 
								stop:                                                               // Fourth state in which stop transmitting the data
								begin
								
									if (tick)
									begin
									
										if (c_next == (ClkTicks-1))
										begin
											Q_next = idle;								
										end
										else
										begin
										
											c_next = c_next + 1;
											Q_next = stop;
										
										end
										
									end
									
									else
										Q_next = stop;
								end
								
								default:
									Q_next = idle;
									
							endcase
						
						end
							
					//output 
					
					
					assign DataROut = st_present;
					assign n = n_present;
					assign c = c_present;
								
endmodule


						 


