set project Blobby_volley
set top_module blobby_volley
set target xc7a35tcpg236-1
set bitstream_file build/${project}.runs/impl_1/${top_module}.bit

proc usage {} {
    puts "usage: vivado -mode tcl -source [info script] -tclargs \[simulation/bitstream/program\]"
    exit 1
}

if {($argc != 1) || ([lindex $argv 0] ni {"simulation" "bitstream" "program"})} {
    usage
}



if {[lindex $argv 0] == "program"} {
    open_hw_manager
    connect_hw_server
    current_hw_target [get_hw_targets *]
    open_hw_target
    current_hw_device [lindex [get_hw_devices] 0]
    refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]

    set_property PROBES.FILE {} [lindex [get_hw_devices] 0]
    set_property FULL_PROBES.FILE {} [lindex [get_hw_devices] 0]
    set_property PROGRAM.FILE ${bitstream_file} [lindex [get_hw_devices] 0]

    program_hw_devices [lindex [get_hw_devices] 0]
    refresh_hw_device [lindex [get_hw_devices] 0]
    
    exit
} else {
    file mkdir build
    create_project ${project} build -part ${target} -force
}

read_xdc {
        constraints/basys_1/blobby_volley.xdc
    	constraints/clock.xdc
    	constraints/clock_board.xdc
    	constraints/clock_late.xdc
    	constraints/clock_ooc.xdc
}

read_vhdl {
	rtl/common/MouseCtl.vhd
	rtl/common/Ps2Interface.vhd
}
read_verilog {
    	rtl/basys_1/blobby_volley.v
    	rtl/common/vga_timing.v
	rtl/common/draw_background.v
	rtl/common/reset.v
	rtl/basys_1/clock.v
	rtl/basys_1/clock_clk_wiz.v
	rtl/common/player1_rom.v
	rtl/common/delay.v
	rtl/common/_vga_macros.vh
	rtl/common/player1.v
	rtl/common/mouse_limit_player.v
	rtl/common/buffor_signal_mouse.v
	rtl/common/ball_rom.v
	rtl/common/draw_ball.v
	rtl/basys_1/ball_pos_ctrl.v
	rtl/common/clk_divider.v
    	rtl/basys_1/judge.v
	rtl/common/uart/uart_rx.v
    	rtl/common/uart/uart_tx.v
    	rtl/common/uart/uart.v
    	rtl/common/uart/mod_m_counter.v
    	rtl/common/uart/conv16to8bit.v
    	rtl/common/uart/conv8to16bit.v
    	rtl/basys_1/uart_demux.v
	rtl/basys_1/uart_mux.v
	rtl/common/Player_2.v
}

read_mem {
	rtl/common/image.dat
	rtl/common/blobby.dat
	rtl/common/ball.dat
}

add_files -fileset sim_1 {
    sim/testbench.v
    sim/tiff_writer.v
	sim/tb_ball.v
}

set_property top ${top_module} [current_fileset]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

if {[lindex $argv 0] == "simulation"} {
    launch_simulation
    start_gui
} else {
    launch_runs synth_1 -jobs 8
    wait_on_run synth_1

    launch_runs impl_1 -to_step write_bitstream -jobs 8
    wait_on_run impl_1
    exit
}
