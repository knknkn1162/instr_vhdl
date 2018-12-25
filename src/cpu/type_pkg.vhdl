library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package type_pkg is
  constant CONST_SHAMT_SIZE : natural := 5;
  constant CONST_FUNCT7_SIZE : natural := 7;
  constant CONST_FUNCT3_SIZE : natural := 3;
  constant CONST_IMM12_SIZE : natural := 12;
  constant CONST_IMM20_SIZE : natural := 20;
  constant CONST_OPCODE_SIZE : natural := 7;
  constant CONST_OPCODE5_SIZE : natural := 5;
  constant CONST_REG_ADDR_SIZE : natural := 5;
  constant CONST_CSR_SIZE : natural := 12;
  subtype shamt_vector is std_logic_vector(CONST_SHAMT_SIZE-1 downto 0);
  subtype funct7_vector is std_logic_vector(CONST_FUNCT7_SIZE-1 downto 0);
  subtype imm12_vector is std_logic_vector(CONST_IMM12_SIZE-1 downto 0);
  subtype imm20_vector is std_logic_vector(CONST_IMM20_SIZE-1 downto 0);
  subtype reg_addr_vector is std_logic_vector(CONST_REG_ADDR_SIZE-1 downto 0);
  subtype opcode_vector is std_logic_vector(CONST_OPCODE_SIZE-1 downto 0);
  subtype opcode5_vector is std_logic_vector(CONST_OPCODE5_SIZE-1 downto 0);
  subtype funct3_vector is std_logic_vector(CONST_FUNCT3_SIZE-1 downto 0);
  subtype csr_vector is std_logic_vector(CONST_CSR_SIZE-1 downto 0);

  -- See Table 19.1 in The RISC-V Instruction Set Manual vol.1
  -- B-type
  -- beq, bne, blt, bge, bltu, bgeu
  constant CONST_BRANCH : opcode5_vector := "11000";

  -- I-type instruction
  -- -- LOAD : lb, lh, lw, lbu, lhu
  constant CONST_LOAD : opcode5_vector := "00000";
  -- -- addi, ..
  constant CONST_OP_IMM : opcode5_vector := "00100";
  -- -- jalr
  constant CONST_JALR : opcode5_vector := "11001";

  -- S-type
  constant CONST_STORE : opcode5_vector := "01000";

  -- R-type
  constant CONST_IMM : opcode5_vector := "01100";

  -- U-type
  -- -- auipc : Add upper immediate to PC
  constant CONST_AUIPC : opcode5_vector := "00101";
  -- -- lui : Load Upper Immediate
  constant CONST_LUI : opcode5_vector := "01101";

  -- J-type
  constant CONST_JAL : opcode5_vector := "11011";

  -- guarantee ordering between memory operations from different RISC-V harts.
  constant CONST_FENCE : opcode5_vector := "00011";
  -- e.g) ECALL, EBREAK, CSR**
  constant CONST_SYSTEM : opcode5_vector := "11100";

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
end package body;
