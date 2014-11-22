transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {Multiple_Cycles_CPU_fast.vo}

vlog -vlog01compat -work work +incdir+F:/altera/Multiple_Cycles_CPU/simulation/modelsim {F:/altera/Multiple_Cycles_CPU/simulation/modelsim/Multiple_Cycles_CPU.vt}

vsim -t 1ps +transport_int_delays +transport_path_delays -L cycloneii_ver -L gate_work -L work -voptargs="+acc"  Multiple_Cycles_CPU_vlg_tst

add wave *
view structure
view signals
run -all
