Library ieee;
use ieee.std_logic_1164.all;
entity cpu is
  port( clk,rst :in std_logic
        );
end cpu;

architecture cpu_arch of cpu is
  component my_nreg is
    Generic ( n : integer);
    port( Clk,Rst,ENA : in std_logic;
    d : in std_logic_vector(n-1 downto 0);
    q : out std_logic_vector(n-1 downto 0));
  end component;

  signal ifid_input,ifid_output :std_logic_vector(32 downto 0);
  signal idie_input,idie_output, iema_input,iema_output :std_logic_vector(32 downto 0);
  begin
  -- IF/ID register
  --  8 pc & 8 instrucion 
  IFID_REG_MODULE: generic map(16) port map(clk, rst, '1', ifid_input, ifid_output);

  -- 1LS & 2rd & 1MA & 1cin & 4change_flags & 4oper & 8s2 & 8s1
  IDIE_REG_MODULE: generic map(16) port map(clk, rst, '1', idie_input, idie_output);
  
  -- 1LS & 2rd & 1MA & 2rd & 8s2 & 8result
  IEMA_REG_MODULE: generic map(16) port map(clk, rst, '1', iema_input, iema_output);


  IFID_REG_MODULE: generic map(16) port map(clk, rst, '1', ifid_input, ifid_output);
end cpu_arch;
