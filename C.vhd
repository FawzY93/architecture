Library ieee;
use ieee.std_logic_1164.all;
entity C is
  port( cin :in std_logic;
        a :in std_logic_vector(7 downto 0);
        s :in std_logic_vector(1 downto 0);
        f :out std_logic_vector(7 downto 0);
		FLAGSC:out std_logic_vector(3 downto 0)
		);
end C;
architecture arch2 of C is
  signal fout:std_logic_vector(7 downto 0);
  begin
    fout<= '0'&a(7 downto 1) when  s(0)='0' and s(1) ='0'
  else a(0)&a(7 downto 1) when  s(0)='1' and s(1) ='0'
  else cin & (a(7 downto 1)) when s(0)='0' and s(1) ='1'
  else a(7)&a(7 downto 1);
  f<=fout;
  FLAGSC(0)<= a(7) xor a(6);
  FLAGSC(1)<=a(0);
  FLAGSC(2)<='1' when fout="00000000"
  else '0';
  FLAGSC(3)<=fout(7);
  end arch2;
