
Library ieee;
use ieee.std_logic_1164.all;
entity D is
  port( cin :in std_logic;
        a :in std_logic_vector(7 downto 0);
        s :in std_logic_vector(1 downto 0);
        f :out std_logic_vector(7 downto 0);
		FLAGSD:out std_logic_vector(3 downto 0)
		);
end D;
architecture arch3 of D is
  signal fout:std_logic_vector(7 downto 0);
  begin
    fout<= a(6 downto 0)&'0' when  s(1)='0' and s(0) ='0'
  else a(6 downto 0)&a(7) when  s(0)='1' and s(1) ='0'
  else a(6 downto 0)&cin when s(0)='0' and s(1) ='1'
  else "00000000";
  f<=fout;  
  FLAGSD(0)<= a(7) xnor a(6);
  FLAGSD(1)<='0' when s(0)='1' and s(1)='0'
  else a(7);
  FLAGSD(2)<='1' when fout="00000000"
  else '0';
  FLAGSD(3)<=fout(7);
      
  end arch3;
