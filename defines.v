//ȫ��
`define RstEnable 1'b1
`define RstDisable 1'b0
`define ZeroWord 32'h00000000
`define WriteEnable 1'b1
`define WriteDisable 1'b0
`define ReadEnable 1'b1
`define ReadDisable 1'b0
`define AluOpBus 7:0
`define AluSelBus 2:0
`define InstValid 1'b0
`define InstInvalid 1'b1
`define Stop 1'b1
`define NoStop 1'b0
`define InDelaySlot 1'b1
`define NotInDelaySlot 1'b0
`define Branch 1'b1
`define NotBranch 1'b0
`define InterruptAssert 1'b1
`define InterruptNotAssert 1'b0
`define TrapAssert 1'b1
`define TrapNotAssert 1'b0
`define True_v 1'b1
`define False_v 1'b0
`define ChipEnable 1'b1
`define ChipDisable 1'b0

//ָ��
/*
`define EXE_AND  6'b100100
`define EXE_OR   6'b100101
`define EXE_XOR 6'b100110
`define EXE_NOR 6'b100111
`define EXE_ANDI 6'b001100
`define EXE_ORI  6'b001101
`define EXE_XORI 6'b001110
`define EXE_LUI 6'b001111

`define EXE_SLL  6'b000000
`define EXE_SLLV  6'b000100
`define EXE_SRL  6'b000010
`define EXE_SRLV  6'b000110
`define EXE_SRA  6'b000011
`define EXE_SRAV  6'b000111
`define EXE_SYNC  6'b001111
`define EXE_PREF  6'b110011

`define EXE_NOP 6'b000000
`define SSNOP 32'b00000000000000000000000001000000

`define EXE_SPECIAL_INST 6'b000000
`define EXE_REGIMM_INST 6'b000001
`define EXE_SPECIAL2_INST 6'b011100
*/

//AluOp
`define EXE_AND_OP   8'b00100100
`define EXE_OR_OP    8'b00100101
`define EXE_XOR_OP  8'b00100110
`define EXE_NOR_OP  8'b00100111
`define EXE_ANDI_OP  8'b01011001
`define EXE_ORI_OP  8'b01011010
`define EXE_XORI_OP  8'b01011011
`define EXE_LUI_OP  8'b01011100   

`define EXE_SLL_OP  8'b01111100
`define EXE_SLLV_OP  8'b00000100
`define EXE_SRL_OP  8'b00000010
`define EXE_SRLV_OP  8'b00000110
`define EXE_SRA_OP  8'b00000011
`define EXE_SRAV_OP  8'b00000111

`define EXE_MOVZ_OP  8'b00001010
`define EXE_MOVN_OP  8'b00001011
`define EXE_MFHI_OP  8'b00010000
`define EXE_MTHI_OP  8'b00010001
`define EXE_MFLO_OP  8'b00010010
`define EXE_MTLO_OP  8'b00010011

`define EXE_SLT_OP  8'b00101010
`define EXE_SLTU_OP  8'b00101011
`define EXE_SLTI_OP  8'b01010111
`define EXE_SLTIU_OP  8'b01011000   
`define EXE_ADD_OP  8'b00100000
`define EXE_ADDU_OP  8'b00100001
`define EXE_SUB_OP  8'b00100010
`define EXE_SUBU_OP  8'b00100011
`define EXE_ADDI_OP  8'b01010101
`define EXE_ADDIU_OP  8'b01010110
`define EXE_CLZ_OP  8'b10110000
`define EXE_CLO_OP  8'b10110001

`define EXE_MULT_OP  8'b00011000
`define EXE_MULTU_OP  8'b00011001
`define EXE_MUL_OP  8'b10101001

`define EXE_LB_OP 8'b11100000
`define EXE_LBU_OP 8'b11100100
`define EXE_LH_OP 8'b11100001
`define EXE_LHU_OP 8'b11100101
`define EXE_LW_OP 8'b11100011
`define EXE_SB_OP 8'b11101000
`define EXE_SH_OP 8'b11101001
`define EXE_SW_OP 8'b11101011

`define EXE_NOP_OP    8'b00000000

//AluSel
`define EXE_RES_LOGIC 3'b001
`define EXE_RES_SHIFT 3'b010
`define EXE_RES_MOVE 3'b011	
`define EXE_RES_ARITHMETIC 3'b100	
`define EXE_RES_JUMP_BRANCH 3'b101
`define EXE_RES_LOAD_STORE 3'b111

`define EXE_RES_NOP 3'b000

//OP
`define EXE_OP_IMM 7'b0010011
`define EXE_OP_ADDI 3'b000
`define EXE_OP_SLTI 3'b010
`define EXE_OP_SLTIU 3'b011
`define EXE_OP_XORI 3'b100
`define EXE_OP_ORI 3'b110
`define EXE_OP_ANDI 3'b111
`define EXE_OP_SLLI 3'b001
`define EXE_OP_SRLI_SRAI 3'b101

`define EXE_OP 7'b0110011
`define EXE_OP_ADD_SUB 3'b000
`define EXE_OP_SLT 3'b010
`define EXE_OP_SLTU 3'b011
`define EXE_OP_XOR 3'b100
`define EXE_OP_OR 3'b110
`define EXE_OP_AND 3'b111
`define EXE_OP_SLL 3'b001
`define EXE_OP_SRL_SRA 3'b101

`define EXE_OP_LUI 7'b0110111
`define EXE_OP_AUIPC 7'b0010111
`define EXE_OP_JAL 7'b1101111
`define EXE_OP_JALR	7'b1100111
`define EXE_OP_BRANCH 7'b1100011
`define EXE_OP_LOAD 7'b0000011
`define EXE_OP_STORE 7'b0100011

//ָ��洢��inst_rom
`define InstAddrBus 31:0
`define InstBus 31:0
`define InstMemNum 131071
`define InstMemNumLog2 17


//ͨ�üĴ���regfile
`define RegAddrBus 4:0
`define RegBus 31:0
`define RegWidth 32
`define DoubleRegWidth 64
`define DoubleRegBus 63:0
`define RegNum 32
`define RegNumLog2 5
`define NOPRegAddr 5'b00000

//���ݴ洢��data_ram
`define DataAddrBus 31:0
`define DataBus 31:0
`define DataMemNum 1024
`define ByteWidth 7:0
