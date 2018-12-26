library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity imem_tb is
end entity;

architecture testbench of imem_tb is
  component imem
    generic(FILENAME : string; BITS : natural);
    port (
      i_addr : in std_logic_vector(BITS-1 downto 0);
      o_q : out std_logic_vector(31 downto 0)
    );
  end component;
  
  constant FILENAME : string := "./assets/test.hex";
  constant BITS : natural := 9;
  signal s_addr : std_logic_vector(BITS-1 downto 0);
  signal s_q : std_logic_vector(31 downto 0);
  constant PERIOD : time := 20 ns;
begin
  uut : imem generic map(FILENAME=>FILENAME, BITS=>BITS)
  port map (
    i_addr => s_addr, o_q => s_q
  );

  stim_proc : process
  begin
    wait for PERIOD;
    s_addr <= "000000100"; wait for PERIOD/2;
    assert s_q = X"00140493";
    wait;
  end process;


end architecture;
