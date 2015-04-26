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
	inst :in std_logic_vector(7 downto 0);
	W,R  :in std_logic;  -- read , write
	sp   :in std_logic; -- 1 if load or store
    D    :in std_logic_vector(7 downto 0);
	Stack:in std_logic_vector(7 downto 0); --new value of the stack pointer
	Rd   :in std_logic -- read from destination of this index  from WB
  );
  end component;
  
	component Reg_file  is
	port (
	clk,Rst   : in std_logic;
	R,W		  : in std_logic;
	Rs1,Rs2,Rd: in std_logic_vector(1 downto 0);
	Datain    : in std_logic_vector(7 downto 0);
	sp		  : in std_logic;
	stack	  : in std_logic_vector(7 downto 0);
	S1,S2     :out std_logic_vector(7 downto 0));
	end component;

  signal ifid_input,ifid_output :std_logic_vector(32 downto 0);
  signal idie_input,idie_output, iema_input,iema_output :std_logic_vector(32 downto 0);
  begin
  -- IF/ID register
  --  8 pc & 8 instrucion 
  IFID_REG_MODULE:my_nreg generic map(32) port map(clk, rst, '1', ifid_input, ifid_output);

  -- 1LS & 2rd & 1MA & 1cin & 4change_flags & 4oper & 8s2 & 8s1
  IDIE_REG_MODULE:my_nreg generic map(32) port map(clk, rst, '1', idie_input, idie_output);
  
  -- 1LS & 2rd & 1MA & 2rd & 8s2 & 8result
  IEMA_REG_MODULE:my_nreg generic map(32) port map(clk, rst, '1', iema_input, iema_output);



end cpu_arch;
