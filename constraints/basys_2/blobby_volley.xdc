# Constraints for CLK
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
#create_clock -name external_clock -period 10.00 [get_ports clk]

# Constraints for VS and HS
set_property PACKAGE_PIN R19 [get_ports vs]
set_property IOSTANDARD LVCMOS33 [get_ports vs]
set_property PACKAGE_PIN P19 [get_ports hs]
set_property IOSTANDARD LVCMOS33 [get_ports hs]

# Constraints for RED
set_property PACKAGE_PIN G19 [get_ports {r[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[0]}]
set_property PACKAGE_PIN H19 [get_ports {r[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[1]}]
set_property PACKAGE_PIN J19 [get_ports {r[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[2]}]
set_property PACKAGE_PIN N19 [get_ports {r[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[3]}]

# Constraints for GRN
set_property PACKAGE_PIN J17 [get_ports {g[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[0]}]
set_property PACKAGE_PIN H17 [get_ports {g[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[1]}]
set_property PACKAGE_PIN G17 [get_ports {g[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[2]}]
set_property PACKAGE_PIN D17 [get_ports {g[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[3]}]

# Constraints for BLU
set_property PACKAGE_PIN N18 [get_ports {b[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[0]}]
set_property PACKAGE_PIN L18 [get_ports {b[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[1]}]
set_property PACKAGE_PIN K18 [get_ports {b[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[2]}]
set_property PACKAGE_PIN J18 [get_ports {b[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[3]}]

# Constraints for PCLK_MIRROR
set_property PACKAGE_PIN J1 [get_ports pclk_mirror]
set_property IOSTANDARD LVCMOS33 [get_ports pclk_mirror]

# Constraints for CFGBVS
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

# Constraints for buttons
set_property PACKAGE_PIN U18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

#mouse
set_property PACKAGE_PIN C17 [get_ports ps2_clk]
set_property PULLUP true [get_ports ps2_clk]
set_property IOSTANDARD LVCMOS33 [get_ports ps2_clk]

set_property PACKAGE_PIN B17 [get_ports ps2_data]
set_property PULLUP true [get_ports ps2_data]
set_property IOSTANDARD LVCMOS33 [get_ports ps2_data]

#uart
set_property PACKAGE_PIN J2 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports rx]
set_property PACKAGE_PIN G2 [get_ports tx]
set_property IOSTANDARD LVCMOS33 [get_ports tx]

#set_property PACKAGE_PIN T17 [get_ports {test}]
#set_property IOSTANDARD LVCMOS33 [get_ports {test}]



set_property MARK_DEBUG true [get_nets my_uart/con_broken_i_3_n_0]
set_property MARK_DEBUG true [get_nets {my_uart/tick_cnt_reg[0]}]
set_property MARK_DEBUG true [get_nets {my_uart/tick_cnt_reg[5]}]
set_property MARK_DEBUG true [get_nets {my_uart/tick_cnt_reg[6]}]
set_property MARK_DEBUG true [get_nets {my_uart/tick_cnt_reg[9]}]
set_property MARK_DEBUG true [get_nets {my_uart/tick_cnt_reg[1]}]
set_property MARK_DEBUG true [get_nets {my_uart/tick_cnt_reg[2]}]
set_property MARK_DEBUG true [get_nets {my_uart/tick_cnt_reg[3]}]
set_property MARK_DEBUG true [get_nets {my_uart/tick_cnt_reg[4]}]
set_property MARK_DEBUG true [get_nets {my_uart/tick_cnt_reg[7]}]
set_property MARK_DEBUG true [get_nets {my_uart/tick_cnt_reg[8]}]
set_property MARK_DEBUG true [get_nets tx_OBUF]
set_property MARK_DEBUG true [get_nets rx_IBUF]
connect_debug_port u_ila_0/probe1 [get_nets [list my_uart/con_broken_i_3_n_0]]
connect_debug_port u_ila_0/probe2 [get_nets [list my_uart_n_4]]
connect_debug_port u_ila_0/probe6 [get_nets [list rx_done]]

set_property MARK_DEBUG true [get_nets {my_uart/my_conv16to8bit/word_nr[0]}]
set_property MARK_DEBUG true [get_nets {my_uart/my_conv16to8bit/word_nr[1]}]
set_property MARK_DEBUG true [get_nets {my_uart/my_conv16to8bit/Q[0]}]
set_property MARK_DEBUG true [get_nets {my_uart/my_conv16to8bit/Q[1]}]
set_property MARK_DEBUG true [get_nets {my_uart/my_conv16to8bit/Q[2]}]
set_property MARK_DEBUG true [get_nets {my_uart/my_conv16to8bit/Q[3]}]
set_property MARK_DEBUG true [get_nets {my_uart/my_conv16to8bit/Q[4]}]
set_property MARK_DEBUG true [get_nets {my_uart/my_conv16to8bit/Q[5]}]
set_property MARK_DEBUG true [get_nets {my_uart/my_conv16to8bit/Q[6]}]
set_property MARK_DEBUG true [get_nets {my_uart/my_conv16to8bit/Q[7]}]
set_property MARK_DEBUG true [get_nets my_uart/my_conv8to16bit/valid_reg_0]
set_property MARK_DEBUG true [get_nets my_uart/my_conv16to8bit/ready_i_1_n_0]
create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 32768 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list my_clock/inst/clk65MHz]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 10 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {my_uart/tick_cnt_reg[0]} {my_uart/tick_cnt_reg[1]} {my_uart/tick_cnt_reg[2]} {my_uart/tick_cnt_reg[3]} {my_uart/tick_cnt_reg[4]} {my_uart/tick_cnt_reg[5]} {my_uart/tick_cnt_reg[6]} {my_uart/tick_cnt_reg[7]} {my_uart/tick_cnt_reg[8]} {my_uart/tick_cnt_reg[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 2 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {my_uart/my_conv16to8bit/word_nr[0]} {my_uart/my_conv16to8bit/word_nr[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list my_uart/my_conv16to8bit/ready_i_1_n_0]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list rx_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list my_uart/tx_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list tx_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list my_uart/my_conv8to16bit/conv8to16valid]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk65MHz]
