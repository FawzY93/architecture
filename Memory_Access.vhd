library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;


Entity Memory_Access  is
port (
clk : in std_logic;
Mem_In: in std_logic_vector(40 downto 0);
Mem_Out:out std_logic_vector(40 downto 0);
Forward_From_MA:out std_logic_vector(31 downto 0)
);
end Memory_Access;



architecture Mem_Arch of Memory_Access is
  -- Mem_In(7 down to 0): Result"address" ,,Mem_In(15 down to 8): data, Mem_In(17 down to 16): Rd , Mem_In(18): R/W , Mem_In(19):NOP


	signal data_in,aluOrSp,result,dataout :std_logic_vector(7 downto 0) ; 
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

	--1no_op & 1LS & 1sp & 2rd & 1MA& 9 bits non use  & 8s2 & 8result
	result<= Mem_In(7 downto 0); 
  	data_in <= Mem_In( 15 downto 8);
	
	MA <= Mem_In(25);
	Rd<= Mem_In(27 downto 26); 
	sp<= Mem_In (28);
	ls<= Mem_In(29);
	NOP<=Mem_In(30);
	-----------------------------------
	  -- O/P
	-- 1LS& 1MA &2rd & 1sp_out &8ALSU_OUT or sp value, 8result_out
	Mem_Out(7 downto 0)<=dataout;
	aluOrSp<=result-1 when LS='0' and sp='1' and Ma='1' 
	else result;
	Mem_Out(15 downto 8)<=aluOrSp;
	Mem_Out(16)<= sp;
	-----------------------------------------
	Mem_Out(24 downto 17)<=(others=>'0');
	-----------------------------------------
	Mem_Out(25)<=MA;
	Mem_Out(27 downto 26)<=Rd;
	Mem_Out(28)<=sp;
  	Mem_Out(29)<=LS;
    Mem_Out(21)<=Mem_In(21);
    Mem_Out(30)<=Mem_In(30);
    Mem_Out(31)<=Mem_In(31); 
    Mem_Out(32)<=Mem_In(32); --outport enable
	---------------------------------------------
	Mem_Out(40 downto 33)<=(others=>'0');
  	------------------------------------------------------------
	Forward_From_MA(7 downto 0)<=dataout;
	Forward_From_MA(15 downto 8)<=aluOrSp;
	Forward_From_MA(16)<=sp;
	Forward_From_MA(24 downto 17)<=(others=>'0');
	Forward_From_MA(27 downto 26)<=Rd;
	Forward_From_MA(25)<=MA;
	Forward_From_MA(28)<=sp;
	Forward_From_MA(29)<='0';
	Forward_From_MA(30)<=Mem_In(30);
	Forward_From_MA(31)<=Mem_In(31);
     write_en<= not ls and MA and not NOP ;
     read_en<=  not write_en;
   D_mem: data_memory port map (clk,read_en,write_en,result,data_in,dataout);
   
end architecture Mem_Arch ;
