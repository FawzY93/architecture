Library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity decode is
	port(
    notclk,rst: in std_logic;
		From_Fetch :in std_logic_vector(31 downto 0);
		From_wb:in std_logic_vector(40 downto 0);
		in_port:in std_logic_vector(7 downto 0);
		to_idex	:out std_logic_vector(40 downto 0);
    PC_In :out std_logic_vector(7 downto 0);
		Forward_from_execute:in std_logic_vector(31 downto 0);						
		Forward_From_MA:in std_logic_vector(31 downto 0);
		ea_imm : in std_logic_vector(7 downto 0);
    flags_in: in std_logic_vector(3 downto 0);
    From_decode: out std_logic;
    PC_loader_ex , PC_loader_MA: in std_logic;
    save_flags,pop_pc,temp_stall : out std_logic
    );
end decode;

architecture decode_arch of decode is
component cu is
 	port( rst :in std_logic;
    s1,s2,in_port,sp: in std_logic_vector(7 downto 0);
	ifid_output: in std_logic_vector(31 downto 0);
    idex_input:out std_logic_vector(40 downto 0);
    PC_value: in std_logic_vector(7 downto 0);
    restor_flags: in std_logic
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

component get_operand is
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
end component;

component pc_logic is
  port(
    stall: in std_logic;
    From_Fetch :in std_logic_vector(31 downto 0);
    in_flags: in std_logic_vector(3 downto 0);
    S1 ,S2 : in std_logic_vector(7 downto 0);
    PC_In :out std_logic_vector(7 downto 0);
    From_wb:in std_logic_vector(40 downto 0);
    ea_imm:in std_logic_vector(7 downto 0)

  );
end component;

signal idex :std_logic_vector(40 downto 0);
signal S1,S2,stack_value, stack_reg_value, PC_value, inport_out,outport_out,reg_s1, reg_s2, pc_minus_1: std_logic_vector(7 downto 0);
signal Rs1,Rs2	: std_logic_vector(1 downto 0);
signal fetch_final,no_op_fetch: std_logic_vector(31 downto 0);
signal opcode: std_logic_vector(3 downto 0);
signal sp_hazard_in_sources, sources_in_execution_MA, valid_ra, stall, wating_pc_memory : std_logic;
signal jz,jn,jc,jv,jmp, push_pc,restor_flags: std_logic;
begin
  Rs2<=From_Fetch(1 downto 0);
  Rs1<=From_Fetch(3 downto 2);
  opcode <= From_Fetch(7 downto 4);

  -- 1 if the value of ra indicate to a register (two operand operation)
  valid_ra <= '1' when opcode = "0010" or opcode ="0011" or opcode ="0100" or opcode ="0101" or opcode ="1010" or opcode = "1110"
    else '0';    
    to_idex<=idex;
  CU_MODUL: cu port map(rst,S1,S2,in_port,stack_value,fetch_final,idex,PC_value, restor_flags);

  Reg_file_MODUL: Reg_file port map(notclk, rst, '1', Rs1, Rs2, reg_s1, reg_s2, stack_reg_value, From_wb);

    -- forward implement
  GET_OPERAND_MODUL: get_operand port map(From_Fetch, From_wb, Forward_from_execute, Forward_From_MA, reg_s1, reg_s2, stack_reg_value, ea_imm, S1, S2, stack_value,flags_in,idex(28));

  PC_LOGIC_MODULE: pc_logic port map(stall, From_Fetch, flags_in, S1 , S2, PC_In, From_wb,ea_imm);
    --stall if one of my sources in execution and it's MA
  sources_in_execution_MA <= '1' when ((Forward_from_execute(27 downto 26) = Rs2 and From_Fetch(7 downto 3)/="10111") or (Forward_from_execute(27 downto 26) = Rs1 and valid_ra = '1')) and Forward_from_execute(31) = '1' and Forward_from_execute(25) = '1'
    else '0';
    -- stall if push or pop or source(1 or 2) = r3 and sp_flag in excute = 1
  sp_hazard_in_sources <= '1' when(( (Rs2 = "11" and From_Fetch(17)/='1')  or (Rs1 = "11" and valid_ra = '1') or  (opcode = "0111" and Rs1(1) = '0') or (opcode="1011" and Rs1="10")) and (Forward_from_execute(28) = '1'  and  Forward_from_execute(29)='0'))
      else '0';
  wating_pc_memory <= '1' when PC_loader_ex = '1' or PC_loader_MA = '1'
    else '0';
  
  stall <= sp_hazard_in_sources or sources_in_execution_MA or wating_pc_memory or From_Fetch(27);

  From_decode<='1' when opcode="1100"
  else '0';
  pc_minus_1 <= From_Fetch(15 downto 8) - 1;
  no_op_fetch <= "0000000000000000"&pc_minus_1&"00000000";

  fetch_final <=  no_op_fetch when stall = '1' or (jz or jv or jn or jc or jmp) = '1'
    else From_Fetch;

    -- for interupt
    push_pc <= From_Fetch(16);

    -- out signal NOT passed from fetch
    temp_stall <= push_pc;
     save_flags<=From_Fetch(27);
    restor_flags <= From_Fetch(18);
    pop_pc <= restor_flags;

  -- for branching;
  PC_value <= From_Fetch(15 downto 8) +1;
  jz <= '1' when opcode = "1001" and Rs1 = "00" and flags_in(2) = '1'
  else '0';

  jn <= '1' when opcode = "1001" and Rs1 = "01" and flags_in(3) = '1'
  else '0';

  jc <= '1' when opcode = "1001" and Rs1 = "10" and flags_in(1) = '1'
  else '0';

  jv <= '1' when opcode = "1001" and Rs1 = "11" and flags_in(0) = '1'
  else '0';

  jmp <= '1' when opcode = "1011" and Rs1 = "00"
  else '0';

end decode_arch;

