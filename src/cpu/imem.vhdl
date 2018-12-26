library IEEE;
library instr;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;
use instr.tools_pkg.ALL;

entity imem is
  generic(FILENAME : string; ADDR_WIDTH: natural);
  port (
    clk : in std_logic;
    i_ra : in std_logic_vector(ADDR_WIDTH-1 downto 0);
    o_q : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of imem is
  type ram_type is array(natural range<>) of std_logic_vector(31 downto 0);

  function init_ram return ram_type is 
    file memfile : text open READ_MODE is FILENAME;
    variable tmp : ram_type(0 to 2**ADDR_WIDTH-1) := (others => (others => '0'));
    variable lin : line;
    variable ch : character;
    variable idx : std_logic_vector(8 downto 0);
  begin 
    idx := (others => '0');
    for i in tmp'range loop
      if not endfile(memfile) then
        readline(memfile, lin);
        for i in 0 to 7 loop
          read(lin, ch);
          tmp(to_integer(unsigned(idx)))(31-i*4 downto 28-i*4) := char2bits(ch);
        end loop;
        idx := std_logic_vector(unsigned(idx)+1);
      end if;
      end loop;
    file_close(memfile);
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
