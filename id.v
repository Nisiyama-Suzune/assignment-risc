`include "defines.v"

module id(

	input wire rst,
	input wire[`InstAddrBus] pc_i,
	input wire[`InstBus]          inst_i,

	//处于执行阶段的指令要写入的目的寄存器信息
	input wire										ex_wreg_i,
	input wire[`RegBus]						ex_wdata_i,
	input wire[`RegAddrBus]       ex_wd_i,
	
	//处于访存阶段的指令要写入的目的寄存器信息
	input wire										mem_wreg_i,
	input wire[`RegBus]						mem_wdata_i,
	input wire[`RegAddrBus]       mem_wd_i,
	
	input wire[`RegBus]           reg1_data_i,
	input wire[`RegBus]           reg2_data_i,

	input wire[`AluOpBus] ex_aluop_i,

	//送到regfile的信息
	output reg                    reg1_read_o,
	output reg                    reg2_read_o,     
	output reg[`RegAddrBus]       reg1_addr_o,
	output reg[`RegAddrBus]       reg2_addr_o, 	      
	
	output reg branch_flag_o,
	output reg[`RegBus] branch_target_address_o,

	//送到执行阶段的信息
	output reg[`AluOpBus]         aluop_o,
	output reg[`AluSelBus]        alusel_o,
	output reg[`RegBus]           reg1_o,
	output reg[`RegBus]           reg2_o,
	output reg[`RegAddrBus]       wd_o,
	output reg                    wreg_o,
	output wire [`RegBus]     inst_o,

	output wire id_stallreq_o
);

	wire pre_inst_is_load;
	reg reg1_loadrelate, reg2_loadrelate;

	assign pre_inst_is_load = ((ex_aluop_i == `EXE_LB_OP) ||
								(ex_aluop_i == `EXE_LBU_OP) ||
								(ex_aluop_i == `EXE_LH_OP) ||
								(ex_aluop_i == `EXE_LHU_OP) ||
								(ex_aluop_i == `EXE_LW_OP));

	assign inst_o = inst_i;
	wire[6:0] op = inst_i[6:0];
	wire[2:0] op2 = inst_i[14:12];
	wire[6:0] op3 = inst_i[31:25];
	reg[`RegBus]	imm;
	reg instvalid;
  
	always @ (*) begin	
		if (rst == `RstEnable) begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			wd_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
			instvalid <= `InstValid;
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= `NOPRegAddr;
			reg2_addr_o <= `NOPRegAddr;
			imm <= 32'h0;			
			branch_flag_o <= `NotBranch;
	  end else begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			wd_o <= inst_i[11:7];
			wreg_o <= `WriteDisable;
			instvalid <= `InstInvalid;	   
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= inst_i[19:15];
			reg2_addr_o <= inst_i[24:20];		
			imm <= `ZeroWord;
			branch_flag_o <= `NotBranch;
			case (op)
				`EXE_OP: begin
					case (op2)
						`EXE_OP_ADD_SUB: begin
							if (op3 == 7'b0000000) begin
								wreg_o <= `WriteEnable; reg1_read_o <= 1'b1; reg2_read_o <= 1'b1; instvalid <= `InstValid;
								aluop_o <= `EXE_ADD_OP; alusel_o <= `EXE_RES_ARITHMETIC;	
							end else if (op3 == 7'b0100000) begin
								wreg_o <= `WriteEnable; reg1_read_o <= 1'b1; reg2_read_o <= 1'b1; instvalid <= `InstValid;
								aluop_o <= `EXE_SUB_OP; alusel_o <= `EXE_RES_ARITHMETIC;	
							end
						end
						`EXE_OP_SLT: begin
							wreg_o <= `WriteEnable; reg1_read_o <= 1'b1; reg2_read_o <= 1'b1; instvalid <= `InstValid;
							aluop_o <= `EXE_SLT_OP; alusel_o <= `EXE_RES_ARITHMETIC;	
						end
						`EXE_OP_SLTU: begin
							wreg_o <= `WriteEnable; reg1_read_o <= 1'b1; reg2_read_o <= 1'b1; instvalid <= `InstValid;
							aluop_o <= `EXE_SLTU_OP; alusel_o <= `EXE_RES_ARITHMETIC;	
						end
						`EXE_OP_OR: begin
							wreg_o <= `WriteEnable; reg1_read_o <= 1'b1; reg2_read_o <= 1'b1; instvalid <= `InstValid;
							aluop_o <= `EXE_OR_OP; alusel_o <= `EXE_RES_LOGIC;	
						end  
						`EXE_OP_AND: begin
							wreg_o <= `WriteEnable; reg1_read_o <= 1'b1; reg2_read_o <= 1'b1; instvalid <= `InstValid;
							aluop_o <= `EXE_AND_OP; alusel_o <= `EXE_RES_LOGIC;
						end  	
						`EXE_OP_XOR: begin
							wreg_o <= `WriteEnable; reg1_read_o <= 1'b1; reg2_read_o <= 1'b1; instvalid <= `InstValid;
							aluop_o <= `EXE_XOR_OP; alusel_o <= `EXE_RES_LOGIC;
						end
						`EXE_OP_SLL: begin
							wreg_o <= `WriteEnable; reg1_read_o <= 1'b1; reg2_read_o <= 1'b1; instvalid <= `InstValid;
							aluop_o <= `EXE_SLL_OP; alusel_o <= `EXE_RES_SHIFT;
						end 
						`EXE_OP_SRL_SRA: begin
							if (op3 == 7'b0000000) begin
								wreg_o <= `WriteEnable; reg1_read_o <= 1'b1; reg2_read_o <= 1'b1; instvalid <= `InstValid;
								aluop_o <= `EXE_SRL_OP; alusel_o <= `EXE_RES_SHIFT;
							end else if (op3 == 7'b0100000) begin
								wreg_o <= `WriteEnable; reg1_read_o <= 1'b1; reg2_read_o <= 1'b1; instvalid <= `InstValid;
								aluop_o <= `EXE_SRA_OP; alusel_o <= `EXE_RES_SHIFT;
							end
						end										  									
						default: begin
						end
					endcase
				end
				`EXE_OP_IMM: begin
					case (op2)
						`EXE_OP_ADDI: begin
							wreg_o <= `WriteEnable; reg1_read_o <= 1'b1; reg2_read_o <= 1'b0; imm <= {{20{inst_i[31]}}, inst_i[31:20]}; instvalid <= `InstValid;	
							alusel_o <= `EXE_RES_ARITHMETIC; aluop_o <= `EXE_ADD_OP;
						end
						`EXE_OP_SLTI: begin
							wreg_o <= `WriteEnable; reg1_read_o <= 1'b1; reg2_read_o <= 1'b0; imm <= {{20{inst_i[31]}}, inst_i[31:20]}; instvalid <= `InstValid;	
							alusel_o <= `EXE_RES_ARITHMETIC; aluop_o <= `EXE_SLT_OP;
						end			  
						`EXE_OP_SLTIU: begin
							wreg_o <= `WriteEnable; reg1_read_o <= 1'b1; reg2_read_o <= 1'b0; imm <= {{20{inst_i[31]}}, inst_i[31:20]}; instvalid <= `InstValid;	
							alusel_o <= `EXE_RES_ARITHMETIC; aluop_o <= `EXE_SLTU_OP;
						end			  
						`EXE_OP_ORI: begin
							wreg_o <= `WriteEnable; reg1_read_o <= 1'b1; reg2_read_o <= 1'b0; imm <= {{20{inst_i[31]}}, inst_i[31:20]}; instvalid <= `InstValid;	
							alusel_o <= `EXE_RES_LOGIC; aluop_o <= `EXE_XOR_OP;
						end
						`EXE_OP_ANDI: begin
							wreg_o <= `WriteEnable; reg1_read_o <= 1'b1; reg2_read_o <= 1'b0; imm <= {{20{inst_i[31]}}, inst_i[31:20]}; instvalid <= `InstValid;
							aluop_o <= `EXE_AND_OP; alusel_o <= `EXE_RES_LOGIC;	
						end	 	
						`EXE_OP_XORI: begin
							wreg_o <= `WriteEnable; reg1_read_o <= 1'b1; reg2_read_o <= 1'b0; imm <= {{20{inst_i[31]}}, inst_i[31:20]}; instvalid <= `InstValid;
							aluop_o <= `EXE_XOR_OP; alusel_o <= `EXE_RES_LOGIC;
						end
						`EXE_OP_SLLI: begin
							wreg_o <= `WriteEnable; reg1_read_o <= 1'b1; reg2_read_o <= 1'b0; imm <= {{20{inst_i[31]}}, inst_i[31:20]}; instvalid <= `InstValid;
							aluop_o <= `EXE_SLL_OP; alusel_o <= `EXE_RES_SHIFT;
						end 
						`EXE_OP_SRLI_SRAI: begin
							if (op3 == 7'b0000000) begin
								wreg_o <= `WriteEnable; reg1_read_o <= 1'b1; reg2_read_o <= 1'b0; imm <= {{20{inst_i[31]}}, inst_i[31:20]}; instvalid <= `InstValid;
								aluop_o <= `EXE_SRL_OP; alusel_o <= `EXE_RES_SHIFT;
							end else if (op3 == 7'b0100000) begin
								wreg_o <= `WriteEnable; reg1_read_o <= 1'b1; reg2_read_o <= 1'b0; imm <= {{20{inst_i[31]}}, inst_i[31:20]}; instvalid <= `InstValid;
								aluop_o <= `EXE_SRA_OP; alusel_o <= `EXE_RES_SHIFT;
							end
						end		
						default: begin
						end
					endcase
				end
				`EXE_OP_LUI: begin
		  				wreg_o <= `WriteEnable; aluop_o <= `EXE_OR_OP;
		  				alusel_o <= `EXE_RES_LOGIC; reg1_read_o <= 1'b0; reg2_read_o <= 1'b0;	  	
						imm <= {inst_i[31:12], 12'h0};		  	
						instvalid <= `InstValid;	
				end
				`EXE_OP_AUIPC: begin
		  				wreg_o <= `WriteEnable; aluop_o <= `EXE_OR_OP;
		  				alusel_o <= `EXE_RES_LOGIC; reg1_read_o <= 1'b0; reg2_read_o <= 1'b0;	  	
						imm <= {inst_i[31:12], 12'h0} + pc_i;		  	
						instvalid <= `InstValid;	
				end							  	
				`EXE_OP_JAL: begin
		  				wreg_o <= `WriteEnable; aluop_o <= `EXE_OR_OP;
		  				alusel_o <= `EXE_RES_LOGIC; reg1_read_o <= 1'b0; reg2_read_o <= 1'b0;	  	
						branch_flag_o <= `Branch;
						branch_target_address_o <= pc_i + {{11{inst_i[31]}},inst_i[31],inst_i[19:12],inst_i[20],inst_i[30:21],1'b0};
						imm <= {1'b0, pc_i + 4};
						instvalid <= `InstValid;	
				end
				`EXE_OP_JALR: begin
					wreg_o <= `WriteEnable; alusel_o <= `EXE_OR_OP;
		  			alusel_o <= `EXE_RES_LOGIC;	reg1_read_o <= 1'b0; reg2_read_o <= 1'b1;
					branch_flag_o <= `Branch;
					branch_target_address_o <= reg2_o+{{20{inst_i[31]}},inst_i[31:20]};
					imm <= {1'b0, pc_i + 4};
					instvalid <= `InstValid;
				end
				`EXE_OP_BRANCH: begin
					case (op2)
						3'b000: begin // BEQ
							wreg_o <= `WriteDisable; alusel_o <= `EXE_RES_JUMP_BRANCH;
							reg1_read_o <= 1'b1;
							reg2_read_o <= 1'b1;
							instvalid <= `InstValid;
							if (reg1_o == reg2_o) begin
								branch_flag_o <= 1'b1;
								branch_target_address_o <= pc_i+{{18{inst_i[31]}},inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8],1'b0};
							end
						end // case: 3'b000
						3'b001: begin // BNE
							wreg_o <= `WriteDisable;
							alusel_o <= `EXE_RES_JUMP_BRANCH;
							reg1_read_o <= 1'b1;
							reg2_read_o <= 1'b1;
							instvalid <= `InstValid;
							if (reg1_o != reg2_o) begin
								branch_flag_o <= 1'b1;
								branch_target_address_o <= pc_i+{{18{inst_i[31]}},inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8],1'b0};
							end
						end // case: 3'b000
						3'b100: begin // BLT
							wreg_o <= `WriteDisable;
							alusel_o <= `EXE_RES_JUMP_BRANCH;
							reg1_read_o <= 1'b1;
							reg2_read_o <= 1'b1;
							instvalid <= `InstValid;
							if ($signed(reg1_o) < $signed(reg2_o)) begin
								branch_flag_o <= 1'b1;
								branch_target_address_o <= pc_i+{{18{inst_i[31]}},inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8],1'b0};
							end			 
						end // case: 3'b100
						3'b101: begin // BGE
							wreg_o <= `WriteDisable;
							alusel_o <= `EXE_RES_JUMP_BRANCH;
							reg1_read_o <= 1'b1;
							reg2_read_o <= 1'b1;
							instvalid <= `InstValid;
							if ($signed(reg1_o) >= $signed(reg2_o)) begin
								branch_flag_o <= 1'b1;
								branch_target_address_o <= pc_i+{{18{inst_i[31]}},inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8],1'b0};
							end
						end // case: 3'b101
						3'b110: begin // BLTU
							wreg_o <= `WriteDisable;
							alusel_o <= `EXE_RES_JUMP_BRANCH;
							reg1_read_o <= 1'b1;
							reg2_read_o <= 1'b1;
							instvalid <= `InstValid;
							if (reg1_o < reg2_o) begin
								branch_flag_o <= 1'b1;
								branch_target_address_o <= pc_i+{{18{inst_i[31]}},inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8],1'b0};
							end			 
						end // case: 3'b110
						3'b111: begin
							wreg_o <= `WriteDisable;
							alusel_o <= `EXE_RES_JUMP_BRANCH;
							reg1_read_o <= 1'b1;
							reg2_read_o <= 1'b1;
							instvalid <= `InstValid;
							if (reg1_o >= reg2_o) begin
								branch_flag_o <= 1'b1;
								branch_target_address_o <= pc_i+{{18{inst_i[31]}},inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8],1'b0};
							end
						end // case: 3'b111
						default: begin end
					endcase
				end
		    	default: begin
		    	end
				`EXE_OP_LOAD: begin
					case (op2)
						3'b000:	begin
							wreg_o <= `WriteEnable;
							aluop_o <= `EXE_LB_OP; alusel_o <= `EXE_RES_LOAD_STORE;
							reg1_read_o <= 1'b1; reg2_read_o <= 1'b0;
							instvalid <= `InstValid;
						end
						3'b001: begin
							wreg_o <= `WriteEnable;
							aluop_o <= `EXE_LH_OP; alusel_o <= `EXE_RES_LOAD_STORE;
							reg1_read_o <= 1'b1; reg2_read_o <= 1'b0;
							instvalid <= `InstValid;
						end
						3'b010: begin
							wreg_o <= `WriteEnable;
							aluop_o <= `EXE_LW_OP; alusel_o <= `EXE_RES_LOAD_STORE;
							reg1_read_o <= 1'b1; reg2_read_o <= 1'b0;
							instvalid <= `InstValid;
						end
						3'b100: begin
							wreg_o <= `WriteEnable;
							aluop_o <= `EXE_LBU_OP; alusel_o <= `EXE_RES_LOAD_STORE;
							reg1_read_o <= 1'b1; reg2_read_o <= 1'b0;
							instvalid <= `InstValid;
						end
						3'b101: begin
							wreg_o <= `WriteEnable;
							aluop_o <= `EXE_LHU_OP; alusel_o <= `EXE_RES_LOAD_STORE;
							reg1_read_o <= 1'b1; reg2_read_o <= 1'b0;
							instvalid <= `InstValid;
						end
						default: begin end
					endcase
				end
				`EXE_OP_STORE: begin
					case (op2)
						3'b000: begin
							wreg_o <= `WriteDisable;
							aluop_o <= `EXE_SB_OP; alusel_o <= `EXE_RES_LOAD_STORE;
							reg1_read_o <= 1'b1; reg2_read_o <= 1'b1;
							instvalid <= `InstValid;
						end
						3'b001: begin
							wreg_o <= `WriteDisable;
							aluop_o <= `EXE_SH_OP; alusel_o <= `EXE_RES_LOAD_STORE;
							reg1_read_o <= 1'b1; reg2_read_o <= 1'b1;
							instvalid <= `InstValid;
						end
						3'b010: begin
							wreg_o <= `WriteDisable;
							aluop_o <= `EXE_SW_OP; alusel_o <= `EXE_RES_LOAD_STORE;
							reg1_read_o <= 1'b1; reg2_read_o <= 1'b1;
							instvalid <= `InstValid;
						end
						default: begin end
					endcase
				end
		  	endcase
		end
	end
	
	always @ (*) begin
		reg1_loadrelate <= `NoStop;
		if(rst == `RstEnable) begin
			reg1_o <= `ZeroWord;		
		end else if(pre_inst_is_load == 1'b1 && ex_wd_i == reg1_addr_o && reg1_read_o == 1'b1) begin
			reg1_loadrelate <= `Stop;
		end else if((reg1_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg1_addr_o)) begin
			if (reg1_addr_o == 5'b00000) begin
				reg1_o <= `ZeroWord;
			end else begin
				reg1_o <= ex_wdata_i; 
			end
		end else if((reg1_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg1_addr_o)) begin
			if (reg1_addr_o == 5'b00000) begin
				reg1_o <= `ZeroWord;
			end else begin
				reg1_o <= mem_wdata_i; 
			end
		end else if(reg1_read_o == 1'b1) begin
			reg1_o <= reg1_data_i;
		end else if(reg1_read_o == 1'b0) begin
			reg1_o <= imm;
		end else begin
			reg1_o <= `ZeroWord;
		end
	end
	
	always @ (*) begin
		reg2_loadrelate <= `NoStop;
		if(rst == `RstEnable) begin
			reg2_o <= `ZeroWord;
		end else if(pre_inst_is_load == 1'b1 && ex_wd_i == reg2_addr_o && reg2_read_o == 1'b1) begin
			reg2_loadrelate <= `Stop;
		end else if((reg2_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg2_addr_o)) begin
			if (reg2_addr_o == 5'b00000) begin
				reg2_o <= `ZeroWord;
			end else begin
				reg2_o <= ex_wdata_i; 
			end
		end else if((reg2_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg2_addr_o)) begin
			if (reg2_addr_o == 5'b00000) begin
				reg2_o <= `ZeroWord;
			end else begin
				reg2_o <= mem_wdata_i; 
			end
		end else if(reg2_read_o == 1'b1) begin
			reg2_o <= reg2_data_i;
		end else if(reg2_read_o == 1'b0) begin
			reg2_o <= imm;
		end else begin
			reg2_o <= `ZeroWord;
		end
	end
	
	assign id_stallreq_o = reg1_loadrelate | reg2_loadrelate;

endmodule
