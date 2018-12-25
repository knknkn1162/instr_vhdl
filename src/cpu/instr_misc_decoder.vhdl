library IEEE;
library instr;
use IEEE.STD_LOGIC_1164.ALL;
use instr.type_pkg.ALL;

entity instr_misc_decoder is
  port (
    i_instr : in std_logic_vector(31 downto 0);
    o_shamt : out shamt_vector;
    o_csr : out csr_vector
  );
end entity;

architecture behavior of instr_misc_decoder is
begin
  o_shamt <= i_instr(24 downto 20);
  o_csr <= i_instr(31 downto 20);
end architecture;
