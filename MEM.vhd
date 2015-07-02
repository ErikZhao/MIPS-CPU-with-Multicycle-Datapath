library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity mem is
port (  address : in std_logic_vector(7 downto 0);
        rw : in std_logic;  -- 0:write  1:read
        data_in : in std_logic_vector(31 downto 0);
        opCtrl : out std_logic;
        data_out : out std_logic_vector(31 downto 0)
      );
end mem;

architecture behavioral of mem is 

type memtype is array (255 downto 0) of std_logic_vector(31 downto 0);  
signal mem : memtype := (others=> (others=>'0'));
signal init : std_logic := '1';

begin
  
  process(init, address, rw, data_in) begin
    if init = '1' then
      mem(0) <= "10001110010010110000000011001000";
      mem(1) <= "10101101100010110000000001100100";
      mem(2) <= "00000001010100101001100000100000";
      mem(3) <= "00010010101100101100100111110100";
      mem(4) <= "00110110101010101111111110101010";
      mem(5) <= "00000000000001100100000011000010";
      mem(54) <= x"000c8000";
      init <= '0';
    end if;
    
    if rw='0' then
      mem(to_integer(unsigned(address))/4) <= data_in;
      opCtrl <= '0';
    else
      data_out <= mem(to_integer(unsigned(address))/4);
      opCtrl <= '1';
    end if;
  end process;  


end architecture;
