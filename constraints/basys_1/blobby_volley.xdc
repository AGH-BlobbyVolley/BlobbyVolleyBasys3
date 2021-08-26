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
set_property PACKAGE_PIN B18 [get_ports rx]
#B18
set_property IOSTANDARD LVCMOS33 [get_ports rx]
set_property PACKAGE_PIN A18 [get_ports tx]
#A18
set_property IOSTANDARD LVCMOS33 [get_ports tx]

#set_property PACKAGE_PIN T17 [get_ports {test}]
#set_property IOSTANDARD LVCMOS33 [get_ports {test}]



set_property MARK_DEBUG true [get_nets tx_OBUF]
set_property MARK_DEBUG true [get_nets rx_IBUF]
set_property MARK_DEBUG true [get_nets {reg_to_uart[6]}]
set_property MARK_DEBUG true [get_nets {reg_to_uart[10]}]
set_property MARK_DEBUG true [get_nets {reg_to_uart[12]}]
set_property MARK_DEBUG true [get_nets {reg_to_uart[15]}]
set_property MARK_DEBUG true [get_nets {reg_to_uart[0]}]
set_property MARK_DEBUG true [get_nets {reg_to_uart[2]}]
set_property MARK_DEBUG true [get_nets {reg_to_uart[8]}]
set_property MARK_DEBUG true [get_nets {reg_to_uart[9]}]
set_property MARK_DEBUG true [get_nets {reg_to_uart[13]}]
set_property MARK_DEBUG true [get_nets {reg_to_uart[4]}]
set_property MARK_DEBUG true [get_nets {reg_to_uart[1]}]
set_property MARK_DEBUG true [get_nets {reg_to_uart[3]}]
set_property MARK_DEBUG true [get_nets {reg_to_uart[5]}]
set_property MARK_DEBUG true [get_nets {reg_to_uart[7]}]
set_property MARK_DEBUG true [get_nets {reg_to_uart[11]}]
set_property MARK_DEBUG true [get_nets {reg_to_uart[14]}]
set_property MARK_DEBUG true [get_nets {uart_to_reg[6]}]
set_property MARK_DEBUG true [get_nets {uart_to_reg[9]}]
set_property MARK_DEBUG true [get_nets {uart_to_reg[2]}]
set_property MARK_DEBUG true [get_nets {uart_to_reg[4]}]
set_property MARK_DEBUG true [get_nets {uart_to_reg[5]}]
set_property MARK_DEBUG true [get_nets {uart_to_reg[7]}]
set_property MARK_DEBUG true [get_nets {uart_to_reg[8]}]
set_property MARK_DEBUG true [get_nets {uart_to_reg[12]}]
set_property MARK_DEBUG true [get_nets {uart_to_reg[13]}]
set_property MARK_DEBUG true [get_nets {uart_to_reg[1]}]
set_property MARK_DEBUG true [get_nets {uart_to_reg[10]}]
set_property MARK_DEBUG true [get_nets {uart_to_reg[11]}]
set_property MARK_DEBUG true [get_nets {uart_to_reg[14]}]
set_property MARK_DEBUG true [get_nets {uart_to_reg[0]}]
set_property MARK_DEBUG true [get_nets {uart_to_reg[3]}]
set_property MARK_DEBUG true [get_nets {uart_to_reg[15]}]
set_property MARK_DEBUG true [get_nets my_uart/my_uart_rx_n_1]
connect_debug_port u_ila_0/probe2 [get_nets [list my_uart/my_uart_rx_n_1]]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 16384 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list my_clock/inst/clk65MHz]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 16 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {reg_to_uart[0]} {reg_to_uart[1]} {reg_to_uart[2]} {reg_to_uart[3]} {reg_to_uart[4]} {reg_to_uart[5]} {reg_to_uart[6]} {reg_to_uart[7]} {reg_to_uart[8]} {reg_to_uart[9]} {reg_to_uart[10]} {reg_to_uart[11]} {reg_to_uart[12]} {reg_to_uart[13]} {reg_to_uart[14]} {reg_to_uart[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 16 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {uart_to_reg[0]} {uart_to_reg[1]} {uart_to_reg[2]} {uart_to_reg[3]} {uart_to_reg[4]} {uart_to_reg[5]} {uart_to_reg[6]} {uart_to_reg[7]} {uart_to_reg[8]} {uart_to_reg[9]} {uart_to_reg[10]} {uart_to_reg[11]} {uart_to_reg[12]} {uart_to_reg[13]} {uart_to_reg[14]} {uart_to_reg[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list rx_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list tx_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list my_uart/rx_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list tx_done]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk65MHz]
