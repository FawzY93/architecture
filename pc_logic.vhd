Library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
entity pc_logic is
  port(
    stall: in std_logic;
    From_Fetch :in std_logic_vector(15 downto 0);
    in_flags: in std_logic_vector(3 downto 0);
    S1,S2 : in std_logic_vector(7 downto 0);
    PC_In :out std_logic_vector(7 downto 0);
    From_wb:in std_logic_vector(40 downto 0)
  );
end pc_logic;
architecture pc_logic_arch of pc_logic is
  signal opcode:std_logic_vector(3 downto 0);
  signal jz,jn,jc,jv,jmp, call: std_logic;
  signal Rs1, Rs2 : std_logic_vector(1 downto 0);
  begin

  Rs2<=From_Fetch(1 downto 0);
  Rs1<=From_Fetch(3 downto 2);
  opcode <= From_Fetch(7 downto 4);
  jz <= '1' when opcode = "1001" and Rs1 = "00" and in_flags(2) = '1'
  else '0';

  jn <= '1' when opcode = "1001" and Rs1 = "01" and in_flags(3) = '1'
  else '0';

  jc <= '1' when opcode = "1001" and Rs1 = "10" and in_flags(1) = '1'
  else '0';

  jv <= '1' when opcode = "1001" and Rs1 = "11" and in_flags(0) = '1'
  else '0';

  jmp <= '1' when opcode = "1011" and Rs1 = "00"
  else '0';

  call <= '1' when opcode = "1011" and Rs1 = "01"
  else '0';

  PC_In <= From_Fetch(7 downto 0) when From_Fetch(15 downto 8) = "00000000"
    else From_Fetch(15 downto 8) when stall = '1'
    -- branhing
    else  S2 when (jz or jv or jn or jc or jmp or call) = '1'
    -- at RET and RTI
    else From_wb(7 downto 0) when From_wb(33) = '1'
    -- loop
    else s2 when s1 /= "00000001" and opcode = "1010"
    else From_Fetch(15 downto 8) + 1;

end pc_logic_arch;
