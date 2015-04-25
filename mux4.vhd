Library ieee;
Use ieee.std_logic_1164.all;
entity mux4 is 
   generic (n : integer := 16);
	port ( a,b,c,d : in std_logic_vector(n-1 downto 0) ;
	  s :in std_logic_vector(1 downto 0);
		y:out std_logic_vector(n-1 downto 0)
			);
			
end entity mux4;


-- take care of the usage of when else 
architecture  Data_flow of mux4 is
begin
     y <=   a WHEN s(1) = '0' and s(0) ='0'
       ELSE b WHEN s(1) = '0' and s(0) ='1'
       ELSE c WHEN s(1) = '1' and s(0) ='0'
	   ELSE d;
end Data_flow;
