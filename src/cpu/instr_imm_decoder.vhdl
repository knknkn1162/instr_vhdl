library IEEE;
library instr;
use IEEE.STD_LOGIC_1164.ALL;
use instr.type_pkg.ALL;

entity instr_imm_decoder is
  port (
    i_instr : in std_logic_vector(31 downto 0);
    o_itype_imm, o_btype_imm, o_stype_imm : out imm12_vector;
    o_utype_imm, o_jtype_imm : out imm20_vector
  );
end entity;

architecture behavior of instr_imm_decoder is
begin
  o_itype_imm <= i_instr(31 downto 20);
  o_stype_imm <= i_instr(31 downto 25) & i_instr(11 downto 7);
  o_btype_imm <= i_instr(31) & i_instr(7) & i_instr(30 downto 25) & i_instr(11 downto 8);
  o_utype_imm <= i_instr(31 downto 12);
  o_jtype_imm <= i_instr(31) & i_instr(19 downto 12) & i_instr(20) & i_instr(30 downto 21);
end architecture;
