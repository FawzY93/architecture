library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


Entity Reg_file  is
port (
   clk,rst   : in std_logic;
   R    : in std_logic;
   Rs1,Rs2 :in std_logic_vector(1 downto 0);
   S1,S2,stack_value     :out std_logic_vector (7 downto 0);
   From_wb:in std_logic_vector(40 downto 0)
   );
end Reg_file;



architecture Reg_Arch of Reg_file is
   signal r00,r11,r22,r33,r33_temp, R3_in,Datain,new_stack_value,inport_in :std_logic_vector(7 downto 0) ;
   signal Rd:std_logic_vector(1 downto 0); 
   signal R0_en,R1_en,R2_en,R3_en,W,sp :std_logic; --,W,Rd_from_wb,Datain,sp_from_wb,new_stack_value
   
component my_nreg is
Generic ( n : integer := 8);
port( Clk,Rst,ENA : in std_logic;
d : in std_logic_vector(n-1 downto 0);
q : out std_logic_vector(n-1 downto 0));
end component;
   begin 
   -- From_Wb
  -- W,RD_from_wb,sp_from_wb,new_stack_value,Datain 
   Datain<=From_wb(7 downto 0);
   new_stack_value<=From_wb(15 downto 8);
   sp<=From_wb(16);
   Rd<=From_wb(18 downto 17);
   W<=From_wb(19);

   --------------------------------------------------
   R0_en <= '1' when Rd="00" and W='1' 
   else '0';
   R1_en <= '1' when Rd="01" and W='1'
   else '0';
   R2_en <= '1' when Rd="10" and W='1' 
   else '0';
   R3_en <= '1' when (Rd="11"  and W='1') or sp='1' or Rst='1' 
   else '0';
   
   R3_in<= (others=>'1') when Rst='1'
   else Datain when Rd="11" 
   else new_stack_value; 
   
   R0: my_nreg port map (clk,Rst,R0_en,Datain,r00);
   R1: my_nreg port map (clk,Rst,R1_en,Datain,r11);
   R2: my_nreg port map (clk,Rst,R2_en,Datain,r22);
   R3: my_nreg port map (clk,'0',R3_en,R3_in,r33_temp);
r33<=(others=>'1') when Rst='1'
else r33_temp;
S1<= r00 when Rs1="00" and R='1'
else r11 when Rs1="01" and R='1'
else r22 when Rs1="10" and R='1'
else r33 when Rs1="11" and R='1'
else "00000000";

S2<=r00 when Rs2="00" and R='1' 
else r11 when Rs2="01" and R='1'
else r22 when Rs2="10" and R='1'
else r33 when Rs2="11" and R='1'
else "00000000";

stack_value<=r33;
   
   
end architecture Reg_Arch;
