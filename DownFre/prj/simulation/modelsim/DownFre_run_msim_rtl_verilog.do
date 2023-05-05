transcript on
if ![file isdirectory DownFre_iputf_libs] {
	file mkdir DownFre_iputf_libs
}

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

###### Libraries for IPUTF cores 
vlib DownFre_iputf_libs/nco_ii_0
vmap nco_ii_0 ./DownFre_iputf_libs/nco_ii_0
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 

file copy -force F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/submodules/NCO_NEW_nco_ii_0_sin_c.hex ./
file copy -force F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/submodules/NCO_NEW_nco_ii_0_cos_c.hex ./
file copy -force F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/submodules/NCO_NEW_nco_ii_0_sin_f.hex ./
file copy -force F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/submodules/NCO_NEW_nco_ii_0_cos_f.hex ./

vlog "F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/submodules/mentor/mac_i_lpmd.v"          -work nco_ii_0
vlog "F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/submodules/mentor/asj_nco_apr_dxx.v"     -work nco_ii_0
vlog "F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/submodules/mentor/asj_nco_mob_w.v"       -work nco_ii_0
vlog "F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/submodules/mentor/asj_dxx_g.v"           -work nco_ii_0
vlog "F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/submodules/mentor/asj_nco_as_m_dp_cen.v" -work nco_ii_0
vlog "F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/submodules/mentor/asj_nco_as_m_cen.v"    -work nco_ii_0
vlog "F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/submodules/mentor/asj_altqmcpipe.v"      -work nco_ii_0
vlog "F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/submodules/mentor/asj_nco_derot.v"       -work nco_ii_0
vlog "F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/submodules/mentor/asj_nco_isdr.v"        -work nco_ii_0
vlog "F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/submodules/mentor/las.v"                 -work nco_ii_0
vlog "F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/submodules/mentor/asj_dxx.v"             -work nco_ii_0
vlog "F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/submodules/mentor/lmsd.v"                -work nco_ii_0
vlog "F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/submodules/mentor/asj_gam_dp.v"          -work nco_ii_0
vlog "F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/submodules/NCO_NEW_nco_ii_0.v"           -work nco_ii_0
vlog "F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/NCO_NEW.v"                                             

vlog -vlog01compat -work work +incdir+F:/Lab_Work/Learning/DownFre/rtl {F:/Lab_Work/Learning/DownFre/rtl/key_filter.v}
vlog -vlog01compat -work work +incdir+F:/Lab_Work/Learning/DownFre/rtl {F:/Lab_Work/Learning/DownFre/rtl/key.v}
vlog -vlog01compat -work work +incdir+F:/Lab_Work/Learning/DownFre/rtl {F:/Lab_Work/Learning/DownFre/rtl/DDS.v}
vlog -vlog01compat -work work +incdir+F:/Lab_Work/Learning/DownFre/prj {F:/Lab_Work/Learning/DownFre/prj/dds_rom.v}

vlog -vlog01compat -work work +incdir+F:/Lab_Work/Learning/DownFre/prj/../testbench {F:/Lab_Work/Learning/DownFre/prj/../testbench/dds_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -L nco_ii_0 -voptargs="+acc"  dds_tb

add wave *
view structure
view signals
run -all
