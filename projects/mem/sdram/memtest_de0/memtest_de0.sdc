## Generated SDC file "memtest_de0.sdc"

## Copyright (C) 1991-2013 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.0.0 Build 156 04/24/2013 SJ Full Version"

## DATE    "Thu Jun  6 13:55:37 2013"

##
## DEVICE  "EP3C16F484C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk_in} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clk_in}]


#**************************************************************
# Create Generated Clock
#**************************************************************

derive_pll_clocks
create_generated_clock -name {sd_ck} -source [get_pins {pll|altpll_component|auto_generated|pll1|clk[2]}] -master_clock {pll|altpll_component|auto_generated|pll1|clk[2]} [get_ports { sd_ck}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************

# SDRAM Ouptut Data Access time (t_AC, max delay) and Hold time (t_OH, min delay)
# added 0.5 ns turn-aorund time to max delay
# with 133 MHz SDRAM clock the PLL output for sd_ck must be shifted a little bit
# => multicycle-path constraint is used to select proper edges for timing calculations
set_input_delay -add_delay -max -clock [get_clocks {sd_ck}]  [expr 6.000 + 0.500] [get_ports {sd_dq[*]}]
set_input_delay -add_delay -min -clock [get_clocks {sd_ck}]  2.500 [get_ports {sd_dq[*]}]
set_multicycle_path -setup -end -rise_from [get_clocks {sd_ck}] -rise_to [get_clocks {pll|altpll_component|auto_generated|pll1|clk[1]}] 2

# Async inputs
set_false_path -from [get_ports {btn[*]}] -to [get_clocks {*}]


#**************************************************************
# Set Output Delay
#**************************************************************

# SDRAM Command Setup time (t_CS, max delay) and Hold time (t_CH, min delay)
# sd_udqm, sd_ldqm are constant outputs
set_output_delay -add_delay -max -clock [get_clocks {sd_ck}]  1.500 [get_ports {sd_cs sd_ras sd_cas sd_we}]
set_output_delay -add_delay -min -clock [get_clocks {sd_ck}]  -0.800 [get_ports {sd_cs sd_ras sd_cas sd_we}]

# SDRAM Address Setup time (t_AS, max delay) and Hold time (t_AH, min delay)
set_output_delay -add_delay -max -clock [get_clocks {sd_ck}]  1.500 [get_ports {sd_a[*] sd_ba[*]}]
set_output_delay -add_delay -min -clock [get_clocks {sd_ck}]  -0.800 [get_ports {sd_a[*] sd_ba[*]}]

# SDRAM Input Data Setup time (t_DS, max delay) and Hold time (t_DH, min delay)
set_output_delay -add_delay -max -clock [get_clocks {sd_ck}]  1.500 [get_ports {sd_dq[*]}]
set_output_delay -add_delay -min -clock [get_clocks {sd_ck}]  -0.800 [get_ports {sd_dq[*]}]

# Async outputs
set_false_path -from [get_clocks {*}] -to [get_ports {led[*]}] 


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

