Library ieee;
use ieee.std_logic_1164.all;
entity decode is
	port(
		From_Fetch :in std_logic_vector(15 downto 0);
		From_wb:in std_logic_vector(40 downto 0);
		in_port:in std_logic_vector(7 downto 0);
		to_idex	:out std_logic_vector(40 downto 0)						
		);
end decode;

architecture decode_arch of decode is
component cu is
 	port( rst :in std_logic;
    s1,s2,in_port,sp: in std_logic_vector(7 downto 0);
	ifid_output: in std_logic_vector(15 downto 0);
    idex_input:out std_logic_vector(40 downto 0)
	);
end component;

component Reg_file  is
	port (
   clk,rst   : in std_logic;
   R    : in std_logic;
   Rs1,Rs2 :in std_logic_vector(1 downto 0);
   S1,S2,stack_value     :out std_logic_vector (7 downto 0);
   From_wb:in std_logic_vector(40 downto 0);
   inport_out,outport_out:std_logic_vector(7 downto 0)
   );
	end component;
signal S1,S2,in_port,stack_value,inport_out,outport_out: std_logic_vector(7 downto 0);
signal Rs1,Rs2	: std_logic_vector(1 downto 0);
begin
 Rs2<=From_Fetch(1 downto 0);
 Rs1<=From_Fetch(3 downto 2);

  CU_MODUL		 :cu port map(rst,S1,S2,in_port,stack_value,From_Fetch,to_idex);
  Reg_file_MODUL :Reg_file port map(notclk,rst,'1',Rs1,Rs2,S1,S2,stack_value,From_wb,inport_out,outport_out);

end decode_arch;

		-- Datain,new_stack_value,sp_from_wb, RD_from_wb,W
  --1NOP & 1LS & 1sp & 2rd & 1MA & 1cin &4change_flags & 4oper & 8s2 & 8s1
	--idex_input(7 downto 0)<=S1;
 -- idex_input(15 downto 8)<=S2;
 -- idex_input(19 downto 16)<=opr;
 -- idex_input(23 downto 20)<=CF;
 -- idex_input(24)<=cin;
 -- idex_input(25)<=MA;
 -- idex_input(27 downto 26)<=Rd_from_cu;
 -- idex_input(28)<=sp;
 -- idex_input(29)<=LS;
	--idex_input(30)<=NOP;
