library IEEE;
library instr;
use IEEE.STD_LOGIC_1164.ALL;
use instr.type_pkg.ALL;

entity instr_ctrl_decoder is
  port (
    i_instr : in std_logic_vector(31 downto 0);
    -- srl vs. sra or add vs. sub
    o_instr_s : out std_logic;
    o_funct3 : out funct3_vector;
    o_opcode : out opcode_vector
  );
end entity;

architecture behavior of instr_ctrl_decoder is
begin
  o_instr_s <= i_instr(30);
  o_funct3 <= i_instr(14 downto 12);
  o_opcode <= i_instr(6 downto 0);
end architecture;
