//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2014 leishangwen@163.com                       ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
// Module:  ex_mem
// File:    ex_mem.v
// Author:  Lei Silei
// E-mail:  leishangwen@163.com
// Description: EX/MEM阶段的寄存器
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module ex_mem(

	input	wire										clk,
	input wire										rst,
	
	//来自执行阶段的信息	
   input wire [`RegAddrBus] ex_wd,
   input wire 		    ex_wreg,
   input wire [`RegBus]     ex_wdata, 

   input wire [`AluOpBus]   ex_aluop,
   input wire [`RegBus]     ex_mem_addr,
   input wire [`RegBus]     ex_reg2,
   
   //送到访存阶段的信息
   output reg [`RegAddrBus] mem_wd,
   output reg 		    mem_wreg,
   output reg [`RegBus]     mem_wdata,

   output reg [`AluOpBus]   mem_aluop,
   output reg [`RegBus]     mem_mem_addr,
   output reg [`RegBus]     mem_reg2

);


	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `WriteDisable;
			mem_wdata <= `ZeroWord;
			mem_aluop <= `EXE_NOP_OP;
			mem_mem_addr <= `ZeroWord;
			mem_reg2 <= `ZeroWord;
		end else begin
			mem_wd <= ex_wd;
			mem_wreg <= ex_wreg;
			mem_wdata <= ex_wdata;	
			mem_aluop <= ex_aluop;
			mem_mem_addr <= ex_mem_addr;
			mem_reg2 <= ex_reg2;
		end    //if
	end      //always
			

endmodule
