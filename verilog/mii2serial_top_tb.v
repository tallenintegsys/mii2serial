//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:20:32 11/21/2021 
// Design Name: 
// Module Name:    RGMIIulator_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module mii2serial_top_tb;
reg		clk				= 0;
reg		SW0				= 0;
reg		uart_rx_serial;
wire	uart_tx_serial;
wire	[7:0]LED		= 8'b00000000;
reg		mii0_en			= 0;
reg		mii0_clk		= 0;
reg		[0:3] mii0_d	= 4'b0000;

localparam dst = 48'h54_ff_01_21_23_24;
localparam src = 48'h12_34_56_78_9a_bc;
localparam type =16'h1234;
localparam data = "Twas' on the good ship Venus...";
localparam crc = 32'hfb029064; //we can ignore this

integer i;
reg [7:0]c;

initial begin
	$dumpfile("mii2serial_top.vcd");
	$dumpvars(0, mii2serial_top_tb);
	#0	SW0 = 0; // reset
	#5	SW0 = 1; // reset
	#20	SW0 = 0; // reset
	#5;
	//start of packet
	mii0_en = 1;
	//preamble
	for (i=0; i<7; i=i+1) begin
		mii0_d = 4'b1010;
		#40;
		mii0_d = 4'b1010;
		#40;
	end
	//start of frame delimeter
	mii0_d = 4'b1010;
	#40;
	mii0_d = 4'b1011;
	//dst
	#40 mii0_d = {dst[40],dst[41],dst[42],dst[43]};
	#40 mii0_d = {dst[44],dst[45],dst[46],dst[47]};
	#40 mii0_d = {dst[32],dst[33],dst[34],dst[35]};
	#40 mii0_d = {dst[36],dst[37],dst[38],dst[39]};
	#40 mii0_d = {dst[24],dst[25],dst[26],dst[27]};
	#40 mii0_d = {dst[28],dst[29],dst[30],dst[31]};
	#40 mii0_d = {dst[16],dst[17],dst[18],dst[19]};
	#40 mii0_d = {dst[20],dst[21],dst[22],dst[23]};
	#40 mii0_d = {dst[8],dst[9],dst[10],dst[11]};
	#40 mii0_d = {dst[12],dst[13],dst[14],dst[15]};
	#40 mii0_d = {dst[0],dst[1],dst[2],dst[3]};
	#40 mii0_d = {dst[4],dst[5],dst[6],dst[7]};
	//src
	#40 mii0_d = {src[40],src[41],src[42],src[43]};
	#41 mii0_d = {src[44],src[45],src[46],src[47]};
	#40 mii0_d = {src[32],src[33],src[34],src[35]};
	#40 mii0_d = {src[36],src[37],src[38],src[39]};
	#40 mii0_d = {src[24],src[25],src[26],src[27]};
	#40 mii0_d = {src[28],src[29],src[30],src[31]};
	#40 mii0_d = {src[16],src[17],src[18],src[19]};
	#40 mii0_d = {src[20],src[21],src[22],src[23]};
	#40 mii0_d = {src[8],src[9],src[10],src[11]};
	#40 mii0_d = {src[12],src[13],src[14],src[15]};
	#40 mii0_d = {src[0],src[1],src[2],src[3]};
	#40 mii0_d = {src[4],src[5],src[6],src[7]};
	//type
	#40 mii0_d = {type[8],type[9],type[10],type[11]};
	#40 mii0_d = {type[12],type[13],type[14],type[15]};
	#40 mii0_d = {type[0],type[1],type[2],type[3]};
	#40 mii0_d = {type[4],type[5],type[6],type[7]};
	//payload
	for (i=30*8; i; i=i-8) begin
		c = {data[i+7],data[i+6],data[i+5],data[i+4],data[i+3],data[i+2],data[i+1],data[i+0]};
		#40 mii0_d = {c[0],c[1],c[2],c[3]};
		#40 mii0_d = {c[4],c[5],c[6],c[7]};
	end
	//crc
	#40 mii0_d = {crc[24],crc[25],crc[26],crc[27]};
	#40 mii0_d = {crc[28],crc[29],crc[30],crc[31]};
	#40 mii0_d = {crc[16],crc[17],crc[18],crc[19]};
	#40 mii0_d = {crc[20],crc[21],crc[22],crc[23]};
	#40 mii0_d = {crc[8],crc[9],crc[10],crc[11]};
	#40 mii0_d = {crc[12],crc[13],crc[14],crc[15]};
	#40 mii0_d = {crc[0],crc[1],crc[2],crc[3]};
	#40 mii0_d = {crc[4],crc[5],crc[6],crc[7]};
	//end of packet
	mii0_en = 0;
	//we're done
	#5000000	$finish;
end

always #10 clk = !clk;
always #20 mii0_clk = !mii0_clk;


mii2serial_top uut(
	.clk(clk),
	.SW0(SW0),
	.uart_rx_serial(uart_rx_serial),
	.uart_tx_serial(uart_tx_serial),
	.LED(LED),
	.mii0_en(mii0_en),
	.mii0_clk(mii0_clk),
	.mii0_d(mii0_d)
);
endmodule
