library IEEE;
libarary instr;
use IEEE.STD_LOGIC_1164.ALL;
use instr.type_pkg.ALL;

entity controller is
  port (
    i_opcode : in opcode_vector;
    i_funct3 : in funct3_vector;
    i_instr_s : in std_logic;
    o_rds2_immext_s : out std_logic
  );
end entity;

architecture behavior of controller is
begin
end architecture;
