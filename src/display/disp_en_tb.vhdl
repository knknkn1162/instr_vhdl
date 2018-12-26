library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity disp_en_tb is
end entity;

architecture testbench of disp_en_tb is
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

  constant N : natural := 5;
  signal clk, rst : std_logic;
  signal s_num : std_logic_vector(23 downto 0);
  signal s_ena : std_logic;
  signal s_hex0 : std_logic_vector(6 downto 0);
  signal s_hex1 : std_logic_vector(6 downto 0);
  signal s_hex2 : std_logic_vector(6 downto 0);
  signal s_hex3 : std_logic_vector(6 downto 0);
  signal s_hex4 : std_logic_vector(6 downto 0);
  signal s_hex5 : std_logic_vector(6 downto 0);
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : disp_en generic map(N=>N)
  port map (
    clk => clk, rst => rst, i_num => s_num,
    o_ena => s_ena,
    o_hex0 => s_hex0, o_hex1 => s_hex1, o_hex2 => s_hex2,
    o_hex3 => s_hex3, o_hex4 => s_hex4, o_hex5 => s_hex5
  );

  clk_process: process
  begin
    while not stop loop
      clk <= '0'; wait for clk_period/2;
      clk <= '1'; wait for clk_period/2;
    end loop;
    wait;
  end process;

  stim_proc : process
  begin
    wait for clk_period;
    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
