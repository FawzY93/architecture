quit -sim
vsim work.alu_map
# vsim work.alu_map 
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.alu_map(alu_map_arch)
# Loading work.alsu(arch4)
# Loading work.b(arch1)
# Loading work.c(arch2)
# Loading work.d(arch3)
# Loading work.a(arch10)
# Loading work.my_nadder(a_my_nadder)
# Loading work.my_adder(a_my_adder)
# Loading work.mux4(data_flow)

add wave -position insertpoint  \
sim:/alu_map/opcode \
sim:/alu_map/s1 \
sim:/alu_map/s2 \
sim:/alu_map/sp \
sim:/alu_map/in_port \
sim:/alu_map/ra \
sim:/alu_map/result \
sim:/alu_map/FLAGS \
sim:/alu_map/cin \
sim:/alu_map/one \
sim:/alu_map/zero \
sim:/alu_map/ff \
sim:/alu_map/fs1 \
sim:/alu_map/fs2 \
sim:/alu_map/oper \
sim:/alu_map/tmp_flag 

force -freeze sim:/alu_map/opcode 0000 0
force -freeze sim:/alu_map/s1 00000101 0
force -freeze sim:/alu_map/s2 00000010 0
force -freeze sim:/alu_map/sp 11110000 0
force -freeze sim:/alu_map/in_port 00001111 0
force -freeze sim:/alu_map/ra 00 0
run

force -freeze sim:/alu_map/opcode 0001 0
run
#result should be 2

force -freeze sim:/alu_map/opcode 0010 0
run
#result should be 7

force -freeze sim:/alu_map/opcode 0011 0
run 
#result should be 3

force -freeze sim:/alu_map/opcode 0100 0
run 
#result should be 0

force -freeze sim:/alu_map/opcode 0101 0
run 
#result should be 7

force -freeze sim:/alu_map/opcode 0110 0
run 
#result should be 4

force -freeze sim:/alu_map/ra 01 0
run 
#result should be 1

force -freeze sim:/alu_map/ra 10 0
run 
#result should be 0 and carry up

force -freeze sim:/alu_map/ra 11 0
run 
#result should be 0 and carry down

#####################
force -freeze sim:/alu_map/opcode 0111 0
force -freeze sim:/alu_map/ra 00 0
run 
#result should be 11110000 SP

force -freeze sim:/alu_map/ra 01 0
run 
#result should be 11110001 SP

force -freeze sim:/alu_map/ra 10 0
run 
#result should be 2 rb

force -freeze sim:/alu_map/ra 11 0
run 
#result should be 11110000 in_port

#########################
force -freeze sim:/alu_map/opcode 1000 0
force -freeze sim:/alu_map/ra 00 0
run 
#result should be 11111101

force -freeze sim:/alu_map/ra 01 0
run 
#result should be 11111110

force -freeze sim:/alu_map/ra 10 0
run 
#result should be 3

force -freeze sim:/alu_map/ra 11 0
run 
#result should be 1

##### testing the carry flag & zero
force -freeze sim:/alu_map/s1 11111111 0
force -freeze sim:/alu_map/s2 00000001 0
force -freeze sim:/alu_map/opcode 0010 0
run 
#result should be 0 and carry flag & zero flag

force -freeze sim:/alu_map/s1 00000011 0
force -freeze sim:/alu_map/s2 00000101 0
force -freeze sim:/alu_map/opcode 0011 0
run 
# negative flag

