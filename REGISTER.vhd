library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;

entity reg_file is
port (  reg_id : in std_logic_vector(4 downto 0);
        rw      : in std_logic;
        data_in : in std_logic_vector(31 downto 0);
        data_out: out std_logic_vector(31 downto 0);
        reg_id2 : in std_logic_vector(4 downto 0);
        data_out2 : out std_logic_vector(31 downto 0)
      );
end reg_file;

architecture behavioral of reg_file is 

type r_file_type is array (31 downto 0) of std_logic_vector(31 downto 0);  
signal r_file : r_file_type;
signal init : std_logic := '1';

begin
  process(init, reg_id, reg_id2, rw, data_in) begin
    if init='1' then
      for i in 0 to 31 loop
        r_file(i) <= conv_std_logic_vector(i,32);
      end loop;
      --r_file(18) <= x"00000015";
      init <= '0';
    end if;
    
    if rw='0' then
      r_file(to_integer(IEEE.numeric_std.unsigned(reg_id))) <= data_in;
    else
      data_out <= r_file(to_integer(IEEE.numeric_std.unsigned(reg_id)));
      data_out2 <= r_file(to_integer(IEEE.numeric_std.unsigned(reg_id2)));
    end if;
  end process;  
  
end architecture;

