library IEEE;
library instr;
use IEEE.STD_LOGIC_1164.ALL;
use instr.type_pkg.ALL;

entity sgnext20 is
  port (
    i_sgn : in std_logic;
    i_utype_imm, i_jtype_imm : in imm20_vector;
    i_uj_s : in std_logic;
    o_immext : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of sgnext20 is
  component mux2
    generic(N : integer);
    port (
      i_d0 : in std_logic_vector(N-1 downto 0);
      i_d1 : in std_logic_vector(N-1 downto 0);
      i_s : in std_logic;
      o_y : out std_logic_vector(N-1 downto 0)
        );
  end component;

  signal s_imm20 : imm20_vector;
  signal s_fill : std_logic_vector(31-CONST_IMM20_SIZE downto 0);
begin
  mux2_0 : mux2 generic map (N=>CONST_IMM20_SIZE)
  port map (
    i_d0 => i_utype_imm,
    i_d1 => i_jtype_imm,
    i_s => i_uj_s,
    o_y => s_imm20
  );
  s_fill <= (others => i_sgn);
  o_immext <= s_fill & s_imm20;
end architecture;
