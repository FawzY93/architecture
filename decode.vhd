Library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity decode is
	port(
    notclk,rst: in std_logic;
		From_Fetch :in std_logic_vector(15 downto 0);
		From_wb:in std_logic_vector(40 downto 0);
		in_port:in std_logic_vector(7 downto 0);
		to_idex	:out std_logic_vector(40 downto 0);
    PC_In :out std_logic_vector(7 downto 0)
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
   From_wb:in std_logic_vector(40 downto 0)
   );
	end component;
signal S1,S2,stack_value,inport_out,outport_out: std_logic_vector(7 downto 0);
signal Rs1,Rs2	: std_logic_vector(1 downto 0);
begin
 Rs2<=From_Fetch(1 downto 0);
 Rs1<=From_Fetch(3 downto 2);
  CU_MODUL: cu port map(rst,S1,S2,in_port,stack_value,From_Fetch,to_idex);
  Reg_file_MODUL :Reg_file port map(notclk,rst,'1',Rs1,Rs2,S1,S2,stack_value,From_wb);

  PC_In <= From_Fetch(7 downto 0) when From_Fetch(15 downto 8) = "00000000"
    else From_Fetch(15 downto 8) + 1;
end decode_arch;
