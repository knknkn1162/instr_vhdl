library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use instr.type_pkg.ALL;

entity instr_decoder is
  port (
    i_instr : in std_logic_vector(31 downto 0);
    o_opcode : out opcode_vector;
    o_funct7 : out funct7_vector;
    o_shamt : out shamt_vector;
    o_imm12 : out imm12_vector;
    o_rs1, o_rs2, o_rd : out reg_vector;
    o_csr : out csr_vector
  );
end entity;

architecture behavior of instr_decoder is
  signal s_funct7 : funct7_vector;
  signal o_rs1, s_rd : reg_vector;
  signal s_funct3 : funct3_vector;
  signal s_imm12 : imm12_vector;
  signal s_imm20 : imm20_vector;
begin

  s_imm12 <= i_instr(31 downto 20);
  s_funct7 <= i_instr(31 downto 25);
  o_shamt <= s_imm12(4 downto 0);
  o_rs1 <= i_instr(19 downto 15);
  o_rs2 <= i_instr(24 downto 20);
  o_funct3 <= i_instr(14 downto 12);
  o_rd <= i_instr(11 downto 7);
  s_imm20 <= i_instr(31 downto 12);

  -- decode imm12
  process(i_instr)
  begin
    case i_instr(6 downto 4) is
      -- S-type
      when "010" =>
        o_imm12 <= s_imm12(11 downto 5) & s_rd;
      -- B-type
      when "110" =>
        o_imm12 <= s_imm12(11) & s_rd(0) & s_imm12(10 downto 5) & s_rd(4 downto 1);
      -- I-type(Load or ALUI) or system
      when others =>
        o_imm12 <= s_imm12;
    end case;
  end process;

  o_imm20 <= s_imm20 when i_instr(3) = '0' else 
  -- decode imm20
  process(i_instr)
  begin
    if i_instr(3) = "0" then
      o_imm20 <= 

  end process;
end architecture;
