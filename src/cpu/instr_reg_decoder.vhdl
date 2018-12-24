library IEEE;
library instr;
use IEEE.STD_LOGIC_1164.ALL;
use instr.type_pkg.ALL;

entity instr_reg_decoder is
  port (
    i_instr : in std_logic_vector(31 downto 0);
    o_rs1, o_rs2, o_rd : out reg_addr_vector
  );
end entity;

architecture behavior of instr_reg_decoder is
begin
  o_rs1 <= i_instr(19 downto 15);
  o_rs2 <= i_instr(24 downto 20);
  o_rd <= i_instr(11 downto 7);
end architecture;
