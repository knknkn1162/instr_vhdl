library IEEE;
library instr;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use instr.type_pkg.ALL;

entity riscv is
  generic(IMEM_ADDR_WIDTH : natural);
  port (
    clk, rst, i_en : in std_logic;
    -- scan
    o_rs1, o_rs2, o_rd : out reg_addr_vector;
    o_immext : out std_logic_vector(31 downto 0);
    o_shamt : out shamt_vector
  );
end entity;

architecture behavior of riscv is
  component flopr_en
    generic(N : natural);
    port (
      clk, rst, i_en: in std_logic;
      i_a : in std_logic_vector(N-1 downto 0);
      o_y : out std_logic_vector(N-1 downto 0)
    );
  end component;

  component imem
    generic(ADDR_WIDTH : natural);
    port (
      clk : in std_logic;
      i_ra : in std_logic_vector(ADDR_WIDTH-1 downto 0);
      o_q : out std_logic_vector(31 downto 0)
    );
  end component;

  component instr_decoder
    port (
      i_instr : in std_logic_vector(31 downto 0);
      o_itype_imm, o_btype_imm, o_stype_imm : out imm12_vector;
      o_utype_imm, o_jtype_imm : out imm20_vector;
      o_rs1, o_rs2, o_rd : out reg_addr_vector;
      o_shamt : out shamt_vector;
      o_csr : out csr_vector;
      -- srl vs. sra or add vs. sub
      o_instr_s : out std_logic;
      o_funct3 : out funct3_vector;
      o_opcode : out opcode_vector
    );
  end component;

  component sgnext
    port (
      i_sgn : in std_logic;
      i_itype_imm, i_btype_imm, i_stype_imm : in imm12_vector;
      i_utype_imm, i_jtype_imm : in imm20_vector;
      i_isb_uj_s : in std_logic_vector(1 downto 0);
      i_uj_s : in std_logic;
      o_immext : out std_logic_vector(31 downto 0)
    );
  end component;

  component controller
    port (
      i_opcode : in opcode_vector;
      i_funct3 : in funct3_vector;
      i_instr_s : in std_logic;
      o_isb_uj_s : out std_logic_vector(1 downto 0);
      o_uj_s : out std_logic;
      o_rds2_immext_s : out std_logic
    );
  end component;

  component regfile
    generic(ADDR_WIDTH : natural);
    port (
      clk, i_we : in std_logic;
      i_ra1, i_ra2, i_wa : in reg_addr_vector;
      i_wd : in std_logic_vector(31 downto 0);
      o_rd1, o_rd2 : out std_logic_vector(31 downto 0)
    );
  end component;
  
  component mux2
    generic(N : integer);
    port (
      i_d0 : in std_logic_vector(N-1 downto 0);
      i_d1 : in std_logic_vector(N-1 downto 0);
      i_s : in std_logic;
      o_y : out std_logic_vector(N-1 downto 0)
        );
  end component;

  constant REG_ADDR_WIDTH : natural := 5;
  signal s_pcnext, s_pc : std_logic_vector(31 downto 0);
  signal s_instr : std_logic_vector(31 downto 0);
  signal s_itype_imm, s_btype_imm, s_stype_imm : imm12_vector;
  signal s_utype_imm, s_jtype_imm : imm20_vector;
  signal s_rs1, s_rs2, s_rd : reg_addr_vector;
  signal s_shamt : shamt_vector;
  -- signal s_csr : csr_vector;
  signal s_instr_s : std_logic;
  signal s_funct3 : funct3_vector;
  signal s_opcode : opcode_vector;

  signal s_isb_uj_s : std_logic_vector(1 downto 0);
  signal s_uj_s, s_rds2_immext_s : std_logic;

  signal s_rds1 : std_logic_vector(31 downto 0);
  signal s_rds2 : std_logic_vector(31 downto 0);
  signal s_immext : std_logic_vector(31 downto 0);
  -- signal s_aluarg1, s_aluarg2 : std_logic_vector(31 downto 0);

  signal s_we : std_logic;
begin
  -- for scan
  o_rs1 <= s_rs1; o_rs2 <= s_rs2; o_rd <= s_rd;
  o_immext <= s_immext;
  o_shamt <= s_shamt;

  flopr_pc : flopr_en generic map(N=>32)
  port map (
    clk => clk, rst => rst, i_en => i_en,
    i_a => s_pcnext,
    o_y => s_pc
  );

  s_pcnext <= std_logic_vector(unsigned(s_pc) + 4);

  imem0 : imem generic map(ADDR_WIDTH=>IMEM_ADDR_WIDTH)
  port map (
    clk => clk,
    i_ra => s_pc(IMEM_ADDR_WIDTH+1 downto 2), o_q => s_instr
  );

  instr_decoder0 : instr_decoder port map (
    i_instr => s_instr,
    o_itype_imm => s_itype_imm, o_btype_imm => s_btype_imm, o_stype_imm => s_stype_imm,
    o_utype_imm => s_utype_imm, o_jtype_imm => s_jtype_imm,
    o_rs1 => s_rs1, o_rs2 => s_rs2, o_rd => s_rd,
    o_shamt => s_shamt,
    -- o_csr => s_csr,
    o_instr_s => s_instr_s, o_funct3 => s_funct3, o_opcode => s_opcode
  );

  controller0 : controller port map (
    i_opcode => s_opcode,
    i_funct3 => s_funct3,
    i_instr_s => s_instr_s,
    o_isb_uj_s => s_isb_uj_s,
    o_uj_s => s_uj_s,
    o_rds2_immext_s => s_rds2_immext_s
  );

  sgnext0 : sgnext port map (
    i_sgn => s_instr(31),
    i_itype_imm => s_itype_imm, i_btype_imm => s_btype_imm, i_stype_imm => s_stype_imm,
    i_utype_imm => s_utype_imm, i_jtype_imm => s_jtype_imm,
    i_isb_uj_s => s_isb_uj_s,
    i_uj_s => s_uj_s,
    o_immext => s_immext
  );

  s_we <= '0';
  regfile0 : regfile generic map (ADDR_WIDTH=>REG_ADDR_WIDTH)
  port map (
    clk => clk, i_we => s_we,
    i_ra1 => s_rs1, i_ra2 => s_rs2,
    i_wa => "00000", -- dummy
    i_wd => X"00000000", -- dummy
    o_rd1 => s_rds1,
    o_rd2 => s_rds2
  );

  -- s_aluarg1 <= s_rds1;

  rds2_immext_mux : mux2 generic map(N=>32)
  port map (
    i_d0 => s_rds2,
    i_d1 => s_immext,
    i_s => s_rds2_immext_s
    -- o_y => s_aluarg2
  );
end architecture;
