library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity enable_switch_tb is
end entity;

architecture testbench of enable_switch_tb is
  component enable_switch
    port (
      clk : in std_logic;
      i_btn : in std_logic;
      o_en : out std_logic
    );
  end component;

  signal clk, s_btn, s_en : std_logic;
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : enable_switch port map (
    clk => clk, i_btn => s_btn, o_en => s_en
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
    s_btn <= '1';
    wait for 1 ns;
    assert s_en = '0';
    wait until rising_edge(clk); wait for 1 ns;
    assert s_en = '1';
    assert s_btn = '0';wait until rising_edge(clk); wait for 1 ns;
    assert s_en /= '1';
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
