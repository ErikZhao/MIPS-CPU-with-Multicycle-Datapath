library IEEE;
use IEEE.std_logic_1164.all;

entity ALU1b is
port (  opA : in std_logic;
        opB : in std_logic;
        Imm : in std_logic;
        carry_in : in std_logic;
        sel : in std_logic_vector(2 downto 0);
        result : out std_logic;
        carry_out : out std_logic;
        condition : out std_logic        
);
end entity ALU1b;

architecture behavioral of ALU1b is 
begin
  process(opA, opB, Imm, sel, carry_in) begin
    if sel="000" then --add opA and opB
      result <= (opA xor opB) xor carry_in;
      carry_out <= (not carry_in and opA and opB) or (carry_in and (opA or opB));
      condition <= '0';
    elsif sel="001" then --add opA and Imm
      result <= opA xor Imm xor carry_in;
      carry_out <= (not carry_in and opA and Imm) or (carry_in and (opA or Imm));
      condition <= '0';
    elsif sel="010" then --compare opA and opB for BEQ
      result <= '0';
      carry_out <= '0';
      condition <= opA xnor opB;
    elsif sel="011" then --ORI
      condition <= '0';
      carry_out <= '0';
      result <= opA or Imm;
    elsif sel="100" then --PC + 4
      result <= (opA xor opB) xor carry_in;
      carry_out <= (not carry_in and opA and opB) or (carry_in and (opA or opB));
      condition <= '0';
    elsif sel="101" then --SRL
      result <= opA;
      carry_out <= '0';
      condition <= '0';
    end if;
  end process;
    
end architecture behavioral;

