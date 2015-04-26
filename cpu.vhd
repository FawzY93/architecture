Library ieee;
use ieee.std_logic_1164.all;
entity cpu is
  port( clk,rst :in std_logic
        );
end cpu;

architecture cpu_arch of cpu is
  component my_nreg is
    Generic ( n : integer :=8);
    port( Clk,Rst,ENA : in std_logic;
    d : in std_logic_vector(n-1 downto 0);
    q : out std_logic_vector(n-1 downto 0));
  end component;
  component cu is
	port(
	inst 	  :	in std_logic_vector(7 downto 0);
	Rs1,Rs2	  : out std_logic_vector(1 downto 0);
	opr		  : out std_logic_vector(3 downto 0);
	CF		  : out std_logic_vector(3 downto 0); -- change flags
	ME        : out std_logic;
	MA		  : out std_logic; -- 1 when push , pop , load or store 
	Rd   	  : out std_logic_vector(1 downto 0); -- read from destination of this index  from WB
	sp   	  : out std_logic; -- 1 when push or pop
	LS		  : out std_logic; -- 1 when write in memory(push,store) , 0 when read (pop,load)
	R  	  	  : out std_logic);
  end component;
  
	component Reg_file  is
	port (
	clk,rst   : in std_logic;
	R,W		  : in std_logic;-- read , write
	Rs1,Rs2,Rd: in std_logic_vector (1 downto 0);
	Datain    : in std_logic_vector (7 downto 0);
	sp		  : in std_logic;
	new_stack_value	  : in std_logic_vector(7 downto 0); --new value of the stack pointer
	S1,S2     :out std_logic_vector (7 downto 0));
	end component;
	component ALSU is 
	port(a1,a2 :in std_logic_vector(7 downto 0);
	 s :in std_logic_vector(3 downto 0);
	 Cin :in std_logic;
	 outt :out std_logic_vector(7 downto 0);
	 FLAGS:out std_logic_vector(3 downto 0) --(0) OV ,(1) C ,(2) Z ,(3) N
	 );
	end component;

  signal W,R,sp_from_cu,sp_from_wb,LS,notclk ,MA:std_logic;
  signal Rs1,Rs2,Rd	  :std_logic_vector(1 downto 0);
  signal opr,CF,ALSU_FLAGS		  :std_logic_vector(3 downto 0);
  signal Datain,new_stack_value,old_stack_value,S1,S2,ALSU_OUT       :std_logic_vector(7 downto 0);
  signal ifid_input,ifid_output :std_logic_vector(16 downto 0);
  signal idie_input,idie_output, iema_input,iema_output :std_logic_vector(32 downto 0);
  
  begin
  notclk<=not clk;
  -- IF/ID register
  --  8 pc & 8 instrucion 
  IFID_REG_MODULE:my_nreg generic map(16) port map(clk, rst, '1', ifid_input, ifid_output);
  CU_MODUL		 :cu port map(rst,ifid_output(7 downto 0),Rs1,Rs2,opr,CF,MA,Rd,sp_from_cu,LS,R);
  Reg_file_MODUL :Reg_file port map(notclk,rst,R,W,Rs1,Rs2,Rd,Datain,sp_from_wb,new_stack_value,S1,S2);
  -- 1LS & 1sp & 2rd & 1MA & 1cin &4change_flags & 4oper & 8s2 & 8s1
  idie_input(7 downto 0)<=S1;
  idie_input(15 downto 8)<=S2;
  idie_input(19 downto 16)<=opr;
  idie_input(23 downto 20)<=CF;
  idie_input(24)<='0';
  idie_input(25)<=MA;
  idie_input(27 downto 26)<=Rd;
  idie_input(28)<=sp;
  idie_input(29)<=LS;
  
  IDIE_REG_MODULE:my_nreg generic map(32) port map(clk, rst, '1', idie_input, idie_output);
  ALSU_MODUL:ALSU port map(idie_otput(7 downto 0),idie_output(15 downto 8),idie_input(19 downto 16),idie_input(24),ALSU_OUT,ALSU_FLAGS);
  -- 1LS & 1sp & 2rd & 1MA & 8s2 & 8result
  iema_input(7 downto 0)<= ALSU_OUT;
  iema_input(15 downto 8)<=idie_output(15 downto 8);
  iema_input(9)<= idie_output(25);
  iema_input(16 downto 9)<= idie_output(27 downto 26);
  iema_input(17)<= idie_output(28);
  iema_input(18)<= idie_output(29);
  
  IEMA_REG_MODULE:my_nreg generic map(32) port map(clk, rst, '1', iema_input, iema_output);



end cpu_arch;
