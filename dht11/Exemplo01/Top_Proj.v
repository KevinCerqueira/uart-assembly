`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:10:12 04/11/2017 
// Design Name: 
// Module Name:    Top_Proj 
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
module Top_Proj(
	GPIO_DIP1,
	GPIO_LED1,
	CLK1HZ,
	CLK2HZ);

	//Entradas
	input GPIO_DIP1;
	input CLK1HZ;
	input CLK2HZ;
	
	//Saidas
	output GPIO_LED1;
	
	//Interlig.
	wire A;
	wire B;
   wire OUT;
   wire SEL;
	
	assign A = CLK1HZ;        //Conecta o DIP1 ao condutor de nome A
	assign B = CLK2HZ;	     //Conecta o condutor A ao LED1
	assign SEL = GPIO_DIP1;
	assign GPIO_LED1 = OUT;
	
   always @(SEL or A or B)
		begin
				if (SEL == 0)
					   OUT = A;
				else 
					   OUT = B;
		end					
endmodule
