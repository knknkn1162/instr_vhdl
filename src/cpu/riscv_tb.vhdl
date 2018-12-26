library IEEE;
library instr;
use IEEE.STD_LOGIC_1164.ALL;
use instr.type_pkg.ALL;

entity riscv_tb is
end entity;

architecture testbench of riscv_tb is
  component riscv
    generic(MEMFILE : string);
    port (
      clk, rst, i_en : in std_logic;
      -- scan
      o_rs1, o_rs2, o_rd : out reg_addr_vector;
      o_immext : out std_logic_vector(31 downto 0);
      o_shamt : out shamt_vector
    );
  end component;

  constant MEMFILE : string := "./assets/test.hex";
  signal clk, rst, s_en : std_logic;
  signal s_rs1, s_rs2, s_rd : reg_addr_vector;
  signal s_immext : std_logic_vector(31 downto 0);
  signal s_shamt : shamt_vector;
  constant CLK_PERIOD : time := 10 ns;
  signal s_stop : boolean;

begin
  uut : riscv generic map(MEMFILE=>MEMFILE)
  port map (
    clk => clk, rst => rst, i_en => s_en,
    o_rs1 => s_rs1, o_rs2 => s_rs2, o_rd => s_rd,
    o_immext => s_immext, o_shamt => s_shamt
  );

  clk_process: process
  begin
    while not s_stop loop
      clk <= '0'; wait for CLK_PERIOD/2;
      clk <= '1'; wait for CLK_PERIOD/2;
    end loop;
    wait;
  end process;

  stim_proc : process
  begin
    wait for CLK_PERIOD;

    rst <= '1'; s_en <= '1'; wait until rising_edge(clk); wait for 1 ns; rst <= '0';

    -- 015A04B3 ;; add x9, x20, x21
    assert s_rs1 = "10100"; assert s_rs2 = "10101"; assert s_rd = "01001";

    wait until rising_edge(clk); wait for 1 ns;
    -- 00140493 ;; addi x9, x8, 1
    assert s_rs1 = "01000"; assert s_immext = X"00000001"; assert s_rd = "01001";

    wait until rising_edge(clk); wait for 1 ns;
    -- 4049D593 ;; srai x11, x19, 4
    assert s_rs1 = "10011"; assert s_shamt = "00100"; assert s_rd = "01011";
    -- skip
    s_stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;