library IEEE;
library instr;
use IEEE.STD_LOGIC_1164.ALL;
use instr.type_pkg.ALL;

entity controller is
  port (
    i_opcode : in opcode_vector;
    i_funct3 : in funct3_vector;
    i_instr_s : in std_logic;
    o_rds2_immext_s : out std_logic;
    o_isb_uj_s : out std_logic_vector(1 downto 0);
    o_uj_s : out std_logic
  );
end entity;

architecture behavior of controller is
begin
  process(i_opcode)
  begin
    case i_opcode(6 downto 2) is
      -- I-type(load or op-imm or jalr)
      when "00000"|"00100"|"11001" => o_isb_uj_s <= "00";
      -- S-type
      when "01000" => o_isb_uj_s <= "01";
      -- B-type
      when "11000" => o_isb_uj_s <= "10";
      -- U-type or J-type
      when others =>
        o_isb_uj_s <= "11";
    end case;
  end process;

  process(i_opcode)
  begin
    if i_opcode(6 downto 2) = "01101" or i_opcode(6 downto 2) = "01101" then
      o_uj_s <= '0';
    elsif i_opcode(6 downto 2) = "11011" then
      o_uj_s <= '1';
    else
      o_uj_s <= 'X';
    end if;
  end process;


end architecture;
