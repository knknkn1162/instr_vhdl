library IEEE;
library instr;

use IEEE.STD_LOGIC_1164.ALL;
use instr.type_pkg.ALL;

entity sgnext is
  port (
    i_sgn : in std_logic;
    i_itype_imm, i_btype_imm, i_stype_imm : in imm12_vector;
    i_utype_imm, i_jtype_imm : in imm20_vector;
    i_isb_uj_s : in std_logic_vector(1 downto 0);
    i_uj_s : in std_logic;
    o_immext : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of sgnext is
  component sgnext12
    port (
      i_sgn : in std_logic;
      i_itype_imm, i_btype_imm, i_stype_imm : in imm12_vector;
      i_isb_s : in std_logic_vector(1 downto 0);
      o_immext : out std_logic_vector(31 downto 0)
    );
  end component;

  component sgnext20
    port (
      i_sgn : in std_logic;
      i_utype_imm, i_jtype_imm : in imm20_vector;
      i_uj_s : in std_logic;
      o_immext : out std_logic_vector(31 downto 0)
    );
  end component;

  component mux2
    generic(N : integer);
    port (
      i_d0 : in std_logic_vector(N-1 downto 0);
      i_d1 : in std_logic_vector(N-1 downto 0);
      i_s : in std_logic;
      o_y : out std_logic_vector(N-1 downto 0)
        );
  end component;

  signal s_isb_imm : std_logic_vector(31 downto 0);
  signal s_uj_imm : std_logic_vector(31 downto 0);
  signal s_isb_uj_s : std_logic;
begin
  sgnext12_0 : sgnext12 port map (
    i_sgn => i_sgn,
    i_itype_imm => i_itype_imm, i_btype_imm => i_btype_imm, i_stype_imm => i_stype_imm,
    i_isb_s => i_isb_uj_s,
    o_immext => s_isb_imm
  );

  sgnext20_0 : sgnext20 port map (
    i_sgn => i_sgn,
    i_utype_imm => i_utype_imm, i_jtype_imm => i_jtype_imm,
    i_uj_s => i_uj_s,
    o_immext => s_uj_imm
  );

  -- s_isb_uj_s <= '1' when i_isb_uj_s = "11" else '0';
  s_isb_uj_s <= i_isb_uj_s(0) and i_isb_uj_s(1);

  mux2_0 : mux2 generic map (N=>32)
  port map (
    i_d0 => s_isb_imm,
    i_d1 => s_uj_imm,
    i_s => s_isb_uj_s,
    o_y => o_immext
  );
end architecture;
