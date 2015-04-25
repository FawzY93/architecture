Library ieee;
Use ieee.std_logic_1164.all;

Entity my_nreg is
Generic ( n : integer := 8);
port( Clk,Rst,ENA : in std_logic;
d : in std_logic_vector(n-1 downto 0);
q : out std_logic_vector(n-1 downto 0));
end my_nreg;
Architecture Arch_my_nreg of my_nreg is
Component my_reg is
               port( d,Clk,Rst,enable : in std_logic;  
                q : out std_logic);
end component;
begin
loop1: for i in 0 to n-1 generate
fx: my_reg port map(d(i),Clk,Rst,ENA,q(i));
end generate;
end Arch_my_nreg;