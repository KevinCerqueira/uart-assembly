`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:13:47 04/11/2017
// Design Name:   Top_Proj
// Module Name:   C:/ProjetosXilinx/Exemplo01/Tb_Proj.v
// Project Name:  Exemplo01
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Top_Proj
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Tb_Proj;

	// Inputs
	reg GPIO_DIP1;

	// Outputs
	wire GPIO_LED1;

	// Instantiate the Unit Under Test (UUT)
	Top_Proj uut (
		.GPIO_DIP1(GPIO_DIP1), 
		.GPIO_LED1(GPIO_LED1)
	);

	initial begin
		// Initialize Inputs
		GPIO_DIP1 = 0;

		// Wait 100 ns for global reset to finish
		#100;
		GPIO_DIP1 = 0;
		#100
		GPIO_DIP1 = 1;
		#100
		GPIO_DIP1 = 0;
		#100
		GPIO_DIP1 = 1;
		#100
		GPIO_DIP1 = 0;
		#100
		GPIO_DIP1 = 1;
		#100
		GPIO_DIP1 = 0;
		#100
		GPIO_DIP1 = 1;
		#100
		GPIO_DIP1 = 0;
		#100
		GPIO_DIP1 = 1;
			
        
		// Add stimulus here

	end
      
endmodule

