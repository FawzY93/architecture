
Library ieee;
use ieee.std_logic_1164.all;
entity execute is
  port( idex_output: in std_logic_vector(40 downto 0);
        exmem_input: out std_logic_vector(40 downto 0);
        in_flags: in std_logic_vector(3 downto 0);
        out_flags: out std_logic_vector(3 downto 0);
        Forward_from_execute:out std_logic_vector(31 downto 0);
        PC_loader_ex :out std_logic;
		mem_flags : in std_logic_vector(4 downto 0)
		--
        );
end execute;

architecture execute_arch of execute is
  component ALSU is 
    port(a1,a2 :in std_logic_vector(7 downto 0);
     s :in std_logic_vector(3 downto 0);
     Cin :in std_logic;
     in_flags : in std_logic_vector(3 downto 0);
     outt :out std_logic_vector(7 downto 0);
     flags:out std_logic_vector(3 downto 0) --(0) OV ,(1) C ,(2) Z ,(3) N
	 
     );
  end component;

  signal oper,change_flags,alu_flags : std_logic_vector(3 downto 0);
  signal cin, MA ,sp , LS,NOP: std_logic;
  signal result, s2, s1 : std_logic_vector(7 downto 0);
  signal Rd: std_logic_vector(1 downto 0);
  signal temp_flags :std_logic_vector(3 downto 0);
  begin
	  -- I/P
	  --1no_op & 1LS & 1sp & 2rd & 1MA & 1cin &4change_flags & 4oper & 8s2 & 8s1
	s1 <= idex_output(7 downto 0);
  s2 <= idex_output(15 downto 8);
  oper <= idex_output(19 downto 16);
  change_flags <= idex_output(23 downto 20);
  cin <= idex_output(24);
  MA <=idex_output(25);
  Rd <= idex_output(27 downto 26);
  sp <= idex_output(28);
  LS <= idex_output(29);
  NOP<= idex_output(30);
  PC_loader_ex <= idex_output(33);
	-- O/P
	--1no_op & 1LS & 1sp & 2rd & 1MA& 9 bits non use  & 8s2 & 8result
  exmem_input(7 downto 0)<= result;
  exmem_input(15 downto 8)<=idex_output(15 downto 8);
  ------------------------------
  exmem_input(24 downto 16)<=(others=>'0');
  ------------------------------

  -- prefere to pass the values in same postion
  exmem_input(25)<= idex_output(25);
  exmem_input(27 downto 26)<= idex_output(27 downto 26);
  exmem_input(28)<= idex_output(28);
  exmem_input(29)<= idex_output(29);
  exmem_input(30)<= idex_output(30);
  exmem_input(31)<= idex_output(31);
  exmem_input(32)<= idex_output(32);
  exmem_input(33)<= idex_output(33);
  -----------------------------------------------------------------
  exmem_input(40 downto 34)<=idex_output(40 downto 34);
  --------------------------------------------------------
	Forward_from_execute(7 downto 0)<=result;
  Forward_from_execute(31 downto 8)<=idex_output(31 downto 8);
  -------------------------------------------------------------------
	
  ALSU_module: ALSU port map(s1,s2,oper,cin,in_flags, result,alu_flags);

  -------------------------------------------------------------------

  temp_flags(0) <= alu_flags(0) when change_flags(0) = '1'
    else in_flags(0);

  -- set carry and clear carry instruction will be in 100x without any write back
  temp_flags(1) <= '1' when oper = "1001"
    else '0' when oper = "1000"
    else alu_flags(1) when change_flags(1) = '1'
    else in_flags(1);

  temp_flags(2) <= alu_flags(2) when change_flags(2) = '1'
    else in_flags(2);
  temp_flags(3) <= alu_flags(3) when change_flags(3) = '1'
    else in_flags(3);
	---------------
	
	out_flags<=mem_flags(3 downto 0) when mem_flags(4)='1'
	else temp_flags;
	
	

end execute_arch;
