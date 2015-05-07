Library ieee;
use ieee.std_logic_1164.all;
entity cpu is
  port( clk,rst :in std_logic
        in_port:in std_logic_vector(7 downto 0);
        out_port:out std_logic_vector(7 downto 0)
        );
end cpu;

architecture cpu_arch of cpu is
  component my_nreg is
    Generic ( n : integer :=8);
    port( Clk,Rst,ENA : in std_logic;
    d : in std_logic_vector(n-1 downto 0);
    q : out std_logic_vector(n-1 downto 0));
  end component;
  	component fetch is
	port(
		 clk 	:in std_logic;
		 R 		:in std_logic;
		 PC		:in std_logic_vector(7 downto 0);
		 Inst_pc:out std_logic_vector(15 downto 0)
		 --Done 	:out std_logic
		 );
	end component;
  	component decode is
	port(
		From_Fetch :in std_logic_vector(15 downto 0);
		From_wb:in std_logic_vector(31 downto 0);
		in_port:in std_logic_vector(7 downto 0);
		to_idex	:out std_logic_vector(31 downto 0)						
		);
	end component;

  	component execute is
  	port( idex_output: in std_logic_vector(31 downto 0);
        exmem_input: out std_logic_vector(31 downto 0);
        in_flags: in std_logic_vector(4 downto 0);
        out_flags: out std_logic_vector(4 downto 0)
        );
	end component;
	component Memory_Access  is
	port (
		clk : in std_logic;
		Mem_In: in std_logic_vector(31 downto 0);
		Mem_Out:out std_logic_vector(31 downto 0)
		);
	end component;
	component Write_Back  is
	port (
		clk : in std_logic;
		WB_In: in std_logic_vector(31 downto 0);
		WB_Out:out std_logic_vector(31 downto 0);
		out_port:out std_logic_vector(7 downto 0)
		);
	end component;
signal cin,W,R,sp_from_cu,sp_from_wb,LS,notclk,sp_out ,MA,NOP,ifid_enable,Done:std_logic;
  signal Rs1,Rs2,Rd_from_cu,Rd_from_wb	  :std_logic_vector(1 downto 0);
  signal opr,CF,FLAGS_IN,FLAGS_OUT		  :std_logic_vector(3 downto 0);
  signal Datain,new_stack_value,old_stack_value,S1,S2,ALSU_OUT,result_out,sp_data_out,PC_In,PC_Out :std_logic_vector(7 downto 0);
  signal ifid_input,ifid_output :std_logic_vector(15 downto 0);
  signal idex_input,idex_output, exmem_input,exmem_output,memwb_input,memwb_output,WB_Out :std_logic_vector(40 downto 0);
  
  begin
  
  notclk<=not clk;
	ifid_enable<=not NOP;
  FLAG_REG_MODULE:my_nreg generic map(4) port map(clk,rst,'1',FLAGS_IN,FLAGS_OUT);
	------------------------------------FETCH----------------------------------------------
  PC_REG_MODULE:my_nreg generic map(8) port map(clk,rst,'1',PC_In,PC_Out);
	Fetch_MODULE:fetch port map(clk,R,PC_In,ifid_input);
	IFID_REG_MODULE:my_nreg generic map(16) port map(clk, rst, ifid_enable, ifid_input, ifid_output);
  --  8 pc & 8 instrucion  
  
  ------------------------------------DECODE----------------------------------------------

  Decode_MODULE:decode port map(ifid_output,WB_Out,in_port,idex_input);

  IDEX_REG_MODULE:my_nreg generic map(40) port map(clk, rst, '1', idex_input, idex_output);
  
  ------------------------------------EXECUTE----------------------------------------------
  EXECUTE_MODULE:execute port map(idex_output,exmem_input,FLAGS_OUT,FLAGS_IN);
  
  EXMEM_REG_MODULE:my_nreg generic map(40) port map(clk, rst, '1', exmem_input, exmem_output);
  
  ------------------------------------MEMORY ACCESS----------------------------------------------
  MEMORY_ACCESS_MODULE:Memory_Access port map(NOP,clk,exmem_output,memwb_input);

  MEMWB_REG_MODULE:my_nreg generic map(40) port map(clk, rst, '1', memwb_input, memwb_output);
  
	------------------------------------WRITE BACK----------------------------------------------
	WRITE_BACK_MODULE:Write_Back port map(clk,memwb_output,WB_Out,out_port);
  

end cpu_arch;
