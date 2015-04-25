Library ieee;
use ieee.std_logic_1164.all;
Entity my_reg is
port( d,clk,rst,enable : in std_logic;
q : out std_logic);
end my_reg;

Architecture a_my_reg of my_reg is
begin
process(clk,rst)
begin
if(rst = '1') then
        q <= '0';
elsif rising_edge(clk) and enable='1' then
 	    q <= d;
end if;
end process;
end a_my_reg;

