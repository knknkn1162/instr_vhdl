library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4_tb is
end entity;

architecture testbench of mux4_tb is
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

  constant N : natural := 32;
  constant CONST_ALL_X : std_logic_vector(N-1 downto 0) := (others => 'X');
  signal s_d00, s_d01, s_d10, s_d11, s_y : std_logic_vector(N-1 downto 0);
  signal s_s : std_logic_vector(1 downto 0);

begin
  uut : mux4 generic map (N=>32)
  port map (
    i_d00 => s_d00, i_d01 => s_d01, i_d10 => s_d10, i_d11 => s_d11,
    i_s => s_s,
    o_y => s_y
  );

  stim_proc : process
  begin
    wait for 20 ns;
    s_d00 <= X"00000001"; s_d01 <= X"00000010"; s_d10 <= X"00000100"; s_d11 <= X"00001000";
    s_s <= "00"; wait for 10 ns;
    assert s_y = X"00000001";

    s_s <= "01"; wait for 10 ns;
    assert s_y = X"00000010";

    s_s <= "10"; wait for 10 ns;
    assert s_y = X"00000100";

    s_s <= "11"; wait for 10 ns;
    assert s_y = X"00001000";

    -- when s is an undefined value, y is also undefined
    s_s <= "XX"; wait for 10 ns;
    assert s_y = CONST_ALL_X;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
  
end architecture;
