vsim work.cpu
# vsim work.cpu 
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.cpu(cpu_arch)
# Loading work.my_nreg(arch_my_nreg)
# Loading work.my_reg(a_my_reg)
# Loading ieee.numeric_std(body)
# Loading work.fetch(f_arch)
# Loading work.execute(execute_arch)
# Loading work.alsu(arch4)
# Loading work.b(arch1)
# Loading work.c(arch2)
# Loading work.d(arch3)
# Loading work.a(arch10)
# Loading work.my_nadder(a_my_nadder)
# Loading work.my_adder(a_my_adder)
# Loading work.mux4(data_flow)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_signed(body)
# Loading work.memory_access(mem_arch)
# Loading work.data_memory(syncrama)
# Loading work.write_back(wb_arch)
add wave -position insertpoint  \
sim:/cpu/clk \
sim:/cpu/rst \
sim:/cpu/in_port \
sim:/cpu/out_port \
sim:/cpu/notclk \
sim:/cpu/FLAGS_IN \
sim:/cpu/FLAGS_OUT \
sim:/cpu/PC_In \
sim:/cpu/PC_Out \
sim:/cpu/PC_In_Fetch \
sim:/cpu/ifid_input \
sim:/cpu/ifid_output \
sim:/cpu/idex_input \
sim:/cpu/idex_output \
sim:/cpu/exmem_input \
sim:/cpu/exmem_output \
sim:/cpu/memwb_input \
sim:/cpu/memwb_output \
sim:/cpu/WB_Out

add wave -position end  sim:/cpu/Decode_MODULE/Reg_file_MODUL/r00
add wave -position end  sim:/cpu/Decode_MODULE/Reg_file_MODUL/r11
add wave -position end  sim:/cpu/Decode_MODULE/Reg_file_MODUL/r22
add wave -position end  sim:/cpu/Decode_MODULE/Reg_file_MODUL/r33

add wave -position 2  sim:/cpu/in_port
add wave -position 3  sim:/cpu/out_port

mem load -i {work/testcases v2/AFormat-WithoutPushPop.mem} -filltype value -filldata inst_mem -fillradix symbolic -skip 0 /cpu/Fetch_MODULE/ram

mem load -i {work/testcases v2/AFormat-WithoutPushPop.mem} -format mti -filltype value -filldata data_mem -fillradix symbolic -skip 0 /cpu/MEMORY_ACCESS_MODULE/D_mem/ram


###start
force -freeze sim:/cpu/rst 1 0
force -freeze sim:/cpu/clk 1 0, 0 {50 ps} -r 100
run
force -freeze sim:/cpu/in_port 00101101 0
force -freeze sim:/cpu/rst 0 0
run
run
run
force -freeze sim:/cpu/in_port 00000101 0
run
force -freeze sim:/cpu/in_port 01000110 0
run
force -freeze sim:/cpu/in_port 01111110 0
run

