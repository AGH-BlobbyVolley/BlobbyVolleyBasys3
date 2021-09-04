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


set_false_path -from [get_pins {my_MouseCtl/xpos_reg[2]/C}] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][14]/D}]
set_false_path -from [get_pins my_MouseCtl/left_reg/C] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][24]/D}]
set_false_path -from [get_pins {my_MouseCtl/xpos_reg[10]/C}] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][22]/D}]
set_false_path -from [get_pins {my_MouseCtl/xpos_reg[11]/C}] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][23]/D}]
set_false_path -from [get_pins {my_MouseCtl/xpos_reg[7]/C}] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][19]/D}]
set_false_path -from [get_pins {my_MouseCtl/xpos_reg[6]/C}] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][18]/D}]
set_false_path -from [get_pins {my_MouseCtl/xpos_reg[4]/C}] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][16]/D}]
set_false_path -from [get_pins {my_MouseCtl/xpos_reg[5]/C}] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][17]/D}]
set_false_path -from [get_pins {my_MouseCtl/xpos_reg[0]/C}] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][12]/D}]
set_false_path -from [get_pins {my_MouseCtl/xpos_reg[8]/C}] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][20]/D}]
set_false_path -from [get_pins {my_MouseCtl/xpos_reg[1]/C}] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][13]/D}]
set_false_path -from [get_pins {my_MouseCtl/xpos_reg[9]/C}] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][21]/D}]
set_false_path -from [get_pins {my_MouseCtl/xpos_reg[3]/C}] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][15]/D}]
set_false_path -from [get_pins {my_MouseCtl/ypos_reg[8]/C}] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][8]/D}]
set_false_path -from [get_pins {my_MouseCtl/ypos_reg[10]/C}] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][10]/D}]
set_false_path -from [get_pins {my_MouseCtl/ypos_reg[3]/C}] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][3]/D}]
set_false_path -from [get_pins {my_MouseCtl/ypos_reg[5]/C}] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][5]/D}]
set_false_path -from [get_pins {my_MouseCtl/ypos_reg[9]/C}] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][9]/D}]
set_false_path -from [get_pins {my_MouseCtl/ypos_reg[2]/C}] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][2]/D}]
set_false_path -from [get_pins {my_MouseCtl/ypos_reg[1]/C}] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][1]/D}]
set_false_path -from [get_pins {my_MouseCtl/ypos_reg[6]/C}] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][6]/D}]
set_false_path -from [get_pins {my_MouseCtl/ypos_reg[7]/C}] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][7]/D}]
set_false_path -from [get_pins {my_MouseCtl/ypos_reg[4]/C}] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][4]/D}]
set_false_path -from [get_pins {my_MouseCtl/ypos_reg[0]/C}] -to [get_pins {my_buffor_signal_mouse/del_mem_reg[0][0]/D}]
