set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports pushButton]

set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS33} [get_ports debouncedPushButton]

set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports masterClk]
create_clock -period 10.00 [get_ports masterClk]