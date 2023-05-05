transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {d:/quartus_18/quartus_prime18_install_file/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {d:/quartus_18/quartus_prime18_install_file/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {d:/quartus_18/quartus_prime18_install_file/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {d:/quartus_18/quartus_prime18_install_file/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {d:/quartus_18/quartus_prime18_install_file/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/cycloneive_ver
vmap cycloneive_ver ./verilog_libs/cycloneive_ver
vlog -vlog01compat -work cycloneive_ver {d:/quartus_18/quartus_prime18_install_file/quartus/eda/sim_lib/cycloneive_atoms.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+F:/Lab_Work/1_Learning/4_Signal_Processing_Code/FFT/FFT_Verilog/rtl {F:/Lab_Work/1_Learning/4_Signal_Processing_Code/FFT/FFT_Verilog/rtl/top.v}
vlog -vlog01compat -work work +incdir+F:/Lab_Work/1_Learning/4_Signal_Processing_Code/FFT/FFT_Verilog/rtl {F:/Lab_Work/1_Learning/4_Signal_Processing_Code/FFT/FFT_Verilog/rtl/A_RAM.v}
vlog -vlog01compat -work work +incdir+F:/Lab_Work/1_Learning/4_Signal_Processing_Code/FFT/FFT_Verilog/rtl {F:/Lab_Work/1_Learning/4_Signal_Processing_Code/FFT/FFT_Verilog/rtl/butterfly.v}
vlog -vlog01compat -work work +incdir+F:/Lab_Work/1_Learning/4_Signal_Processing_Code/FFT/FFT_Verilog/prj/ip {F:/Lab_Work/1_Learning/4_Signal_Processing_Code/FFT/FFT_Verilog/prj/ip/ip_multi.v}
vlog -vlog01compat -work work +incdir+F:/Lab_Work/1_Learning/4_Signal_Processing_Code/FFT/FFT_Verilog/rtl {F:/Lab_Work/1_Learning/4_Signal_Processing_Code/FFT/FFT_Verilog/rtl/ram_contral.v}

vlog -vlog01compat -work work +incdir+F:/Lab_Work/1_Learning/4_Signal_Processing_Code/FFT/FFT_Verilog/prj/../testbench {F:/Lab_Work/1_Learning/4_Signal_Processing_Code/FFT/FFT_Verilog/prj/../testbench/tb_top.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_top

add wave *
view structure
view signals
run -all
