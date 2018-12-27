library IEEE;
library instr;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;
use instr.tools_pkg.ALL;

entity imem is
  generic(ADDR_WIDTH: natural);
  port (
    clk : in std_logic;
    i_ra : in std_logic_vector(ADDR_WIDTH-1 downto 0);
    o_q : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of imem is
  type ram_type is array(natural range<>) of std_logic_vector(31 downto 0);

  function init_ram return ram_type is 
    variable tmp : ram_type(0 to 2**ADDR_WIDTH-1) := (others => (others => '0'));
  begin 
      tmp(0) := X"015A04B3";
      tmp(1) := X"00140493";
      tmp(2) := X"4049D593";
      tmp(3) := X"0F053483";
      tmp(4) := X"00008067";
      tmp(5) := X"0E953823";
      tmp(6) := X"7CB51863";
      tmp(7) := X"003D08B7";
      tmp(8) := X"7D00006F";
    return tmp;
  end function;

  signal s_ram : ram_type(0 to 2**ADDR_WIDTH-1) := init_ram;

begin
  process(clk, i_ra)
  begin
    if rising_edge(clk) then
      o_q <= s_ram(to_integer(unsigned(i_ra)));
    end if;
  end process;
end architecture;
