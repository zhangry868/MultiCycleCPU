transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+F:/altera/Multiple_Cycles_CPU {F:/altera/Multiple_Cycles_CPU/IRegister.v}
vlog -vlog01compat -work work +incdir+F:/altera/Multiple_Cycles_CPU {F:/altera/Multiple_Cycles_CPU/MIPS_Shifter.v}
vlog -vlog01compat -work work +incdir+F:/altera/Multiple_Cycles_CPU {F:/altera/Multiple_Cycles_CPU/MIPS_Register.v}
vlog -vlog01compat -work work +incdir+F:/altera/Multiple_Cycles_CPU {F:/altera/Multiple_Cycles_CPU/Controller.v}
vlog -vlog01compat -work work +incdir+F:/altera/Multiple_Cycles_CPU {F:/altera/Multiple_Cycles_CPU/ALU.v}
vlog -vlog01compat -work work +incdir+F:/altera/Multiple_Cycles_CPU {F:/altera/Multiple_Cycles_CPU/Memory.v}
vlog -vlog01compat -work work +incdir+F:/altera/Multiple_Cycles_CPU {F:/altera/Multiple_Cycles_CPU/Register_Shift.v}
vlog -vlog01compat -work work +incdir+F:/altera/Multiple_Cycles_CPU {F:/altera/Multiple_Cycles_CPU/Memory_Shift.v}
vlog -vlog01compat -work work +incdir+F:/altera/Multiple_Cycles_CPU {F:/altera/Multiple_Cycles_CPU/IControl.v}
vlog -vlog01compat -work work +incdir+F:/altera/Multiple_Cycles_CPU {F:/altera/Multiple_Cycles_CPU/Multiple_Cycles_CPU.v}
vlog -vlog01compat -work work +incdir+F:/altera/Multiple_Cycles_CPU {F:/altera/Multiple_Cycles_CPU/ExNumber.v}

vlog -vlog01compat -work work +incdir+F:/altera/Multiple_Cycles_CPU/simulation/modelsim {F:/altera/Multiple_Cycles_CPU/simulation/modelsim/Multiple_Cycles_CPU.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneii_ver -L rtl_work -L work -voptargs="+acc"  Multiple_Cycles_CPU_vlg_tst

add wave *
view structure
view signals
run -all
