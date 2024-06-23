
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

module MyUART 
				#(parameter DataBits = 9,ClkTicks = 16)
				
				(
				input clk,reset_n,
				
				//for timer
				
				input [11:0] FinalValue,
				
				//for transmitter
				
				input [DataBits-2:0] w_data,
				input wr_en,
				output T_full,

				//for reciever
				
				output [DataBits-2:0] r_data,
				input rd_en,
				output R_empty,

				output [$clog2(ClkTicks)-1:0] c_T,                            
				output [$clog2(DataBits)-1:0] n_T,
				output [$clog2(ClkTicks)-1:0] c_R,                            
				output [$clog2(DataBits)-1:0] n_R,
			   output error_check
				);
            
				//wires for connection of all blocks together
				
				wire tick_en;              // for both transmitter and reciever
				wire read_en_FIFO;         // for transmitter and its FIFO
				wire FIFO_T_empty;
				wire startT_en;            // for transmitter and its FIFO
				wire [DataBits-2:0] Data_FT;         // for transmitter and its FIFO
				
				wire write_en_FIFO;
				wire [DataBits-2:0] Data_RF; 
				wire data_TR;
				wire parityBit;
				
				
				// instantiation
				
				// Timer
				
				Timer #(.n(12)) Stage0
				(
				.clk(clk),
				.reset_n(reset_n),
				.final_value(FinalValue),              //input for the timer
				.done(tick_en)                                //output from the timer and sended to transmitter and reciever
				);   
				
				// FIFO for transmitter
				
				MyFIFO #(.DataBits(DataBits), .Adress(8)) Stage1
				(
				.clk(clk),
				.reset_n(reset_n),
			   .wr_en(wr_en),                                          //input from the top module
				.rd_en(read_en_FIFO),                                         //output form transmitter to FIFO
				.data_wr(w_data),                                           //input from the top module
				.data_rd(Data_FT),                                         //output from FIFO sended to the transmitter
				.empty(FIFO_T_empty),                                              //output signal from FIFO which indicates the transmitter can sen data
				.full(T_full)                                               //output from FIFO
				);
				
				// Transmitter
				assign startT_en = ~FIFO_T_empty;
				MyTransmitter #(.DataBits(DataBits), .ClkTicks(ClkTicks)) Stage2
				(
				.clk(clk),
				.reset_n(reset_n),
			   .tick(tick_en),                                            //input from timer to transmitter
				.DataIn(Data_FT),                                         //input data which be sended
				.DataTStart(startT_en),                                    //signal indicates to start transmitting
				.DataDone(read_en_FIFO),                                     //transmitting is over
				.DataT(data_TR),
				.parityBit(parityBit),
				.c(c_T),
				.n(n_T)
				);
				
				
				// Reciever
				
				MyReceiver #(.DataBits(DataBits), .ClkTicks(ClkTicks))  Stage3
				(
				.clk(clk),
				.reset_n(reset_n),
				.tick(tick_en),																		
				.DataR(data_TR),
				.DataDone(write_en_FIFO),
            .DataROut(Data_RF),
				.error_check(error_check),
				.n(n_R),
				.c(c_R)
				);
				
				
				// FIFO for reciever
				
				MyFIFO #(.DataBits(DataBits), .Adress(8)) Stage4
				(
				.clk(clk),
				.reset_n(reset_n),
			   .wr_en(write_en_FIFO),
				.rd_en(rd_en),
				.data_wr(Data_RF),
				.data_rd(r_data),
				.empty(R_empty),
				.full()
				);
				


endmodule
