vsim work.cu
# vsim work.cu 
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.cu(cu_arch)
# Loading work.alu_map(alu_map_arch)
add wave -position insertpoint  \
sim:/cu/rst \
sim:/cu/s1 \
sim:/cu/s2 \
sim:/cu/in_port \
sim:/cu/sp \
sim:/cu/ifid_output \
sim:/cu/idex_input \
sim:/cu/a \
sim:/cu/b \
sim:/cu/opcode \
sim:/cu/oper \
sim:/cu/cin \
sim:/cu/change_flags \
sim:/cu/ra \
sim:/cu/rb \
sim:/cu/MA \
sim:/cu/LS \
sim:/cu/WA \
sim:/cu/out_port_en \
sim:/cu/sp_flag \
sim:/cu/NOP \
sim:/cu/carry_oper

#starting
force -freeze sim:/cu/s1 00001111 0
force -freeze sim:/cu/s2 00000001 0
force -freeze sim:/cu/in_port 01010101 0
force -freeze sim:/cu/sp 00000100 0
force -freeze sim:/cu/ifid_output 0000000000000000 0

run 
# no operation oper = 1111

force -freeze sim:/cu/ifid_output 0000000000010000 0

# mov oper=0000 cin=0
run 

force -freeze sim:/cu/ifid_output 0000000000100000 0

# add oper = 0001 cin=0
run 

force -freeze sim:/cu/ifid_output 0000000000110000 0

run 
# sub operation oper = 0010 cin=1

force -freeze sim:/cu/ifid_output 0000000001000000 0

# add operation oper = 0100
run 

force -freeze sim:/cu/ifid_output 0000000001010000 0
# OR operation oper = 0101
run

###############################
force -freeze sim:/cu/ifid_output 0000000001100000 0
# Rotate L operation oper = 1110
run 

force -freeze sim:/cu/ifid_output 0000000001100100 0
# Rotate R operation oper = 1010
run 

force -freeze sim:/cu/ifid_output 0000000001101000 0
# Set c operation oper = 0000
run 

force -freeze sim:/cu/ifid_output 0000000001101100 0
# Clear c operation oper = 0000
run 
#############################

force -freeze sim:/cu/ifid_output 0000000001110000 0
# push operation oper = 0000
run 

force -freeze sim:/cu/ifid_output 0000000001110100 0
# pop operation oper = 0011 cin=0
run 

force -freeze sim:/cu/ifid_output 0000000001111000 0
# out operation oper = 0000 cin = 0
run 

force -freeze sim:/cu/ifid_output 0000000001111100 0
# in operation oper = 0000 cin = 0
run 

##########################

force -freeze sim:/cu/ifid_output 0000000010000000 0
# not operation oper = 0111 cin = x
run 

force -freeze sim:/cu/ifid_output 0000000010000100 0
# negative operation oper = 0000 cin = 1
run 

force -freeze sim:/cu/ifid_output 0000000010001000 0
# Inc operation oper = 0000 cin = 1
run 

force -freeze sim:/cu/ifid_output 0000000010001100 0
# Dec operation oper = 0011 cin = 0
run 
