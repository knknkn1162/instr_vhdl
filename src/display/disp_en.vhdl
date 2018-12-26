library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity disp_en is
  generic(N : natural);
  port (
    clk, rst : in std_logic;
    i_num : in std_logic_vector(23 downto 0);
    o_ena : out std_logic;
    o_hex0 : out std_logic_vector(6 downto 0);
    o_hex1 : out std_logic_vector(6 downto 0);
    o_hex2 : out std_logic_vector(6 downto 0);
    o_hex3 : out std_logic_vector(6 downto 0);
    o_hex4 : out std_logic_vector(6 downto 0);
    o_hex5 : out std_logic_vector(6 downto 0)
  );
end entity;

architecture behavior of disp_en is
  component enable_generator
    generic(N : natural);
    port (
      clk, rst : in std_logic;
      o_ena : out std_logic
    );
  end component;

  component disp
    port (
      i_num : in std_logic_vector(23 downto 0);
      o_hex0 : out std_logic_vector(6 downto 0);
      o_hex1 : out std_logic_vector(6 downto 0);
      o_hex2 : out std_logic_vector(6 downto 0);
      o_hex3 : out std_logic_vector(6 downto 0);
      o_hex4 : out std_logic_vector(6 downto 0);
      o_hex5 : out std_logic_vector(6 downto 0)
    );
  end component;

begin
  enable_generator0 : enable_generator generic map(N=>N)
  port map (
    clk => clk, rst => rst, o_ena => o_ena
  );

  disp0 : disp port map (
    i_num => i_num,
    o_hex0 => o_hex0, o_hex1 => o_hex1, o_hex2 => o_hex2,
    o_hex3 => o_hex3, o_hex4 => o_hex4, o_hex5 => o_hex5
  );
end architecture;
