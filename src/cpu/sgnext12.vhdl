library IEEE;
library instr;
use IEEE.STD_LOGIC_1164.ALL;
use instr.type_pkg.ALL;


entity sgnext12 is
  port (
    i_sgn : in std_logic;
    i_itype_imm, i_btype_imm, i_stype_imm : in imm12_vector;
    i_isb_s : in std_logic_vector(1 downto 0);
    o_immext : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of sgnext12 is
  component mux4
    generic (N : natural);
    port (
      i_d00 : in std_logic_vector(N-1 downto 0);
      i_d01 : in std_logic_vector(N-1 downto 0);
      i_d10 : in std_logic_vector(N-1 downto 0);
      i_d11 : in std_logic_vector(N-1 downto 0);
      i_s : in std_logic_vector(1 downto 0);
      o_y : out std_logic_vector(N-1 downto 0)
    );
  end component;

  signal s_btype_imm2 : std_logic_vector(CONST_IMM12_SIZE downto 0);
  signal s_itype_imm2 : std_logic_vector(CONST_IMM12_SIZE downto 0);
  signal s_stype_imm2 : std_logic_vector(CONST_IMM12_SIZE downto 0);
  signal s_imm13 : std_logic_vector(CONST_IMM12_SIZE downto 0);
  signal s_fill : std_logic_vector(30-CONST_IMM12_SIZE downto 0);
begin
  s_btype_imm2 <= i_btype_imm(11 downto 0) & '0';
  s_itype_imm2 <= i_sgn & i_itype_imm;
  s_stype_imm2 <= i_sgn & i_stype_imm;
  mux4_0 : mux4 generic map (N=>CONST_IMM12_SIZE+1)
  port map (
    i_d00 => s_itype_imm2,
    i_d01 => s_stype_imm2,
    i_d10 => s_btype_imm2,
    i_d11 => (others => '0'),
    i_s => i_isb_s,
    o_y => s_imm13
  );
  s_fill <= (others => i_sgn);
  o_immext <= s_fill & s_imm13;

end architecture;
