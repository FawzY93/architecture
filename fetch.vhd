library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
-- 15->8 [PC] 7->0 [instruction]
Entity fetch is
port(
		 clk 	:in std_logic;
		 PC		:in std_logic_vector(7 downto 0);
		 From_decode:in std_logic; --for L operations
		 Intr,save_flags,temp_stall :in std_logic;--for Intr
		 pop_pc:in std_logic;
		 Inst_pc:out std_logic_vector(31 downto 0);
		 ea_imm : out std_logic_vector(7 downto 0)
		 );
end fetch;
architecture f_arch of fetch is
   type ram_type is array(0 to 255) of std_logic_vector(7 downto 0);
--test
	signal ram : ram_type ;
	signal dataout: std_logic_vector(7 downto 0); --instruction
	signal push_pc,restor_flags,prev:std_logic;
	begin
	restor_flags<='1' when dataout(7 downto 2)="101111"
	else '0';

	Inst_pc(15 downto 8)<= PC;
	-------------------------------------------------
	Inst_pc(7 downto 0)<= "10110100" when push_pc='1'         --INT
	else "00000000" when temp_stall='1'      --INT
	else "01110000" when save_flags='1'		 --INT
	else "01110100" when restor_flags='1'	 --RTI
	else "10111000" when pop_pc='1'			 --RTI
	else dataout when From_decode='0'
	else (others=>'0');
    -------------------------------------------------

	Inst_pc(16)<=push_pc;
	-------------------------------------------------
	Inst_pc(17)<='1' when save_flags='1'
	else '0';
	-------------------------------------------------
	Inst_pc(18)<=restor_flags;
	ea_imm<=dataout;
	-------------------------------------------------
	Inst_pc(26 downto 19)<=dataout;
	-------------------------------------------------
	Inst_pc(27)<= '1' when temp_stall='1'
	else '0';
	-------------------------------------------------
	Inst_pc(31 downto 28)<=(others=>'0');
	-------------------------------------------------	

		process(clk,Intr) is
		  Begin
		  	if Intr='1' and prev/='1' then
		  		push_pc<='1';
		  	else push_pc<='0';	
 			end if;
			if falling_edge(clk) then 
				dataout <= ram(to_integer(unsigned(PC)));	
				prev<=Intr;
			end if;
				
			
		end process;



end f_arch;
 