onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top/clk
add wave -noupdate /tb_top/rst
add wave -noupdate /tb_top/initial_en
add wave -noupdate /tb_top/datain_re
add wave -noupdate /tb_top/datain_im
add wave -noupdate /tb_top/t1/ram1/initial_flag
add wave -noupdate -radix unsigned /tb_top/t1/ctrl/state
add wave -noupdate -radix unsigned /tb_top/t1/ctrl/L
add wave -noupdate -radix unsigned /tb_top/t1/ctrl/J
add wave -noupdate -radix unsigned /tb_top/t1/ctrl/K
add wave -noupdate -radix unsigned /tb_top/t1/ctrl/SameJ_cnt
add wave -noupdate /tb_top/t1/ram1/rd_en
add wave -noupdate -radix unsigned /tb_top/t1/ram1/rd_add1
add wave -noupdate -radix unsigned /tb_top/t1/ram1/rd_add2
add wave -noupdate /tb_top/t1/butterfly1/a_re
add wave -noupdate /tb_top/t1/butterfly1/a_im
add wave -noupdate /tb_top/t1/butterfly1/en
add wave -noupdate {/tb_top/t1/butterfly1/en_r[0]}
add wave -noupdate /tb_top/t1/butterfly1/b_re
add wave -noupdate /tb_top/t1/butterfly1/b_im
add wave -noupdate /tb_top/t1/butterfly1/c_re
add wave -noupdate /tb_top/t1/butterfly1/c_im
add wave -noupdate {/tb_top/t1/butterfly1/en_r[1]}
add wave -noupdate /tb_top/t1/butterfly1/outa_re
add wave -noupdate /tb_top/t1/butterfly1/outa_im
add wave -noupdate /tb_top/t1/butterfly1/outb_re
add wave -noupdate /tb_top/t1/butterfly1/outb_im
add wave -noupdate /tb_top/t1/ram1/A_origin
add wave -noupdate /tb_top/t1/ram1/wr_en
add wave -noupdate /tb_top/t1/ram1/wd_finish
add wave -noupdate -radix unsigned /tb_top/t1/ram1/wr_add1
add wave -noupdate -radix unsigned /tb_top/t1/ram1/wr_add2
add wave -noupdate /tb_top/fft_finish
add wave -noupdate /tb_top/t1/ram1/clk_rd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1158729 ps} 0} {{Cursor 2} {862009 ps} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {803438 ps} {1669447 ps}
