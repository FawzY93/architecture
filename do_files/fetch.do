vsim work.fetch
# vsim work.fetch 
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.fetch(f_arch)
add wave -position insertpoint  \
sim:/fetch/clk \
sim:/fetch/R \
sim:/fetch/PC \
sim:/fetch/Inst_pc \
sim:/fetch/Done \
sim:/fetch/ram \
sim:/fetch/dataout

force -freeze sim:/fetch/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/fetch/R 1 0
force -freeze sim:/fetch/PC 00000000 0
mem load -i {/home/ahmed/architecture/work/testcases v2/AFormat-WithoutPushPop.mem} -filltype value -filldata fetch -fillradix symbolic -skip 0 /fetch/ram

force -freeze sim:/fetch/PC 00000000 0
run

force -freeze sim:/fetch/PC 00000001 0
run

force -freeze sim:/fetch/PC 00000010 0
run

force -freeze sim:/fetch/PC 00000011 0
run

force -freeze sim:/fetch/PC 00000100 0
run
