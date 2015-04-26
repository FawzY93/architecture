
Library ieee;
use ieee.std_logic_1164.all;
entity execute is
  port( oper :in std_logic_vector(3 downto 0);
        cin :in std_logic;
        a,b :in std_logic_vector(7 downto 0);
        in_flags :in std_logic_vector(3 downto 0);
        change_flags : in std_logic_vector(3 downto 0);
        result :out std_logic_vector(7 downto 0);
        out_flags:out std_logic_vector(3 downto 0)
        );
end execute;

architecture execute_arch of execute is
  component ALSU is 
    port(a1,a2 :in std_logic_vector(7 downto 0);
     s :in std_logic_vector(3 downto 0);
     Cin :in std_logic;
     outt :out std_logic_vector(7 downto 0);
     flags:out std_logic_vector(3 downto 0) --(0) OV ,(1) C ,(2) Z ,(3) N
     );
  end component;

  signal tmp_flags:std_logic_vector(4 downto 0);

  begin
    ALSU_module: ALSU port map(a,b,oper,cin,result,tmp_flags);
    out_flags(0) <= tmp_flags(0) when change_flags(0) = '1'
      else in_flags(0);

    -- set carry and clear carry instruction will be in 100x without any write back
    out_flags(1) <= '1' when oper = "1001"
      else '0' when oper = "1000"
      else tmp_flags(1) when change_flags(1) = '1'
      else in_flags(1);
    
    out_flags(2) <= tmp_flags(2) when change_flags(2) = '1'
      else in_flags(2);
    out_flags(3) <= tmp_flags(3) when change_flags(3) = '1'
      else in_flags(3);
        
  end execute_arch;
