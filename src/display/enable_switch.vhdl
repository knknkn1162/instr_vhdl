library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity enable_switch is
  port (
    clk : in std_logic;
    i_btn : in std_logic;
    o_en : out std_logic
  );
end entity;

architecture behavior of enable_switch is
begin
  process(clk)
  begin
    if rising_edge(clk) then
      if i_btn = '1' then
        o_en <= '1';
      else
        o_en <= '0';
      end if;
    end if;
  end process;
end architecture;
