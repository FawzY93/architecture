Library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity decode is
	port(
    notclk,rst: in std_logic;
		From_Fetch :in std_logic_vector(15 downto 0);
		From_wb:in std_logic_vector(40 downto 0);
		in_port:in std_logic_vector(7 downto 0);
		to_idex	:out std_logic_vector(40 downto 0);
    PC_In :out std_logic_vector(7 downto 0);
		Forward_from_execute:in std_logic_vector(31 downto 0);						
		Forward_From_MA:in std_logic_vector(31 downto 0);
		ea_imm : in std_logic_vector(7 downto 0);
    From_decode: out std_logic
    );
end decode;

architecture decode_arch of decode is
component cu is
 	port( rst :in std_logic;
    s1,s2,in_port,sp: in std_logic_vector(7 downto 0);
	ifid_output: in std_logic_vector(15 downto 0);
    idex_input:out std_logic_vector(40 downto 0)
	);
end component;

component Reg_file  is
	port (
   clk,rst   : in std_logic;
   R    : in std_logic;
   Rs1,Rs2 :in std_logic_vector(1 downto 0);
   S1,S2,stack_value     :out std_logic_vector (7 downto 0);
   From_wb:in std_logic_vector(40 downto 0)
   );
	end component;
signal S1,S2,stack_value, stack_reg_value, inport_out,outport_out,reg_s1, reg_s2, pc_minus_1: std_logic_vector(7 downto 0);
signal Rs1,Rs2	: std_logic_vector(1 downto 0);
signal fetch_final,no_op_fetch: std_logic_vector(15 downto 0);
signal opcode: std_logic_vector(3 downto 0);
signal sp_hazard_in_sources, sources_in_execution_MA : std_logic;
begin
 Rs2<=From_Fetch(1 downto 0);
 Rs1<=From_Fetch(3 downto 2);
 opcode <= From_Fetch(7 downto 4);

  PC_In <= From_Fetch(7 downto 0) when From_Fetch(15 downto 8) = "00000000"
  else From_Fetch(15 downto 8) when sources_in_execution_MA = '1' or sp_hazard_in_sources = '1'
    else From_Fetch(15 downto 8) + 1;
    
    -- forward implement
        -- from excute
    S1 <= Forward_from_execute(7 downto 0) when Forward_from_execute(27 downto 26) = Rs1 and Forward_from_execute(31) = '1' and opcode /="1100"
      --from MA and it's MA operation
      else Forward_From_MA(7 downto 0) when Forward_From_MA(27 downto 26) = Rs1 and Forward_From_MA(31) = '1' and Forward_From_MA(25) = '1' and opcode /="1100"
      -- from MA and it's NOT Ma operation 
      else Forward_From_MA(15 downto 8) when Forward_From_MA(27 downto 26) = Rs1 and Forward_From_MA(31) = '1' and Forward_From_MA(25) = '0' and opcode /="1100"
      -- from WA 
      else From_wb(7 downto 0) when From_wb(27 downto 26) = Rs1 and From_wb(31) = '1' and opcode /="1100"
      --LDM LDD STD
      else ea_imm when opcode ="1100"
      --from register file      
      else reg_s1;
        
    S2 <= Forward_from_execute(7 downto 0) when Forward_from_execute(27 downto 26) = Rs2 and Forward_from_execute(31) = '1'
      --from MA and  it's MA operation
      else Forward_From_MA(7 downto 0) when Forward_From_MA(27 downto 26) = Rs2 and Forward_From_MA(31) = '1' and Forward_From_MA(25) = '1'
      -- from MA and it's NOT Ma operation 
      else Forward_From_MA(15 downto 8) when Forward_From_MA(27 downto 26) = Rs2 and Forward_From_MA(31) = '1' and Forward_From_MA(25) = '0'
      -- from WA 
      else From_wb(7 downto 0) when From_wb(27 downto 26) = Rs2 and From_wb(31) = '1'
      --from register file      
      else reg_s2;
    
      --sp equal to sp at MA when sp_flag at Ma  = 1
    stack_value <= Forward_From_MA(15 downto 8) when Forward_From_MA(28) = '1'
              -- sp equal wb when ot's sp_flag = 1
              else From_wb(15 downto 8) when From_wb(28) = '1'
              else stack_reg_value;

  CU_MODUL: cu port map(rst,S1,S2,in_port,stack_value,fetch_final,to_idex);
  Reg_file_MODUL: Reg_file port map(notclk, rst, '1', Rs1, Rs2, reg_s1, reg_s2, stack_reg_value, From_wb);

    --stall if one of my sources in execution and it's MA
  sources_in_execution_MA <= '1' when (Forward_from_execute(27 downto 26) = RS1 or Forward_from_execute(27 downto 26) = RS2) and Forward_from_execute(31) = '1' and Forward_from_execute(25) = '1' 
    else '0';
    -- stall if push or pop or source(1 or 2) = r3 and sp_flag in excute = 1
  sp_hazard_in_sources <= '1' when(( RS1 = "11" or RS2 = "11" or (opcode = "0111" and RS1(1) = '0')) and Forward_from_execute(28) = '1')
      else '0';
  From_decode<='1' when opcode="1100"
  else '0';
  pc_minus_1 <= From_Fetch(15 downto 8) - 1;
  no_op_fetch <= pc_minus_1&"00000000";

  fetch_final <=  no_op_fetch when sources_in_execution_MA = '1' or sp_hazard_in_sources = '1'
    else From_Fetch;

  -----------------forward from execute got 1WB(31),1 NOP(30),2 rd(27-26) , 1 MA(25) ,8 result(7-0)
  -----------------forward from MA got 1WB(31),1 NOP(30),2 RD(27-26),1 MA(25),1 sp(16), ALu or sp(15-8),result(7-0)
  -----------------forward from wb(From_wb) got 1WB(31),1 NOP(30),2 RD(27-26),1 sp(16), ALu or sp(15-8),result(7-0)
end decode_arch;

