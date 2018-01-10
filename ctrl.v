`ifdef ctrl.v
`else
`define ctrl.v
// ----------------------------------------------------------------------------------------------------
`include "defines.v"

module ctrl (
   input wire 	    rst,
   input wire 	    id_stallreq_i,

   output reg [5:0] stall_o 
);

	always @ (*) 
	begin
		if(rst == `RstEnable) stall_o <= 6'b000000;
		else if (id_stallreq_i == 1'b1) stall_o <= 6'b000011;
		else stall_o <= 6'b000000;
	end // always @ (*)

endmodule // ctrl

// ----------------------------------------------------------------------------------------------------
`endif
