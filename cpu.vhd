Library ieee;
use ieee.std_logic_1164.all;
entity cpu is
  port( clk,rst :in std_logic;
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
    notclk,rst: in std_logic;
		From_Fetch :in std_logic_vector(15 downto 0);
		From_wb:in std_logic_vector(40 downto 0);
		in_port:in std_logic_vector(7 downto 0);
		to_idex	:out std_logic_vector(40 downto 0);
    PC_In: out std_logic_vector(7 downto 0)

		);
	end component;

  	component execute is
  	port( idex_output: in std_logic_vector(40 downto 0);
        exmem_input: out std_logic_vector(40 downto 0);
        in_flags: in std_logic_vector(3 downto 0);
        out_flags: out std_logic_vector(3 downto 0)
        );
	end component;
	component Memory_Access  is
	port (
		clk : in std_logic;
		Mem_In: in std_logic_vector(40 downto 0);
		Mem_Out:out std_logic_vector(40 downto 0)
		);
	end component;
	component Write_Back  is
	port (
		clk : in std_logic;

		WB_In: in std_logic_vector(40 downto 0);
		WB_Out:out std_logic_vector(40 downto 0);
		out_port:out std_logic_vector(7 downto 0)
		);
	end component;
signal notclk:std_logic;
  signal FLAGS_IN,FLAGS_OUT		  :std_logic_vector(3 downto 0);
  signal PC_In,PC_Out,PC_In_Fetch :std_logic_vector(7 downto 0);
  signal ifid_input,ifid_output :std_logic_vector(15 downto 0);
  signal ifid_input_temp,ifid_output_temp :std_logic_vector(15 downto 0);
  signal idex_input,idex_output, exmem_input,exmem_output,memwb_input,memwb_output,WB_Out :std_logic_vector(40 downto 0);
  signal idex_input_temp,idex_output_temp, exmem_input_temp,exmem_output_temp,memwb_input_temp,memwb_output_temp,WB_Out_temp :std_logic_vector(40 downto 0);
  begin
  
  notclk<=not clk;
  FLAG_REG_MODULE:my_nreg generic map(4) port map(clk,rst,'1',FLAGS_IN,FLAGS_OUT);
	------------------------------------FETCH----------------------------------------------
  PC_REG_MODULE:my_nreg generic map(8) port map(clk,rst,'1',PC_In,PC_Out);

  PC_In_Fetch <= "00000000" when rst = '1'
    else PC_In;

	Fetch_MODULE:fetch port map(clk,'1',PC_In_Fetch,ifid_input_temp);
	ifid_input<=(others=>'0')when rst='1'
	else ifid_input_temp;
	IFID_REG_MODULE:my_nreg generic map(16) port map(clk, rst, '1', ifid_input, ifid_output_temp);
  --  8 pc & 8 instrucion  
  
  ------------------------------------DECODE----------------------------------------------
  ifid_output<=(others=>'0')when rst='1'
	else ifid_output_temp;
  Decode_MODULE:decode port map(notclk,rst,ifid_output,WB_Out,in_port,idex_input_temp, PC_In);
  idex_input<=(others=>'0')when rst='1'
	else idex_input_temp;

  IDEX_REG_MODULE:my_nreg generic map(41) port map(clk, rst, '1', idex_input, idex_output_temp);
  idex_output<=(others=>'0')when rst='1'
	else idex_output_temp;
  ------------------------------------EXECUTE----------------------------------------------
  EXECUTE_MODULE:execute port map(idex_output,exmem_input_temp,FLAGS_OUT,FLAGS_IN);
  exmem_input<=(others=>'0')when rst='1'
	else exmem_input_temp;
  EXMEM_REG_MODULE:my_nreg generic map(41) port map(clk, rst, '1', exmem_input, exmem_output_temp);
  exmem_output<=(others=>'0')when rst='1'
	else exmem_output_temp;
  ------------------------------------MEMORY ACCESS----------------------------------------------
  MEMORY_ACCESS_MODULE:Memory_Access port map(clk,exmem_output,memwb_input_temp);
  memwb_input<=(others=>'0')when rst='1'
	else memwb_input_temp;
  MEMWB_REG_MODULE:my_nreg generic map(41) port map(clk, rst, '1', memwb_input, memwb_output_temp);
  memwb_output<=(others=>'0')when rst='1'
	else memwb_output_temp;
	------------------------------------WRITE BACK----------------------------------------------
	WRITE_BACK_MODULE:Write_Back port map(clk,memwb_output,WB_Out_temp,out_port);
  	WB_Out<=(others=>'0')when rst='1'
	else WB_Out_temp;

end cpu_arch;
