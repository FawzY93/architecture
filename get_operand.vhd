Library ieee;
use ieee.std_logic_1164.all;
entity get_operand is
  port(
        From_Fetch :in std_logic_vector(31 downto 0);
        From_wb:in std_logic_vector(40 downto 0);
        Forward_from_execute:in std_logic_vector(31 downto 0);
        Forward_From_MA:in std_logic_vector(31 downto 0);
        reg_s1, reg_s2, stack_reg_value, ea_imm:in std_logic_vector(7 downto 0);
        S1, S2, stack_value:out std_logic_vector(7 downto 0);
        flags_in: in std_logic_vector(3 downto 0);
         sp:in std_logic
        );
end get_operand;

architecture get_operand_arch of get_operand is
  signal Rs1, Rs2: std_logic_vector(1 downto 0);
  signal opcode: std_logic_vector(3 downto 0);
  signal push_oper, save_flags_pass: std_logic;
  begin
    Rs2<=From_Fetch(1 downto 0);
    Rs1<=From_Fetch(3 downto 2);
    opcode <= From_Fetch(7 downto 4);
    push_oper <= '1' when opcode = "0111" and rs1 = "00"
    else '0';
      
    save_flags_pass <= From_Fetch(17);

      -- from excute
      S1 <= Forward_from_execute(7 downto 0) when Forward_from_execute(27 downto 26) = Rs1 and Forward_from_execute(31) = '1' and opcode /="1100"
      --from MA and it's MA operation
      else Forward_From_MA(7 downto 0) when Forward_From_MA(27 downto 26) = Rs1 and Forward_From_MA(31) = '1' and Forward_From_MA(25) = '1' and opcode /="1100"
      -- from MA and it's NOT Ma operation 
      else Forward_From_MA(15 downto 8) when Forward_From_MA(27 downto 26) = Rs1 and Forward_From_MA(31) = '1' and Forward_From_MA(25) = '0' and opcode /="1100"
      -- from WA 
      else From_wb(7 downto 0) when From_wb(27 downto 26) = Rs1 and From_wb(31) = '1' and opcode /="1100"
      --LDM LDD STD
      else ea_imm when opcode ="1100"
      --from register file      
      else reg_s1;
        
      
    S2 <= "0000"&flags_in when push_oper = '1' and save_flags_pass = '1' -- at interupt

      else Forward_from_execute(7 downto 0) when Forward_from_execute(27 downto 26) = Rs2 and Forward_from_execute(31) = '1'
      --from MA and  it's MA operation
      else Forward_From_MA(7 downto 0) when Forward_From_MA(27 downto 26) = Rs2 and Forward_From_MA(31) = '1' and Forward_From_MA(25) = '1'
      -- from MA and it's NOT Ma operation 
      else Forward_From_MA(15 downto 8) when Forward_From_MA(27 downto 26) = Rs2 and Forward_From_MA(31) = '1' and Forward_From_MA(25) = '0'
      -- from WA 
      else From_wb(7 downto 0) when From_wb(27 downto 26) = Rs2 and From_wb(31) = '1'
      --from register file
      else reg_s2;
    
      --sp equal to sp at MA when sp_flag at Ma  = 1
    stack_value <=Forward_from_execute(7 downto 0) when Forward_from_execute(28)='1' and Forward_from_execute(29)='1' 
              else  Forward_From_MA(15 downto 8) when Forward_From_MA(28) = '1'                                
              -- sp equal wb when ot's sp_flag = 1
              else From_wb(15 downto 8) when From_wb(28) = '1'
              else stack_reg_value;

  -----------------forward from execute got 1WB(31),1 NOP(30),2 rd(27-26) , 1 MA(25) ,8 result(7-0)
  -----------------forward from MA got 1WB(31),1 NOP(30),2 RD(27-26),1 MA(25),1 sp(16), ALu or sp(15-8),result(7-0)
  -----------------forward from wb(From_wb) got 1WB(31),1 NOP(30),2 RD(27-26),1 sp(16), ALu or sp(15-8),result(7-0)

end get_operand_arch;
