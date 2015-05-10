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
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_signed(body)
# Loading work.decode(decode_arch)
# Loading work.cu(cu_arch)
# Loading work.alu_map(alu_map_arch)
# Loading work.reg_file(reg_arch)
# Loading work.get_operand(get_operand_arch)
# Loading work.pc_logic(pc_logic_arch)
# Loading work.execute(execute_arch)
# Loading work.alsu(arch4)
# Loading work.b(arch1)
# Loading work.c(arch2)
# Loading work.d(arch3)
# Loading work.a(arch10)
# Loading work.my_nadder(a_my_nadder)
# Loading work.my_adder(a_my_adder)
# Loading work.mux4(data_flow)
# Loading work.memory_access(mem_arch)
# Loading work.data_memory(syncrama)
# Loading work.write_back(wb_arch)
add wave -position end  sim:/cpu/clk
add wave -position end  sim:/cpu/rst
add wave -position end  sim:/cpu/Intr
add wave -position end  sim:/cpu/in_port
add wave -position end  sim:/cpu/out_port
add wave -position end  sim:/cpu/PC_loader_ex
add wave -position end  sim:/cpu/PC_loader_MA
add wave -position end  sim:/cpu/notclk
add wave -position end  sim:/cpu/From_decode
add wave -position end  sim:/cpu/save_flags
add wave -position end  sim:/cpu/pop_pc
add wave -position end  sim:/cpu/FLAGS_IN
add wave -position end  sim:/cpu/FLAGS_OUT
add wave -position end  sim:/cpu/Memory_Flags
add wave -position end  sim:/cpu/PC_In
add wave -position end  sim:/cpu/PC_Out
add wave -position end  sim:/cpu/PC_In_Fetch
add wave -position end  sim:/cpu/ea_imm
add wave -position end  sim:/cpu/ifid_input
add wave -position end  sim:/cpu/ifid_output
add wave -position end  sim:/cpu/idex_input
add wave -position end  sim:/cpu/idex_output
add wave -position end  sim:/cpu/exmem_input
add wave -position end  sim:/cpu/exmem_output
add wave -position end  sim:/cpu/memwb_input
add wave -position end  sim:/cpu/memwb_output
add wave -position end  sim:/cpu/Forward_From_MA
add wave -position end  sim:/cpu/Forward_from_execute
add wave -position end  sim:/cpu/WB_Out
add wave -position end  sim:/cpu/Decode_MODULE/Reg_file_MODUL/r00
add wave -position end  sim:/cpu/Decode_MODULE/Reg_file_MODUL/r11
add wave -position end  sim:/cpu/Decode_MODULE/Reg_file_MODUL/r22
add wave -position end  sim:/cpu/Decode_MODULE/Reg_file_MODUL/r33
add wave -position end  sim:/cpu/Fetch_MODULE/Intr
add wave -position end  sim:/cpu/Fetch_MODULE/push_pc
add wave -position end  sim:/cpu/Fetch_MODULE/save_flags
add wave -position end  sim:/cpu/Fetch_MODULE/pop_pc
add wave -position end  sim:/cpu/Decode_MODULE/save_flags
add wave -position end  sim:/cpu/Decode_MODULE/pop_pc
add wave -position end  sim:/cpu/Decode_MODULE/stall
mem load -i {work/testcases v2/BFormat-Interrupt.mem} -filltype value -filldata inst_mem -fillradix symbolic -skip 0 /cpu/Fetch_MODULE/ram

###start
force -freeze sim:/cpu/rst 1 0
force -freeze sim:/cpu/Intr 0 0
force -freeze sim:/cpu/clk 1 0, 0 {50 ps} -r 100
run
force -freeze sim:/cpu/in_port 00001111 0
force -freeze sim:/cpu/rst 0 0
run
run
run
force -freeze sim:/cpu/in_port 00011110 0
run
run
run
run
force -freeze sim:/cpu/Intr 1 0
