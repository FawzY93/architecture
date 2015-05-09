Library ieee;
use ieee.std_logic_1164.all;
entity alu_map is
  port( opcode :in std_logic_vector(3 downto 0);
        -- the actual content of them (not just the indicies)
        s1,s2,sp,in_port :in std_logic_vector(7 downto 0);
        -- the index of ra
        ra :in std_logic_vector(1 downto 0) ;
        -- return calculate ALU parameter
        a,b :out std_logic_vector(7 downto 0);
        cin :out std_logic;
        oper,change_flags:out std_logic_vector(3 downto 0)
        );
end alu_map;

architecture alu_map_arch of alu_map is
  component ALSU is 
    port(a1,a2 :in std_logic_vector(7 downto 0);
     s :in std_logic_vector(3 downto 0);
     Cin :in std_logic;
     outt :out std_logic_vector(7 downto 0);
     flags:out std_logic_vector(3 downto 0) --(0) OV ,(1) C ,(2) Z ,(3) N
     );
  end component;

  signal one,zero,ff,fs1,fs2:std_logic_vector(7 downto 0);
  begin
    -- intitaization
    one <="00000001";
    zero <= "00000000";
    ff <= "11111111";
    a <= fs1;
    b <= fs2;
    -- note at memory operation the alu should calculate the address and there is
    -- another input tell us the location
    
    -- define the first source
    fs1 <= zero when opcode = "0000"
        else s2 when opcode = "0001"
        else s1 when opcode = "0010"
        else s1 when opcode = "0011"
        else s1 when opcode = "0100"
        else s1 when opcode = "0101"
        else s2 when opcode = "0110"
        else sp when opcode = "0111" and ra(1) = '0'  --push and pop
        else s2 when opcode = "0111" and ra = "10"   -- out.port
        else in_port when opcode = "0111" and ra = "11" -- in_port
        else s2 when opcode = "1000" and ra = "00" --not
        else not s2 when opcode = "1000" and ra = "01" --negative = not + 1
        else s2 when opcode = "1000" and ra = "10"  
        else s2 when opcode = "1000" and ra = "11"
        else s1;

    -- define second source
    fs2 <= zero when opcode = "0000"
        else zero when opcode = "0001"
        else s2 when opcode = "0010"
        else s2 when opcode = "0011"
        else s2 when opcode = "0100"
        else s2 when opcode = "0101"
        else zero when opcode = "0110"
        else s2 when opcode = "0111"  --one operand operation
        else zero when opcode = "1000" --one operand operation
        else s2;

    -- define cin
    cin <= '0' when opcode = "0000"
        else '0' when opcode = "0001"
        else '0' when opcode = "0010"
        else '1' when opcode = "0011" -- A - B
        else '0' when opcode = "0100"
        else '0' when opcode = "0101"
        else '0' when opcode = "0110"
        else '0' when opcode = "0111" and ra = "00"  --push
        else '1' when opcode = "0111" and ra = "01"  --pop
        else '0' when opcode = "0111" and ra(1) = '1'   -- in_port and out.port
        else '0' when opcode = "1000" and ra = "00" --not
        else '1' when opcode = "1000" and ra = "01" --negative = not + 1
        else '1' when opcode = "1000" and ra = "10"  --inc
        else '0' when opcode = "1000" and ra = "11"  --dec
        else '0' when opcode(3 downto 2) = "11"  -- LDM LDD STD LDI STI
        else '0';

    -- define the operation
    oper <= "1111" when opcode = "0000"
        else "0000" when opcode = "0001"
        else "0001" when opcode = "0010"
        else "0010" when opcode = "0011" -- A - B
        else "0100" when opcode = "0100"
        else "0101" when opcode = "0101"
        else "1110" when opcode = "0110" and ra = "00"  --rotate left WC
        else "1010" when opcode = "0110" and ra = "01"  --rotate right WC
        else "1001" when opcode = "0110" and ra = "10"  --set carry
        else "1000" when opcode = "0110" and ra = "11"  --clear carry
        else "0000" when opcode = "0111" and ra = "00"  --push
        else "0000" when opcode = "0111" and ra = "01"  --pop
        else "0000" when opcode = "0111" and ra(1) = '1'   -- in_port and out.port -- need to be change
        else "0111" when opcode = "1000" and ra = "00" --not
        else "0000" when opcode = "1000" and ra = "01" --negative = not + 1
        else "0000" when opcode = "1000" and ra = "10"  --inc
        else "0011" when opcode = "1000" and ra = "11"  --dec
        else "0000" when opcode(3 downto 2) = "11"                -- LDM LDD STD LDI STI
         else "1111";


    -- save if this operation change in the flags or not
                   --VCZN
    change_flags <= "0000" when opcode = "0000"
            else  "0000" when opcode = "0001"
            else  "1111" when opcode = "0010"
            else  "1111" when opcode = "0011"
            else  "1100" when opcode = "0100"
            else  "1100" when opcode = "0101"
            else  "0010" when opcode = "0110" and ra(1) = '0'
            else  "0000" when opcode = "0111"
            else  "1100" when opcode = "1000" and ra(1) = '0'
            else  "1111" when opcode = "1000" and ra(1) = '1'
            else  "0000";

end alu_map_arch;
