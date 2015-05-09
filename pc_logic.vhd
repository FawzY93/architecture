Library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
entity pc_logic is
  port(
    stall: in std_logic;
    From_Fetch :in std_logic_vector(15 downto 0);
    PC_In :out std_logic_vector(7 downto 0)
  );
end pc_logic;
architecture pc_logic_arch of pc_logic is
  signal fout:std_logic_vector(7 downto 0);
  begin
  PC_In <= From_Fetch(7 downto 0) when From_Fetch(15 downto 8) = "00000000"
    else From_Fetch(15 downto 8) when stall = '1'
    else From_Fetch(15 downto 8) + 1;

end pc_logic_arch;
