vsim work.cpu

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
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run

