library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


Entity Write_Back  is
port (
clk : in std_logic;
WB_In: in std_logic_vector(31 downto 0);
Rd:out std_logic_vector(1 downto 0);
Data:out std_logic_vector(7 downto 0);
new_stack_value:out std_logic_vector(7 downto 0);
W,sp:out std_logic);
end Write_Back;



architecture WB_Arch of Write_Back is
begin
 -- I/P
--  1LS& 1MA & 2rd & 1sp &8ALSU_OUT or sp value& 8result_out
Data<=WB_In(7 downto 0) when MA='1'
else WB_In(15 downto 8);
new_stack_value<=WB_In(15 downto 8);
sp<=WB_In(16);
Rd<=WB_In(18 downto 17);
W<=not WB_In(19) or WB_In(20);  -- there will be writeback if its not MemoryAccess operation (MA=0)
                                -- or its Loading operation(pop,load)
end WB_Arch;
