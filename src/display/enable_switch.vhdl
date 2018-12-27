library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity enable_switch is
  generic(N : natural);
  port (
    clk : in std_logic;
    i_btn : in std_logic;
    o_en : out std_logic
  );
end entity;

architecture behavior of enable_switch is
  component enable_generator
    generic(N : natural);
    port (
      clk, rst : in std_logic;
      o_ena : out std_logic
    );
  end component;
  signal s_en40 : std_logic;

begin
  -- remove chattering
  enable_generator0 : enable_generator generic map (N=>N)
  port map (
    clk => clk, rst => '0',
    o_ena => s_en40
  );
  o_en <= s_en40 and (not i_btn);
end architecture;
