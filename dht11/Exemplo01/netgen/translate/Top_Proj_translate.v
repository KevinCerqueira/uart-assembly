////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: P.20131013
//  \   \         Application: netgen
//  /   /         Filename: Top_Proj_translate.v
// /___/   /\     Timestamp: Tue Apr 11 15:22:01 2017
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -intstyle ise -insert_glbl true -w -dir netgen/translate -ofmt verilog -sim Top_Proj.ngd Top_Proj_translate.v 
// Device	: 6slx9csg324-2
// Input file	: Top_Proj.ngd
// Output file	: C:\ProjetosXilinx\Exemplo01\netgen\translate\Top_Proj_translate.v
// # of Modules	: 1
// Design Name	: Top_Proj
// Xilinx        : C:\Xilinx\14.7\ISE_DS\ISE\
//             
// Purpose:    
//     This verilog netlist is a verification model and uses simulation 
//     primitives which may not represent the true implementation of the 
//     device, however the netlist is functionally correct and should not 
//     be modified. This file cannot be synthesized and should only be used 
//     with supported simulation tools.
//             
// Reference:  
//     Command Line Tools User Guide, Chapter 23 and Synthesis and Simulation Design Guide, Chapter 6
//             
////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns/1 ps

module Top_Proj (
  GPIO_DIP1, GPIO_LED1
);
  input GPIO_DIP1;
  output GPIO_LED1;
  wire GPIO_DIP1_IBUF_0;
  wire GPIO_LED1_OBUF_1;
  wire NlwRenamedSig_IO_GPIO_DIP1;
  assign
    NlwRenamedSig_IO_GPIO_DIP1 = GPIO_DIP1;
  X_BUF   GPIO_DIP1_IBUF (
    .I(NlwRenamedSig_IO_GPIO_DIP1),
    .O(GPIO_DIP1_IBUF_0)
  );
  X_INV   GPIO_LED11_INV_0 (
    .I(GPIO_DIP1_IBUF_0),
    .O(GPIO_LED1_OBUF_1)
  );
  X_IPAD #(
    .LOC ( "B3" ))
  GPIO_DIP1_4 (
    .PAD(NlwRenamedSig_IO_GPIO_DIP1)
  );
  X_OPAD #(
    .LOC ( "P4" ))
  GPIO_LED1_5 (
    .PAD(GPIO_LED1)
  );
  X_PD   GPIO_DIP1_PULLDOWN (
    .O(NlwRenamedSig_IO_GPIO_DIP1)
  );
  X_OBUF   GPIO_LED1_OBUF (
    .I(GPIO_LED1_OBUF_1),
    .O(GPIO_LED1)
  );
endmodule


`ifndef GLBL
`define GLBL

`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;

    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule

`endif

