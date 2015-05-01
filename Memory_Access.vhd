library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


Entity Memory_Access  is
port (
clk : in std_logic;
Mem_In: in std_logic_vector(31 downto 0);
Mem_Out:out std_logic_vector(31 downto 0));
end Memory_Access;



architecture Mem_Arch of Memory_Access is
  -- Mem_In(7 down to 0): Result"address" ,,Mem_In(15 down to 8): data, Mem_In(17 down to 16): Rd , Mem_In(18): R/W , Mem_In(19):NOP


	signal data_in,result,MFC_out :std_logic_vector(7 downto 0) ; 
   signal NOP, write_en,sp,ls, read_en,MA :std_logic;
	 signal Rd : std_logic_vector(1 downto 0);
	 
component data_memory  is
port (
clk : in std_logic;
R,W : in std_logic;
address : in std_logic_vector(7 downto 0);
datain : in std_logic_vector(7 downto 0);
dataout : out std_logic_vector(7 downto 0);
MFC:out std_logic
 );
end  component ;

   begin 
	 -- I/P
	 --1NOP & 1LS & 1sp & 2rd & 1MA & 8s2 & 8result
	result<= Mem_In(7 downto 0); 
  data_in <= Mem_In( 15 downto 8);
	MA <= Mem_In(16);
	Rd<= Mem_In(18 downto 17); 
	sp<= Mem_In (19);
	ls<= Mem_In(20);
	NOP<=Mem_In(21);
	 
	-----------------------------------
	  -- O/P
		-- 1LS& 1MA &2rd & 1sp_out &8ALSU_OUT aka sp value, 8result_out
  Mem_Out(7 downto 0)<=MFC_out;
  Mem_Out(15 downto 8)<=result;
  Mem_Out(16)<= sp;
  Mem_Out(18 downto 17)<=Rd;
	Mem_Out(19)<=MA;
	Mem_Out(20)<=LS;
	Mem_Out(21)<=Mem_In(21);
  -------------------------------------------------------------
	 
	 write_en<= ls and MA and not NOP ;
	 read_en<=  not ls and MA and not NOP;   
   D_mem: data_memory port map (clk,read_en,write_en,result,data_in,MFC_out);


  
	 

   
   
end architecture Mem_Arch ;
