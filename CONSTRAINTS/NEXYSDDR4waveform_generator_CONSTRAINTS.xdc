set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33}  [get_ports clk]
create_clock -period 10.00 [get_ports clk]
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports reset]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports enable]
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS33} [get_ports encA]
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports encB]
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports encButton]
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports encSwitch]  
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports {waveform[7]}]
set_property -dict {PACKAGE_PIN G13 IOSTANDARD LVCMOS33} [get_ports {waveform[6]}]
set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVCMOS33} [get_ports {waveform[5]}]
set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVCMOS33} [get_ports {waveform[4]}]
set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports {waveform[3]}]
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS33} [get_ports {waveform[2]}]
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS33} [get_ports {waveform[1]}]
set_property -dict {PACKAGE_PIN D14 IOSTANDARD LVCMOS33} [get_ports {waveform[0]}]
set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVCMOS33} [get_ports waveformEnabled]
