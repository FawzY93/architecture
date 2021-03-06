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
sim:/cpu/ifid_input \
sim:/cpu/ifid_output \
sim:/cpu/idex_input \
sim:/cpu/idex_output \
sim:/cpu/exmem_input \
sim:/cpu/exmem_output \
sim:/cpu/memwb_input \
sim:/cpu/memwb_output \
sim:/cpu/WB_Out

add wave -position 9  sim:/cpu/Decode_MODULE/Reg_file_MODUL/r00
add wave -position 10  sim:/cpu/Decode_MODULE/Reg_file_MODUL/r11
add wave -position 11  sim:/cpu/Decode_MODULE/Reg_file_MODUL/r22
add wave -position 12  sim:/cpu/Decode_MODULE/Reg_file_MODUL/r33


mem load -i {work/testcases v2/BFormat-Branch.mem} -filltype value -filldata inst_mem -fillradix symbolic -skip 0 /cpu/Fetch_MODULE/ram

###start
force -freeze sim:/cpu/rst 1 0
force -freeze sim:/cpu/clk 1 0, 0 {50 ps} -r 100
run
force -freeze sim:/cpu/in_port 00001111 0
force -freeze sim:/cpu/rst 0 0
run
run
run
force -freeze sim:/cpu/in_port 00011110 0
run
force -freeze sim:/cpu/in_port 01001011 0
run
force -freeze sim:/cpu/in_port 00000101 0
run


