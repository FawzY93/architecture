Library ieee;
use ieee.std_logic_1164.all;
entity B is
  port(a,b :in std_logic_vector(7 downto 0);
        s :in std_logic_vector(1 downto 0);
        f :out std_logic_vector(7 downto 0);
		FLAGSB:out std_logic_vector(3 downto 0)
		);
end B;
architecture arch1 of B is
  signal fout:std_logic_vector(7 downto 0);
  begin
    fout<= a and b when s(0)='0' and s(1) ='0' 
  else a or b when  s(0)='1' and s(1) ='0'
  else a xor b when s(0)='0' and s(1) ='1'
  else not a;
  f<=fout;  
  FLAGSB(0)<= '0';
	FLAGSB(1)<= '0';
  FLAGSB(2)<='1' when fout="00000000"
else '0';
  FLAGSB(3)<=fout(7);
  end arch1;
