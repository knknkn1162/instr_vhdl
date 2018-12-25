library IEEE;
library instr;
use IEEE.STD_LOGIC_1164.ALL;
use instr.type_pkg.ALL;

entity regfile_tb is
end entity;

architecture testbench of regfile_tb is
  component regfile
    generic(ADDR_WIDTH: natural);
    port (
      clk, i_we : in std_logic;
      i_ra1, i_ra2, i_wa : in reg_addr_vector;
      i_wd : in std_logic_vector(31 downto 0);
      o_rd1, o_rd2 : out std_logic_vector(31 downto 0)
    );
  end component;

  constant ADDR_WIDTH : natural := 5;
  signal clk, s_we : std_logic;
  signal s_ra1, s_ra2, s_wa : std_logic_vector(ADDR_WIDTH-1 downto 0);
  signal s_wd, s_rd1, s_rd2 : std_logic_vector(31 downto 0);
  constant CLK_PERIOD : time := 10 ns;
  signal s_stop : boolean;

begin
  uut : regfile generic map(ADDR_WIDTH=>ADDR_WIDTH)
  port map (
    clk => clk, i_we => s_we,
    i_ra1 => s_ra1, i_ra2 => s_ra2, i_wa => s_wa,
    i_wd => s_wd,
    o_rd1 => s_rd1, o_rd2 => s_rd2
  );

  clk_process: process
  begin
    while not s_stop loop
      clk <= '0'; wait for CLK_PERIOD/2;
      clk <= '1'; wait for CLK_PERIOD/2;
    end loop;
    wait;
  end process;

  stim_proc : process
  begin
    wait for CLK_PERIOD;
    s_wa <= "00010"; s_wd <= X"0000000F"; s_we <= '1';
    wait until rising_edge(clk); wait for 1 ns;
    s_ra1 <= "00010"; s_ra2 <= "00010"; wait for 1 ns;
    assert s_rd1 = X"0000000F"; assert s_rd2 = X"0000000F";

    -- $0 is exceptional register value that is always the value of 0.
    s_wa <= "00000"; s_wd <= X"0000000E";
    wait until rising_edge(clk); wait for 1 ns;
    s_ra1 <= "00000"; s_ra2 <= "00000"; wait for 1 ns;
    assert s_rd1 = X"00000000"; assert s_rd2 = X"00000000";
    s_stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
