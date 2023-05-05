
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
