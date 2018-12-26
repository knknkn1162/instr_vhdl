library IEEE;
library instr;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use instr.type_pkg.ALL;


entity imem_test is
  generic(MEMFILE : string; IMEM_ADDR_WIDTH : natural; N : natural);
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

architecture behavior of imem_test is
  component flopr_en
    generic(N : natural);
    port (
      clk, rst, i_en: in std_logic;
      i_a : in std_logic_vector(N-1 downto 0);
      o_y : out std_logic_vector(N-1 downto 0)
    );
  end component;

  component disp_en
    generic(N : natural);
    port (
      clk, rst : in std_logic;
      i_num : in std_logic_vector(23 downto 0);
      o_ena : out std_logic;
      o_hex0 : out std_logic_vector(6 downto 0);
      o_hex1 : out std_logic_vector(6 downto 0);
      o_hex2 : out std_logic_vector(6 downto 0);
      o_hex3 : out std_logic_vector(6 downto 0);
      o_hex4 : out std_logic_vector(6 downto 0);
      o_hex5 : out std_logic_vector(6 downto 0)
    );
  end component;

  component imem
    generic(FILENAME : string; ADDR_WIDTH : natural);
    port (
      clk : in std_logic;
      i_ra : in std_logic_vector(ADDR_WIDTH-1 downto 0);
      o_q : out std_logic_vector(31 downto 0)
    );
  end component;

  constant ADDR_WIDTH : natural := 5;
  constant MEMFILE1 : string := "/home/knknkn1162/Documents/share/sample/imem/src/cpu/assets/test.hex";
  signal s_pcnext, s_pc : std_logic_vector(31 downto 0);
  signal s_instr : std_logic_vector(31 downto 0);
  signal s_en : std_logic;
begin

  flopr_pc : flopr_en generic map(N=>32)
  port map (
    clk => clk, rst => rst, i_en => s_en,
    i_a => s_pcnext,
    o_y => s_pc
  );

  s_pcnext <= std_logic_vector(unsigned(s_pc) + 4);

  imem0 : imem generic map(FILENAME=>MEMFILE1, ADDR_WIDTH=>IMEM_ADDR_WIDTH)
  port map (
    clk => clk,
    i_ra => s_pc(IMEM_ADDR_WIDTH+1 downto 2), o_q => s_instr
  );

  disp_en0 : disp_en generic map(N=>N)
  port map (
    clk => clk, rst => rst,
    i_num => s_instr(23 downto 0),
    o_ena => s_en,
    o_hex0 => o_hex0, o_hex1 => o_hex1, o_hex2 => o_hex2,
    o_hex3 => o_hex3, o_hex4 => o_hex4, o_hex5 => o_hex5
  );
end architecture;
