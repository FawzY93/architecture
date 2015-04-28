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
	R  	  	  : out std_logic;
	cin       : out std_logic);
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
	component execute is
	port( oper :in std_logic_vector(3 downto 0);
		cin :in std_logic;
		a,b :in std_logic_vector(7 downto 0);
		in_flags :in std_logic_vector(3 downto 0);
		change_flags : in std_logic_vector(3 downto 0);
		result :out std_logic_vector(7 downto 0);
		out_flags:out std_logic_vector(3 downto 0)
		);
	end component;
	component Memory_Access  is
	port (
		clk : in std_logic;
		Mem_In: in std_logic_vector(31 downto 0);
		Mem_Out:out std_logic_vector(31 downto 0));
	end component;
	component Write_Back  is
	port (
		clk : in std_logic;
		WB_In: in std_logic_vector(31 downto 0);
		Rd:out std_logic_vector(1 downto 0);
		Data:out std_logic_vector(7 downto 0);
		new_stack_value:out std_logic_vector(7 downto 0);
		W,sp:out std_logic);
	end component;

  signal cin,W,R,sp_from_cu,sp_from_wb,LS,notclk,sp_out ,MA:std_logic;
  signal Rs1,Rs2,Rd_from_cu,Rd_from_wb	  :std_logic_vector(1 downto 0);
  signal opr,CF,FLAGS_IN,FLAGS_OUT		  :std_logic_vector(3 downto 0);
  signal Datain,new_stack_value,old_stack_value,S1,S2,ALSU_OUT,result_out,sp_data_out :std_logic_vector(7 downto 0);
  signal ifid_input,ifid_output :std_logic_vector(16 downto 0);
  signal idex_input,idex_output, exmem_input,exmem_output,memwb_input,memwb_output :std_logic_vector(32 downto 0);
  
  begin
  notclk<=not clk;
  FLAG_REG_MODULE:my_nreg generic map(4) port map(clk,rst,'1',FLAGS_IN,FLAGS_OUT);
	------------------------------------FETCH----------------------------------------------
 
	IFID_REG_MODULE:my_nreg generic map(16) port map(clk, rst, '1', ifid_input, ifid_output);
  --  8 pc & 8 instrucion  
  
  ------------------------------------DECODE----------------------------------------------
  CU_MODUL		 :cu port map(rst,ifid_output(7 downto 0),Rs1,Rs2,opr,CF,MA,Rd_from_cu,sp_from_cu,LS,R,cin);
  Reg_file_MODUL :Reg_file port map(notclk,rst,R,W,Rs1,Rs2,Rd_from_wb,Datain,sp_from_wb,new_stack_value,S1,S2);
 
  -- 1LS & 1sp & 2rd & 1MA & 1cin &4change_flags & 4oper & 8s2 & 8s1
	idex_input(7 downto 0)<=S1;
  idex_input(15 downto 8)<=S2;
  idex_input(19 downto 16)<=opr;
  idex_input(23 downto 20)<=CF;
  idex_input(24)<=cin;
  idex_input(25)<=MA;
  idex_input(27 downto 26)<=Rd_from_cu;
  idex_input(28)<=sp;
  idex_input(29)<=LS;
  IDEX_REG_MODULE:my_nreg generic map(32) port map(clk, rst, '1', idex_input, idex_output);
  
  ------------------------------------EXECUTE----------------------------------------------
  EXECUTE_MODULE:execute port map(idex_output,exmem_input);
  
  EXMEM_REG_MODULE:my_nreg generic map(32) port map(clk, rst, '1', exmem_input, exmem_output);
  
  ------------------------------------MEMORY ACCESS----------------------------------------------
  MEMORY_ACCESS_MODULE:Memory_Access port map(clk,exmem_output,memwb_input);

  MEMWB_REG_MODULE:my_nreg generic map(32) port map(clk, rst, '1', memwb_input, memwb_output);
  
	------------------------------------WRITE BACK----------------------------------------------
	WRITE_BACK_MODULE:Write_Back port map(clk,memwb_output,Rd_from_wb,Datain,new_stack_value,W,sp_from_wb);
  
  
  
end cpu_arch;
