library IEEE;
use IEEE.std_logic_1164.all;

entity ALU32 is
port (  --PC : in std_logic_vector(31 downto 0);
        --RegIn : in std_logic_vector(31 downto 0);
        opA : in std_logic_vector(31 downto 0);
        opB : in std_logic_vector(31 downto 0);
        shamt : in std_logic_vector(4 downto 0);
        Imm : in std_logic_vector(15 downto 0);
        c_in : in std_logic;
        sel : in std_logic_vector(2 downto 0);
        opSel : out std_logic;
        result : out std_logic_vector(31 downto 0);
        c_out : out std_logic;
        cond : out std_logic        
);
end entity ALU32;

architecture behavioral of ALU32 is 
component ALU1b port (  
        opA : in std_logic;
        opB : in std_logic;
        Imm : in std_logic;
        carry_in : in std_logic;
        sel : in std_logic_vector(2 downto 0);
        result : out std_logic;
        carry_out : out std_logic;
        condition : out std_logic        
);
end component;

signal carry_out : std_logic_vector(30 downto 0);
signal condition : std_logic_vector(31 downto 0);
signal temp : std_logic_vector(31 downto 0) := x"00000000";
signal ImmExt : std_logic_vector(31 downto 0);

begin
  process (opA, opB, Imm, sel, shamt) begin
    ImmExt <= x"0000" & Imm;
    case (sel) is
    when "100" => opSel <= '1';
    when others => opSel <= '0';
    end case;

    temp <= opA;
    if shamt/="00000" then
      if shamt(0)='1' then
        temp <= '0' & temp(31 downto 1);
      end if;
      if shamt(1)='1' then
        temp <= "00" & temp(31 downto 2);
      end if;
      if shamt(2)='1' then
        temp <= "0000" & temp(31 downto 4);
      end if;
      if shamt(3)='1' then
        temp <= x"00" & temp(31 downto 8);
      end if;
      if shamt(4)='1' then
        temp <= x"0000" & temp(31 downto 16);
      end if;
    end if;
  end process;

  cond <= condition(0) and condition(1) and condition(2) and condition(3) and condition(4) and condition(5) and condition(6) and condition(7) and 
          condition(8) and condition(9) and condition(10) and condition(11) and condition(12) and condition(13) and condition(14) and condition(15) and 
          condition(16) and condition(17) and condition(18) and condition(19) and condition(20) and condition(21) and condition(22) and condition(23) and 
          condition(24) and condition(25) and condition(26) and condition(27) and condition(28) and condition(29) and condition(30) and condition(31);
          
  b0 : ALU1b port map(opA=>temp(0), opB=>opB(0), Imm=>ImmExt(0), carry_in=>c_in, sel=>sel, result=>result(0), carry_out=>carry_out(0), condition=>condition(0));
  b1 : ALU1b port map(opA=>temp(1), opB=>opB(1), Imm=>ImmExt(1), carry_in=>carry_out(0), sel=>sel, result=>result(1), carry_out=>carry_out(1), condition=>condition(1));
  b2 : ALU1b port map(opA=>temp(2), opB=>opB(2), Imm=>ImmExt(2), carry_in=>carry_out(1), sel=>sel, result=>result(2), carry_out=>carry_out(2), condition=>condition(2));
  b3 : ALU1b port map(opA=>temp(3), opB=>opB(3), Imm=>ImmExt(3), carry_in=>carry_out(2), sel=>sel, result=>result(3), carry_out=>carry_out(3), condition=>condition(3));
  b4 : ALU1b port map(opA=>temp(4), opB=>opB(4), Imm=>ImmExt(4), carry_in=>carry_out(3), sel=>sel, result=>result(4), carry_out=>carry_out(4), condition=>condition(4));
  b5 : ALU1b port map(opA=>temp(5), opB=>opB(5), Imm=>ImmExt(5), carry_in=>carry_out(4), sel=>sel, result=>result(5), carry_out=>carry_out(5), condition=>condition(5));
  b6 : ALU1b port map(opA=>temp(6), opB=>opB(6), Imm=>ImmExt(6), carry_in=>carry_out(5), sel=>sel, result=>result(6), carry_out=>carry_out(6), condition=>condition(6));
  b7 : ALU1b port map(opA=>temp(7), opB=>opB(7), Imm=>ImmExt(7), carry_in=>carry_out(6), sel=>sel, result=>result(7), carry_out=>carry_out(7), condition=>condition(7));
  b8 : ALU1b port map(opA=>temp(8), opB=>opB(8), Imm=>ImmExt(8), carry_in=>carry_out(7), sel=>sel, result=>result(8), carry_out=>carry_out(8), condition=>condition(8));
  b9 : ALU1b port map(opA=>temp(9), opB=>opB(9), Imm=>ImmExt(9), carry_in=>carry_out(8), sel=>sel, result=>result(9), carry_out=>carry_out(9), condition=>condition(9));
  b10 : ALU1b port map(opA=>temp(10), opB=>opB(10), Imm=>ImmExt(10), carry_in=>carry_out(9), sel=>sel, result=>result(10), carry_out=>carry_out(10), condition=>condition(10));
  b11 : ALU1b port map(opA=>temp(11), opB=>opB(11), Imm=>ImmExt(11), carry_in=>carry_out(10), sel=>sel, result=>result(11), carry_out=>carry_out(11), condition=>condition(11));
  b12 : ALU1b port map(opA=>temp(12), opB=>opB(12), Imm=>ImmExt(12), carry_in=>carry_out(11), sel=>sel, result=>result(12), carry_out=>carry_out(12), condition=>condition(12));
  b13 : ALU1b port map(opA=>temp(13), opB=>opB(13), Imm=>ImmExt(13), carry_in=>carry_out(12), sel=>sel, result=>result(13), carry_out=>carry_out(13), condition=>condition(13));
  b14 : ALU1b port map(opA=>temp(14), opB=>opB(14), Imm=>ImmExt(14), carry_in=>carry_out(13), sel=>sel, result=>result(14), carry_out=>carry_out(14), condition=>condition(14));
  b15 : ALU1b port map(opA=>temp(15), opB=>opB(15), Imm=>ImmExt(15), carry_in=>carry_out(14), sel=>sel, result=>result(15), carry_out=>carry_out(15), condition=>condition(15));
  b16 : ALU1b port map(opA=>temp(16), opB=>opB(16), Imm=>ImmExt(16), carry_in=>carry_out(15), sel=>sel, result=>result(16), carry_out=>carry_out(16), condition=>condition(16));
  b17 : ALU1b port map(opA=>temp(17), opB=>opB(17), Imm=>ImmExt(17), carry_in=>carry_out(16), sel=>sel, result=>result(17), carry_out=>carry_out(17), condition=>condition(17));
  b18 : ALU1b port map(opA=>temp(18), opB=>opB(18), Imm=>ImmExt(18), carry_in=>carry_out(17), sel=>sel, result=>result(18), carry_out=>carry_out(18), condition=>condition(18));
  b19 : ALU1b port map(opA=>temp(19), opB=>opB(19), Imm=>ImmExt(19), carry_in=>carry_out(18), sel=>sel, result=>result(19), carry_out=>carry_out(19), condition=>condition(19));
  b20 : ALU1b port map(opA=>temp(20), opB=>opB(20), Imm=>ImmExt(20), carry_in=>carry_out(19), sel=>sel, result=>result(20), carry_out=>carry_out(20), condition=>condition(20));
  b21 : ALU1b port map(opA=>temp(21), opB=>opB(21), Imm=>ImmExt(21), carry_in=>carry_out(20), sel=>sel, result=>result(21), carry_out=>carry_out(21), condition=>condition(21));
  b22 : ALU1b port map(opA=>temp(22), opB=>opB(22), Imm=>ImmExt(22), carry_in=>carry_out(21), sel=>sel, result=>result(22), carry_out=>carry_out(22), condition=>condition(22));
  b23 : ALU1b port map(opA=>temp(23), opB=>opB(23), Imm=>ImmExt(23), carry_in=>carry_out(22), sel=>sel, result=>result(23), carry_out=>carry_out(23), condition=>condition(23));
  b24 : ALU1b port map(opA=>temp(24), opB=>opB(24), Imm=>ImmExt(24), carry_in=>carry_out(23), sel=>sel, result=>result(24), carry_out=>carry_out(24), condition=>condition(24));
  b25 : ALU1b port map(opA=>temp(25), opB=>opB(25), Imm=>ImmExt(25), carry_in=>carry_out(24), sel=>sel, result=>result(25), carry_out=>carry_out(25), condition=>condition(25));
  b26 : ALU1b port map(opA=>temp(26), opB=>opB(26), Imm=>ImmExt(26), carry_in=>carry_out(25), sel=>sel, result=>result(26), carry_out=>carry_out(26), condition=>condition(26));
  b27 : ALU1b port map(opA=>temp(27), opB=>opB(27), Imm=>ImmExt(27), carry_in=>carry_out(26), sel=>sel, result=>result(27), carry_out=>carry_out(27), condition=>condition(27));
  b28 : ALU1b port map(opA=>temp(28), opB=>opB(28), Imm=>ImmExt(28), carry_in=>carry_out(27), sel=>sel, result=>result(28), carry_out=>carry_out(28), condition=>condition(28));
  b29 : ALU1b port map(opA=>temp(29), opB=>opB(29), Imm=>ImmExt(29), carry_in=>carry_out(28), sel=>sel, result=>result(29), carry_out=>carry_out(29), condition=>condition(29));
  b30 : ALU1b port map(opA=>temp(30), opB=>opB(30), Imm=>ImmExt(30), carry_in=>carry_out(29), sel=>sel, result=>result(30), carry_out=>carry_out(30), condition=>condition(30));
  b31 : ALU1b port map(opA=>temp(31), opB=>opB(31), Imm=>ImmExt(31), carry_in=>carry_out(30), sel=>sel, result=>result(31), carry_out=>c_out, condition=>condition(31));
  
--process (shamt)
--variable t :std_logic_vector(31 downto 0) := opA;
--begin
--  if shamt(0)='1' then
--    t := '0' & t(31 downto 1);
--  end if;
--  if shamt(1)='1' then
--    t := "00" & t(31 downto 2);
--  end if;
--  if shamt(2)='1' then
--    t := "0000" & t(31 downto 4);
--  end if;
--  if shamt(3)='1' then
--    t := x"00" & t(31 downto 8);
--  end if;
--  if shamt(4)='1' then
--    t := x"0000" & t(31 downto 16);
--  end if;
--  result <= t;
--end process;


end architecture;