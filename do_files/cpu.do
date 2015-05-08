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
# ** Warning: (vsim-3473) Component instance "Decode_MODULE : decode" is not bound.
#    Time: 0 ps  Iteration: 0  Instance: /cpu File: /home/ahmed/architecture/cpu.vhd
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
sim:/cpu/WB_Out \
sim:/cpu/cin \
sim:/cpu/W \
sim:/cpu/R \
sim:/cpu/sp_from_cu \
sim:/cpu/sp_from_wb \
sim:/cpu/LS \
sim:/cpu/notclk \
sim:/cpu/sp_out \
sim:/cpu/MA \
sim:/cpu/NOP \
sim:/cpu/ifid_enable \
sim:/cpu/Done \
sim:/cpu/Rs1 \
sim:/cpu/Rs2 \
sim:/cpu/Rd_from_cu \
sim:/cpu/Rd_from_wb \
sim:/cpu/opr \
sim:/cpu/CF \
sim:/cpu/FLAGS_IN \
sim:/cpu/FLAGS_OUT \
sim:/cpu/Datain \
sim:/cpu/new_stack_value \
sim:/cpu/old_stack_value \
sim:/cpu/S1 \
sim:/cpu/S2 \
sim:/cpu/ALSU_OUT \
sim:/cpu/result_out \
sim:/cpu/sp_data_out

add wave -position 2  sim:/cpu/in_port
add wave -position 3  sim:/cpu/out_port

mem load -i {/home/ahmed/architecture/work/testcases v2/AFormat-WithoutPushPop.mem} -filltype value -filldata ahmed -fillradix symbolic -skip 0 /cpu/Fetch_MODULE/ram

###start
force -freeze sim:/cpu/rst 1 0
force -freeze sim:/cpu/clk 1 0, 0 {50 ps} -r 100
run
force -freeze sim:/cpu/in_port 00110001 0
force -freeze sim:/cpu/rst 0 0
run

