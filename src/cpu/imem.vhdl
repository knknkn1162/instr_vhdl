library IEEE;
library instr;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;
use instr.tools_pkg.ALL;

entity imem is
  generic(FILENAME : string; BITS : natural);
  port (
    i_addr : in std_logic_vector(31 downto 0);
    o_q : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of imem is
  constant RAM_SIZE : natural := 2**BITS;
  type ram_type is array(RAM_SIZE-1 downto 0) of std_logic_vector(31 downto 0);

  function init_ram return ram_type is 
    file memfile : text open READ_MODE is FILENAME;
    variable tmp : ram_type := (others => (others => '0'));
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

  -- Declare the RAM signal and specify a default value.  Quartus Prime
  -- will create a memory initialization file (.mif) based on the 
  -- default value.
  signal ram : ram_type := init_ram;
begin
  o_q <= ram(to_integer(unsigned(i_addr(31 downto 2))));
end architecture;
