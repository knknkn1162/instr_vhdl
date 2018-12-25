library IEEE;
library instr;
use IEEE.STD_LOGIC_1164.ALL;
use instr.type_pkg.ALL;

entity instr_decoder is
  port (
    i_instr : in std_logic_vector(31 downto 0);
    o_itype_imm, o_btype_imm, o_stype_imm : out imm12_vector;
    o_utype_imm, o_jtype_imm : out imm20_vector;
    o_rs1, o_rs2, o_rd : out reg_addr_vector;
    o_shamt : out shamt_vector;
    o_csr : out csr_vector;
    -- srl vs. sra or add vs. sub
    o_instr_s : out std_logic;
    o_funct3 : out funct3_vector;
    o_opcode : out opcode_vector
  );
end entity;

architecture behavior of instr_decoder is

  component instr_imm_decoder
    port (
      i_instr : in std_logic_vector(31 downto 0);
      o_itype_imm, o_btype_imm, o_stype_imm : out imm12_vector;
      o_utype_imm, o_jtype_imm : out imm20_vector
    );
  end component;

  component instr_reg_decoder
    port (
      i_instr : in std_logic_vector(31 downto 0);
      o_rs1, o_rs2, o_rd : out reg_addr_vector
    );
  end component;

  component instr_ctrl_decoder
    port (
      i_instr : in std_logic_vector(31 downto 0);
      -- srl vs. sra or add vs. sub
      o_instr_s : out std_logic;
      o_funct3 : out funct3_vector;
      o_opcode : out opcode_vector
    );
  end component;

begin
  o_shamt <= i_instr(24 downto 20);
  o_csr <= i_instr(31 downto 20);
  instr_imm_decoer0 : instr_imm_decoder port map (
    i_instr => i_instr,
    o_itype_imm => o_itype_imm,
    o_btype_imm => o_btype_imm,
    o_stype_imm => o_stype_imm,
    o_utype_imm => o_utype_imm,
    o_jtype_imm => o_jtype_imm
  );

  instr_reg_decoder0 : instr_reg_decoder port map (
    i_instr => i_instr,
    o_rs1 => o_rs1, o_rs2 => o_rs2, o_rd => o_rd
  );

  instr_ctrl_decoder0 : instr_ctrl_decoder port map (
    i_instr => i_instr,
    o_instr_s => o_instr_s,
    o_funct3 => o_funct3,
    o_opcode => o_opcode
  );
end architecture;
