Library ieee;
Use ieee.std_logic_1164.all;
entity ALSU is 
port(a1,a2 :in std_logic_vector(7 downto 0);
 s :in std_logic_vector(3 downto 0);
 Cin :in std_logic;
 outt :out std_logic_vector(7 downto 0);
 FLAGS:out std_logic_vector(3 downto 0) --(0) OV ,(1) C ,(2) Z ,(3) N
 );
end ALSU;

architecture arch4 of ALSU is
  component A is
  port(aa,b :in std_logic_vector(7 downto 0);
        cin :in std_logic;
        s :in std_logic_vector(1 downto 0);
        f :out std_logic_vector(7 downto 0);
        FLAGSA:out std_logic_vector(3 downto 0)
        );
  end component;
component B is 
  port(a,b :in std_logic_vector(7 downto 0);
        s :in std_logic_vector(1 downto 0);
        f :out std_logic_vector(7 downto 0);
        FLAGSB:out std_logic_vector(3 downto 0)
        );
end component ;

component C is 
port( cin :in std_logic;
        a :in std_logic_vector(7 downto 0);
        s :in std_logic_vector(1 downto 0);
        f :out std_logic_vector(7 downto 0);
        FLAGSC:out std_logic_vector(3 downto 0)
        );
end component ;

component D is  
   port( cin :in std_logic;
        a :in std_logic_vector(7 downto 0);
        s :in std_logic_vector(1 downto 0);
        f :out std_logic_vector(7 downto 0);
        FLAGSD:out std_logic_vector(3 downto 0)
        );
end component ;
  
component mux4 is
  generic (n : integer := 8);
  port ( a,b,c,d : in std_logic_vector(n-1 downto 0) ;
	  s :in std_logic_vector(1 downto 0);
		y:out std_logic_vector(n-1 downto 0)
		);	
end component	;
signal outd,outb,outc,outa :std_logic_vector(7 downto 0);
signal FLGd,FLGb,FLGc,FLGa:std_logic_vector(3 downto 0);
begin
  u0 : B port map(a1,a2,s(1 downto 0),outb,FLGb);
  u1 : C port map(Cin,a1,s(1 downto 0),outc,FLGc);
  u2 : D port map(Cin,a1,s(1 downto 0),outd,FLGd);
  u4: A port map(a1,a2,cin,s(1 downto 0),outa,FLGa);
  mux1 :mux4 generic map(8) port map(outa,outb,outc,outd,s(3 downto 2),outt);
  mux2 :mux4 generic map(4) port map(FLGa,FLGb,FLGc,FLGd,s(3 downto 2),FLAGS);
end arch4;