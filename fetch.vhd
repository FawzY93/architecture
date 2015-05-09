library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
-- 15->8 [PC] 7->0 [instruction]
Entity fetch is
port(
		 clk 	:in std_logic;
		 PC		:in std_logic_vector(7 downto 0);
		 From_decode:in std_logic; --for L operations
		 Inst_pc:out std_logic_vector(15 downto 0);
		 ea_imm : out std_logic_vector(7 downto 0)
		 );
end fetch;
architecture f_arch of fetch is
   type ram_type is array(0 to 255) of std_logic_vector(7 downto 0);
--test
	signal ram : ram_type ;
	signal dataout: std_logic_vector(7 downto 0); --instruction
	begin
	Inst_pc(15 downto 8)<= PC;
	Inst_pc(7 downto 0)<= dataout when From_decode='0'
	else (others=>'0');
	ea_imm<=dataout;
	
		process(clk) is
		  Begin
			if falling_edge(clk) then 
				dataout <= ram(to_integer(unsigned(PC)));	
			
			end if;
			
		end process;



end f_arch;
 