Library ieee;
use ieee.std_logic_1164.all;
entity cu is
  port( rst :in std_logic;
    s1,s2,in_port,sp: in std_logic_vector(7 downto 0);
		ifid_output: in std_logic_vector(15 downto 0);
    idex_input:out std_logic_vector(40 downto 0);
    PC_value: in std_logic_vector(7 downto 0)
		);
end cu;
architecture cu_arch of cu is
  component alu_map is
    port( opcode :in std_logic_vector(3 downto 0);
        -- the actual content of them (not just the indicies)
        s1,s2,sp,in_port :in std_logic_vector(7 downto 0);
        -- the index of ra
        ra :in std_logic_vector(1 downto 0) ;
        -- return calculate ALU parameter
        a,b :out std_logic_vector(7 downto 0);
        cin :out std_logic;
        oper,change_flags:out std_logic_vector(3 downto 0);
        PC_value : in std_logic_vector(7 downto 0)
        );
  end component;

  signal a, b :std_logic_vector(7 downto 0);
  signal opcode, oper, change_flags : std_logic_vector(3 downto 0);
  signal ra,rb : std_logic_vector(1 downto 0);
  signal cin, MA, LS, WB, out_port_en, sp_flag,NOP ,carry_oper, PC_loader: std_logic;
  begin
  opcode <= ifid_output(7 downto 4);
  ra <= ifid_output(3 downto 2);
  rb <= ifid_output(1 downto 0);

  MA <= '1' when (opcode = "0111" and ra(1) = '0' ) or (opcode="1100" and  ra/="00") or (opcode="1101")  or (opcode="1110")  or(opcode = "1011")
    else '0';
  carry_oper <= '1' when opcode = "0110" and ra(1) = '1'
    else '0';

  WB <= '0' when opcode = "0000" or carry_oper = '1' or  (opcode = "0111" and ra = "00") or (opcode = "0111" and ra = "10") or(opcode="1100" and ra(1)='1') or (opcode="1110") or (opcode = "1011") or (opcode = "1001")
    else '1';

  -- out port enable ()to write back init
  out_port_en <= '1' when opcode = "0111" and ra = "10"
    else '0';

  --if there is an operation on sp at PUSH POP
  sp_flag <= '1' when (opcode = "0111" and ra(1) = '0') or (opcode = "1011" and ra = "10") or (opcode = "1011" and ra = "01")
    else '0';

  NOP <= '0';
  LS <= '1' when (opcode = "0111" and ra = "01") or (opcode="1100" and ra(1)='0') or opcode="1101"  or (opcode = "1011" and ra(1) = '1') -- at pop operation, LDM ,LDD , LDI, RET , RTI
    else '0';

    -- at REt and RTI
  PC_loader <= '1' when opcode = "1011" and ra(1) = '1'
    else '0';

  ALU_MAP_MODULE: alu_map port map(opcode, s1, s2, sp, in_port, ra, a,b,cin,oper,change_flags,PC_value);

  idex_input(7 downto 0)<=a;
  idex_input(15 downto 8)<=b;
  idex_input(19 downto 16)<=oper;
  idex_input(23 downto 20)<=change_flags;
  idex_input(24)<=cin;
  idex_input(25)<=MA;
  idex_input(27 downto 26)<= rb when opcode = "0110" or opcode ="0111" or opcode = "1000" or opcode(3 downto 2)="11"
    else ra;
  idex_input(28)<=sp_flag;
  idex_input(29)<=LS;
  idex_input(30)<=NOP;
  idex_input(31) <= WB;
  idex_input(32) <= out_port_en;
  idex_input(33) <= PC_loader;
  idex_input(34) <= '0';
  idex_input(35) <= '0';
  idex_input(36) <= '0';
  idex_input(37) <= '0';
  idex_input(38) <= '0';
  idex_input(39) <= '0';
  idex_input(40) <= '0';

end cu_arch;
