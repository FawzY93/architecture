library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


Entity Write_Back  is
port (
clk : in std_logic;
WB_In: in std_logic_vector(40 downto 0);
WB_Out:out std_logic_vector(40 downto 0);
out_port:out std_logic_vector(7 downto 0);
Memory_Flags: out std_logic_vector(4 downto 0)
);
end Write_Back;



architecture WB_Arch of Write_Back is
signal Rd:std_logic_vector(1 downto 0);
signal Data: std_logic_vector(7 downto 0);
signal new_stack_value: std_logic_vector(7 downto 0);
signal W,sp,MA:std_logic;
signal Mem_Flags :std_logic_vector(3 downto 0);

begin
 -- I/P
 -- 1NOP & 1LS & 1MA & 2rd & 1sp &8ALSU_OUT or sp value& 8result_out

MA <= WB_In(25);
Data<=WB_In(7 downto 0) when MA='1'
else WB_In(15 downto 8);
new_stack_value<=WB_In(15 downto 8);
sp<=WB_In(28);
Rd<=WB_In(27 downto 26);
W <= WB_In(31)  ;
Mem_Flags<= WB_In(3 downto 0) ; -- save flags
-- O/P
--  W,RD_from_wb,sp_from_wb,new_stack_value,Datain 
WB_Out(7 downto 0)<= Data;
WB_Out(15 downto 8)<= new_stack_value;
WB_Out(28)<=sp;
WB_Out(27 downto 26)<=Rd;
WB_Out(30)<=WB_In(30);
WB_Out(31)<=W;
Memory_Flags<=WB_In(34)&Mem_Flags;
out_port<=WB_In(15 downto 8) when  WB_In(32)='1'
else "00000000";

WB_Out(16) <= WB_In(16);
WB_Out(25) <= WB_In(25);
WB_Out(29) <= WB_In(29);
WB_Out(32) <= WB_In(32);

WB_Out(33) <= WB_In(33);

WB_Out(24 downto 17)<=(others=>'0');
WB_Out(40 downto 34)<=WB_In(40 downto 34);
end WB_Arch;
