library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


Entity data_memory  is
port (
clk : in std_logic;
R,W : in std_logic;
address  : in std_logic_vector(7 downto 0);
datain : in std_logic_vector(7 downto 0);
dataout : out std_logic_vector(7 downto 0);
MFC:out std_logic
 );
end entity data_memory;

architecture syncrama of data_memory is
   type ram_type is array(0 to 255) of std_logic_vector(7 downto 0);

	signal ram : ram_type ;

begin
process(clk) is
  Begin
if falling_edge(clk) then  
  if R = '0' and W='1' then
  ram(to_integer(unsigned(address))) <= datain;
  end if;
  if W= '0' and R='1' then
  dataout <= ram(to_integer(unsigned(address)));
  end if;
  if R = '1' and W='0' then
  MFC<='1';
  else 
  MFC<='0';
  end if;

end if;
end process;

end architecture syncrama;
