library IEEE;
library instr;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;
use instr.tools_pkg.ALL;

entity imem is
  generic(filename : string; BITS : natural);
  port (
    i_addr : in std_logic_vector(31 downto 0);
    o_q : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of imem is
  constant ROM_SIZE : natural := 2**BITS;
  type ram_type is array(ROM_SIZE-1 downto 0) of std_logic_vector(31 downto 0);

  function init_ram return ram_type is 
    file memfile : text open READ_MODE is filename;
    variable tmp : ram_type := (others => (others => '0'));
    variable lin : line;
    variable ch : character;
    variable idx : natural := 0;
  begin 
    while not endfile(memfile) loop
      readline(memfile, lin);
      for i in 0 to 7 loop
        read(lin, ch);
        tmp(idx)(31-i*4 downto 28-i*4) := char2bits(ch);
      end loop;
      idx := idx + 1;
    end loop;
    file_close(memfile);
    return tmp;
  end function;

  -- Declare the RAM signal and specify a default value.  Quartus Prime
  -- will create a memory initialization file (.mif) based on the 
  -- default value.
  signal ram : ram_type := init_ram;
begin
  o_q <= ram(to_integer(unsigned(i_addr)));
end architecture;
