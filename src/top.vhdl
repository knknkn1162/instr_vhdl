library IEEE;
library instr;
use IEEE.STD_LOGIC_1164.ALL;
use instr.type_pkg.ALL;

entity top is
  generic(MEMFILE : string; N : natural);
  port (
    clk, rst : in std_logic;
    o_hex0 : out std_logic_vector(6 downto 0);
    o_hex1 : out std_logic_vector(6 downto 0);
    o_hex2 : out std_logic_vector(6 downto 0);
    o_hex3 : out std_logic_vector(6 downto 0);
    o_hex4 : out std_logic_vector(6 downto 0);
    o_hex5 : out std_logic_vector(6 downto 0)
  );
end entity;

architecture behavior of top is
  component enable_generator
    generic(N : natural);
    port (
      clk, rst : in std_logic;
      o_ena : out std_logic
    );
  end component;

  component riscv
    generic(MEMFILE : string);
    port (
      clk, rst : in std_logic;
      -- scan
      o_rs1, o_rs2, o_rd : out reg_addr_vector;
      o_immext : out std_logic_vector(31 downto 0)
    );
  end component;

  component disp
    port (
      i_num : in std_logic_vector(23 downto 0);
      o_hex0 : out std_logic_vector(6 downto 0);
      o_hex1 : out std_logic_vector(6 downto 0);
      o_hex2 : out std_logic_vector(6 downto 0);
      o_hex3 : out std_logic_vector(6 downto 0);
      o_hex4 : out std_logic_vector(6 downto 0);
      o_hex5 : out std_logic_vector(6 downto 0)
    );
  end component;

  signal s_ena : std_logic;
  signal s_num : std_logic_vector(23 downto 0);
  signal s_rs1, s_rs2, s_rd : reg_addr_vector;
  signal s_immext : std_logic_vector(31 downto 0);

begin
  enable_generator0 : enable_generator generic map (N=>N)
  port map (
    clk => clk, rst => rst,
    o_ena => s_ena
  );

  riscv0 : riscv generic map(MEMFILE=>MEMFILE)
  port map (
    clk => clk, rst => rst,
    o_rs1 => s_rs1, o_rs2 => s_rs2, o_rd => s_rd,
    o_immext => s_immext
  );

  s_num <= s_immext(23 downto 0);

  disp0 : disp port map (
    i_num => s_num,
    o_hex0 => o_hex0,
    o_hex1 => o_hex1,
    o_hex2 => o_hex2,
    o_hex3 => o_hex3,
    o_hex4 => o_hex4,
    o_hex5 => o_hex5
  );
end architecture;