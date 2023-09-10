transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/franc/OneDrive/Escritorio/Arquitectura/RamPort {C:/Users/franc/OneDrive/Escritorio/Arquitectura/RamPort/RamPort.sv}

