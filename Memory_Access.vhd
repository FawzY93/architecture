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


	signal data_in,result :std_logic_vector(7 downto 0) ; 
   signal R_W,NOP, write_en, read_en,MFC_out :std_logic;
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
	 result<= Mem_In(7 downto 0); 
   data_in <= Mem_In( 15 downto 8);
	 Rd <= Mem_In(17 downto 16); 
	 R_W<= Mem_In(18); 
	 NOP<= Mem_In (19); 
	 
	 Mem_Out(31 downto 19) <=(others =>'0'); 
	 Mem_Out(18)<= NOP; 
	 Mem_Out(17 downto 16) <= Rd when NOP='0'
	 else "00" ; 
	 Mem_Out(15 downto 8) <= data_in when NOP='0' 
	 else "00";
	 Mem_Out(7 downto 0) <= result when NOP='0' 
	 else "00"; 
	 
	 write_en<= 
	 
	 read_en<=  
	 
	    
   D_mem: data_memory port map (clk,read_en,write_en,result,data_in,MFC_out);

	 
	 

   
   
end architecture Mem_Arch ;
