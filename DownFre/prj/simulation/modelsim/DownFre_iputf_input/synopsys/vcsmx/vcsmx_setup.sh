
cp -f F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/submodules/NCO_NEW_nco_ii_0_sin_c.hex ./
cp -f F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/submodules/NCO_NEW_nco_ii_0_cos_c.hex ./
cp -f F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/submodules/NCO_NEW_nco_ii_0_sin_f.hex ./
cp -f F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/submodules/NCO_NEW_nco_ii_0_cos_f.hex ./

vlogan +v2k "F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/submodules/NCO_NEW_nco_ii_0.v" -work nco_ii_0
vlogan +v2k "F:/Lab_Work/Learning/DownFre/prj/ip/NCO_NEW/simulation/NCO_NEW.v"                                   
