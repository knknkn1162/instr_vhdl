library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package type_pkg is
  constant CONST_SHAMT_SIZE : natural := 5;
  constant CONST_FUNCT7_SIZE : natural := 7;
  constant CONST_FUNCT3_SIZE : natural := 3;
  constant CONST_IMM12_SIZE : natural := 12;
  constant CONST_IMM20_SIZE : natural := 20;
  constant CONST_OPCODE_SIZE : natural := 7;
  constant CONST_REG_ADDR_SIZE : natural := 5;
  constant CONST_CSR_SIZE : natural := 12;
  subtype shamt_vector is std_logic_vector(CONST_SHAMT_SIZE-1 downto 0);
  subtype funct7_vector is std_logic_vector(CONST_FUNCT7_SIZE-1 downto 0);
  subtype imm12_vector is std_logic_vector(CONST_IMM12_SIZE-1 downto 0);
  subtype imm20_vector is std_logic_vector(CONST_IMM20_SIZE-1 downto 0);
  subtype reg_addr_vector is std_logic_vector(CONST_REG_ADDR_SIZE-1 downto 0);
  subtype opcode_vector is std_logic_vector(CONST_OPCODE_SIZE-1 downto 0);
  subtype funct3_vector is std_logic_vector(CONST_FUNCT3_SIZE-1 downto 0);
  subtype csr_vector is std_logic_vector(CONST_CSR_SIZE-1 downto 0);

  -- beq, bne, blt, bge, bltu, bgeu
  constant CONST_OP_BRANCH : opcode_vector := "1100011";
  constant CONST_OP_LOAD : opcode_vector := "0000011";
  constant CONST_OP_STORE : opcode_vector := "0100011";
  constant CONST_OP_ALUI : opcode_vector := "0010011";
  constant CONST_OP_RTYPE : opcode_vector := "0110011";

  -- U-type
  -- auipc : Add upper immediate to PC
  constant CONST_OP_AUIPC : opcode_vector := "0010111";
  -- lui : Load Upper Immediate
  constant CONST_OP_LUI : opcode_vector := "0110111";

  -- guarantee ordering between memory operations from different RISC-V harts.
  constant CONST_OP_FENCE : opcode_vector := "0001111";
  -- e.g) ECALL, EBREAK, CSR**
  constant CONST_OP_SYSTEM : opcode_vector := "1110011";
  constant CONST_OP_JAL : opcode_vector := "1101111";
  -- I-type instruction
  constant CONST_OP_JALR : opcode_vector := "1100111";

  -- R-type or I-type with ALU
  constant CONST_FUNCT3_ADD_SUB : funct3_vector := "000";
  constant CONST_FUNCT3_SLT : funct3_vector := "010";
  constant CONST_FUNCT3_XOR : funct3_vector := "100";
  constant CONST_FUNCT3_OR : funct3_vector := "110";
  constant CONST_FUNCT3_AND : funct3_vector := "111";
  constant CONST_FUNCT3_SLL : funct3_vector := "001";
  constant CONST_FUNCT3_SRL_SRA : funct3_vector := "101";
  
  -- SRL or SRA
  function shift_or_not(funct3 : funct3_vector) return std_logic;
  function srl_or_sra(funct7: funct7_vector) return std_logic;
  function add_or_sub(funct7 : funct7_vector) return std_logic;
end package;

package body type_pkg is

  function shift_or_not(funct3 : funct3_vector) return std_logic is
    variable res : std_logic;
  begin
    -- 001 or 101
    if funct3(1 downto 0) = "01" then
      res := '0';
    else
      res := '1';
    end if;
    return res;
  end function;

  function srl_or_sra(funct7: funct7_vector) return std_logic is
  begin
    return funct7(6);
  end function;

  function add_or_sub(funct7: funct7_vector) return std_logic is
  begin
    return funct7(6);
  end function;

end package body;
