library IEEE;
library instr;
use IEEE.STD_LOGIC_1164.ALL;
use instr.type_pkg.ALL;

entity controller is
  port (
    i_opcode : in opcode_vector;
    i_funct3 : in funct3_vector;
    i_instr_s : in std_logic;
    o_isb_uj_s : out std_logic_vector(1 downto 0);
    o_uj_s : out std_logic;
    o_rds2_immext_s : out std_logic
  );
end entity;

architecture behavior of controller is
  signal s_opcode5 : opcode5_vector;
begin
  s_opcode5 <= i_opcode(6 downto 2);
  process(s_opcode5)
  begin
    case s_opcode5 is
      -- I-type(load or op-imm or jalr)
      when CONST_JALR|CONST_OP_IMM|CONST_LOAD => o_isb_uj_s <= "00";
      -- S-type
      when CONST_STORE => o_isb_uj_s <= "01";
      -- B-type
      when CONST_BRANCH => o_isb_uj_s <= "10";
      -- U-type or J-type
      when others =>
        o_isb_uj_s <= "11";
    end case;
  end process;

  -- U-type or J-type
  o_uj_s <= '1' when s_opcode5 = CONST_JAL else '0';
  -- If the instruction is b-type or r-type, use rds2
  o_rds2_immext_s <= '0' when (s_opcode5 = CONST_BRANCH or s_opcode5 = CONST_IMM) else '1';
end architecture;
