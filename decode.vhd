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
		Forward_From_MA:in std_logic_vector(31 downto 0)
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
signal S1,S2,stack_value,inport_out,outport_out,reg_s1,reg_s2: std_logic_vector(7 downto 0);
signal Rs1,Rs2	: std_logic_vector(1 downto 0);
begin
 Rs2<=From_Fetch(1 downto 0);
 Rs1<=From_Fetch(3 downto 2);

  PC_In <= From_Fetch(7 downto 0) when From_Fetch(15 downto 8) = "00000000"
    else From_Fetch(15 downto 8) + 1;
    
    -- forward implement
        -- from excute
    S1 <= Forward_from_execute(7 downto 0) when Forward_from_execute(27 downto 26) = Rs1 and Forward_from_execute(31) = '1'
      --from MA and  it's MA operation
      else Forward_From_MA(7 downto 0) when Forward_From_MA(27 downto 26) = Rs1 and Forward_From_MA(31) = '1' and Forward_From_MA(25) = '1'
      -- from MA and it's NOT Ma operation 
      else Forward_From_MA(15 downto 8) when Forward_From_MA(27 downto 26) = Rs1 and Forward_From_MA(31) = '1' and Forward_From_MA(25) = '0'
      -- from WA 
      else From_wb(7 downto 0) when From_wb(27 downto 26) = Rs1 and From_wb(31) = '1'
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
        


  CU_MODUL		 :cu port map(rst,S1,S2,in_port,stack_value,From_Fetch,to_idex);
  Reg_file_MODUL :Reg_file port map(notclk,rst,'1',Rs1,Rs2,reg_s1,reg_s2,stack_value,From_wb);

  -----------------forward from execute got 1WB(31),1 NOP(30),2 rd(27-26) , 1 MA(25) ,8 result(7-0)
  -----------------forward from MA got 1WB(31),1 NOP(30),2 RD(27-26),1 MA(25),1 sp(16), ALu or sp(15-8),result(7-0)
  -----------------forward from wb(From_wb) got 1WB(31),1 NOP(30),2 RD(27-26),1 sp(16), ALu or sp(15-8),result(7-0)
end decode_arch;

