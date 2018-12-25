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

  signal s_utype_imm32, s_jtype_imm32 : std_logic_vector(31 downto 0);
  -- for j-type
  signal s_fill : std_logic_vector(30-CONST_IMM20_SIZE downto 0);
  constant ZEROS12 : std_logic_vector(11 downto 0) := (others => '0');

begin
  s_fill <= (others => i_sgn);
  s_utype_imm32 <= i_utype_imm & ZEROS12;
  s_jtype_imm32 <= s_fill & i_jtype_imm & '0';
  mux2_0 : mux2 generic map (N=>32)
  port map (
    i_d0 => s_utype_imm32,
    i_d1 => s_jtype_imm32,
    i_s => i_uj_s,
    o_y => o_immext
  );
end architecture;
