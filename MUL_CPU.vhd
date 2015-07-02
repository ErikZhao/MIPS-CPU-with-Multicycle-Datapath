library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
ENTITY fsm  IS 
END ;  
architecture behavioral of FSM is
  component mem port (  address : in std_logic_vector(7 downto 0);
        rw : in std_logic;  -- 0:write  1:read
        data_in : in std_logic_vector(31 downto 0);
        opCtrl : out std_logic;
        data_out : out std_logic_vector(31 downto 0)
      );
  end component;
  
  component reg_file port (  reg_id : in std_logic_vector(4 downto 0);
        reg_id2 : in std_logic_vector(4 downto 0);
        rw      : in std_logic;
        data_in : in std_logic_vector(31 downto 0);
        data_out: out std_logic_vector(31 downto 0);
        data_out2 : out std_logic_vector(31 downto 0)
      );
  end component;
  
  component ALU32 port (  opA : in std_logic_vector(31 downto 0);
              opB : in std_logic_vector(31 downto 0);
              Imm : in std_logic_vector(15 downto 0);
              shamt : in std_logic_vector(4 downto 0);
              c_in : in std_logic;
              sel : in std_logic_vector(2 downto 0);
              opSel : out std_logic;
              result : out std_logic_vector(31 downto 0);
              c_out : out std_logic;
              cond : out std_logic        
      );
  end component;
  
  type state is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10);
  signal present : state := s0;
  signal future : state := s0;
  signal PC, newPC : std_logic_vector(31 downto 0) := x"00000000";
  signal IR : std_logic_vector(31 downto 0) := x"00000000";
  signal Rd, Rs, Rt : std_logic_vector(4 downto 0) := "00000";
  signal opcode, fcode : std_logic_vector(5 downto 0) := "000000";
  signal icode : std_logic_vector(15 downto 0) := x"0000";
  signal acode : std_logic_vector(25 downto 0) := x"000000" & "00";
  signal clk0 : std_logic := '1';
  
  --ALU signals
  signal opA, opB, result : std_logic_vector(31 downto 0) := x"00000000";
  signal shamt : std_logic_vector(4 downto 0) := "00000";
  signal Imm : std_logic_vector(15 downto 0):= x"0000";
  signal c_in, c_out, cond : std_logic := '0';
  signal ALU_sel : std_logic_vector(2 downto 0) := "000";
  signal ALU_ex, ALUSrcA : std_logic := '0';
  --signal ALUSrcB : std_logic_vector(1 downto 0) := "00";
  signal opSel : std_logic := '0';
  
  --register file signals
  signal reg_id, reg_id2 : std_logic_vector(4 downto 0) := "00000";
  signal reg_rw : std_logic := '1';
  signal reg_ex : std_logic := '0';
  signal reg_in, reg_out, reg_out2, reg_buffer : std_logic_vector(31 downto 0) := x"00000000";
  
  --memory signals
  signal address : std_logic_vector(7 downto 0) := "00000000";
  signal mem_rw : std_logic := '1';
  signal mem_in, mem_out, mem_buffer : std_logic_vector(31 downto 0) := x"00000000";
  signal mem_opCtrl : std_logic := '1';
  
  --PC signals
--  signal PCWrite : std_logic := '0';
--  signal PCSrc : std_logic_vector(1 downto 0) := "11";
  
