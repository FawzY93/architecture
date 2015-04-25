vsim -gui work.reg_file
# vsim -gui work.reg_file 
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.reg_file(reg_arch)
# Loading work.my_nreg(arch_my_nreg)
# Loading work.my_reg(a_my_reg)
add wave -position insertpoint  \
sim:/reg_file/clk \
sim:/reg_file/Rst \
sim:/reg_file/R \
sim:/reg_file/W \
sim:/reg_file/Rs1 \
sim:/reg_file/Rs2 \
sim:/reg_file/Rd \
sim:/reg_file/Datain \
sim:/reg_file/S1 \
sim:/reg_file/S2 \
sim:/reg_file/r00 \
sim:/reg_file/r11 \
sim:/reg_file/r22 \
sim:/reg_file/r33 \
sim:/reg_file/R0_en \
sim:/reg_file/R1_en \
sim:/reg_file/R2_en \
sim:/reg_file/R3_en
force -freeze sim:/reg_file/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/reg_file/Rst 1 0
run
force -freeze sim:/reg_file/Rst 0 0
force -freeze sim:/reg_file/W 1 0
force -freeze sim:/reg_file/Rd 01 0
force -freeze sim:/reg_file/Datain 10011001 0
run
run
force -freeze sim:/reg_file/R 1 0
force -freeze sim:/reg_file/Rs1 10 0
force -freeze sim:/reg_file/Rs2 00 0
force -freeze sim:/reg_file/Rs2 01 0
run
run