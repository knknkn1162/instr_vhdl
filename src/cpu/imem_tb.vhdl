library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity imem_tb is
end entity;

architecture testbench of imem_tb is
  component imem
    generic(ADDR_WIDTH: natural);
    port (
      clk : in std_logic;
      i_ra : in std_logic_vector(ADDR_WIDTH-1 downto 0);
      o_q : out std_logic_vector(31 downto 0)
    );
  end component;
  
  constant ADDR_WIDTH : natural := 9;
  signal clk : std_logic;
  signal s_ra : std_logic_vector(ADDR_WIDTH-1 downto 0);
  signal s_q : std_logic_vector(31 downto 0);
  constant CLK_PERIOD : time := 20 ns;
  signal stop : boolean;

begin
  uut : imem generic map(ADDR_WIDTH=>ADDR_WIDTH)
  port map (
    clk => clk,
    i_ra => s_ra, o_q => s_q
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
    s_ra <= "000000001";
    wait until rising_edge(clk); wait for 1 ns;
    assert s_q = X"00140493";
    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