begin
  reg : reg_file port map(reg_id=>reg_id, reg_id2=>reg_id2, rw=>reg_rw, data_in=>reg_in, data_out=>reg_out, data_out2=>reg_out2);
  mem1 : mem port map(address=>address, rw=>mem_rw, data_in=>mem_in, opCtrl=>mem_opCtrl, data_out=>mem_out);
  ALU : ALU32 port map(opA=>opA, opB=>opB, shamt=>shamt, Imm=>Imm, result=>result, c_in=>c_in, c_out=>c_out, cond=>cond, sel=>ALU_sel, opSel=>opSel);
  
  process begin
    wait for 50 ns;
    clk0 <= not clk0;
  end process;
  
  process(clk0) begin
    if rising_edge(clk0) then
      present <= future;
    end if;
  end process;  

  process(present, mem_opCtrl, opSel, result, cond, reg_out, reg_out2)
  begin
    case present is
      when s0 => 
        -- Instruction Fetch
        reg_rw <= '1';
        mem_rw <= '1';
        reg_id <= "00000";
        reg_id2 <= "00000";
        shamt <= "00000";
        address <= PC(7 downto 0);
        if mem_opCtrl = '1' then
          IR <= mem_out;
        end if;
        
        opA <= PC;
        opB <= x"00000004";
        ALU_sel <= "100";
        newPC <= result;
        
        future <= s1;
      when s1 =>
        
        PC <= newPC;
        opcode <= IR(31 downto 26);
        Rd <= IR(15 downto 11);
        Rs <= IR(25 downto 21);
        Rt <= IR(20 downto 16);
        icode <= IR(15 downto 0);
        acode <= IR(25 downto 0);
        fcode <= IR(5 downto 0);

        case IR(31 downto 26) is
        when "100011" => 
          --lw 
          future <= s2;
        when "101011" =>
          --sw
          future <= s2;
        when "000000" =>
          -- R-type
            future <= s6;
        when "000100" =>
          -- branch
          future <= s8;
        when "001101" =>
          -- ORI
          future <= s9;
        when others => future <= s0;
        end case;
      when s2 =>
          --load word / store word
          reg_id <= Rs;
          reg_rw <= '1';
          Imm <= icode;
          ALU_sel <= "001";
          ALU_ex <= '1';
          opA <= reg_out;

        if opcode="100011" then
          future <= s3;
        elsif opcode="101011" then 
          future <= s5;
        else
          future <= s0;
        end if;
      when s3 =>
        reg_id <= "00000";
        mem_rw <= '1';
        address <= result(7 downto 0);
        --mem_buffer <= mem_out;
        future <= s4;
      when s4 =>
        reg_rw <= '0';
        reg_id <= Rt;
        reg_in <= mem_out;
        future <= s0;
        --mem_rw <= '0';
     when s5 =>
        --store word in memory
        mem_rw <= '0';
        address <= result(7 downto 0);
        mem_in <= reg_out;
       reg_id <= Rt;
        reg_rw <= '1';
        future <= s0;
      when s6 =>
        if fcode="100000" then
          -- add
          reg_id <= Rs;
          reg_id2 <= Rt;
          reg_rw <= '1';
          opA <= reg_out;
          opB <= reg_out2;
          ALU_sel <= "000";
          --ALU_ex <= '1';
          future <= s7;
        elsif fcode="000010" then
          --SRL
          shamt <= IR(10 downto 6);
          reg_id <= Rt;
          reg_rw <= '1';
          opA <= reg_out;
          opB <= x"00000000";
          ALU_sel <= "101";
          future <= s7;
        end if;
      when s7 =>
        reg_rw <= '0';
        reg_id <= Rd;
        reg_in <= result;
        future <= s0;
      when s8 =>
        reg_rw <= '1';
        reg_id <= Rs;
        reg_id2 <= Rt;
        opA <= reg_out;
        opB <= reg_out2;
        ALU_sel <= "010";
        if cond='1' then
          PC <= "00000000000000" & Imm & "00";
        else
          PC <= newPC;
        end if;
        future <= s0;
      when s9 =>
        ALU_sel <= "011";
        reg_rw <= '1';
        reg_id <= Rs;
        opA <= reg_out;
        Imm <= icode;
        future <= s10;
      when s10 =>
        reg_rw <= '0';
        reg_id <= Rt;
        reg_in <= result;
        future <= s0;
      when others =>
        future <= s0;
    end case;          
  end process;
end behavioral;

