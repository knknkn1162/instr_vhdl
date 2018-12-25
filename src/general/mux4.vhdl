library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4 is
  generic (N : natural);
  port (
    i_d00 : in std_logic_vector(N-1 downto 0);
    i_d01 : in std_logic_vector(N-1 downto 0);
    i_d10 : in std_logic_vector(N-1 downto 0);
    i_d11 : in std_logic_vector(N-1 downto 0);
    i_s : in std_logic_vector(1 downto 0);
    o_y : out std_logic_vector(N-1 downto 0)
  );
end entity;

architecture behavior of mux4 is
begin
  process(i_d00, i_d01, i_d10, i_d11, i_s)
  begin
    case i_s is
      when "00" => o_y <= i_d00;
      when "01" => o_y <= i_d01;
      when "10" => o_y <= i_d10;
      when "11" => o_y <= i_d11;
      when others => o_y <= (others => 'X');
    end case;
  end process;
end architecture;
