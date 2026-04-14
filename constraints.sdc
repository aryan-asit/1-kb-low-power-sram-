================================

LOW POWER SDC FILE

================================

-------- CLOCK DEFINITION --------

Slow clock → reduces dynamic power

create_clock -name clk -period 40 [get_ports clk]

Add small uncertainty (realistic but safe)

set_clock_uncertainty 0.2 [get_clocks clk]

-------- INPUT DELAYS --------

set_input_delay 5 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]

-------- OUTPUT DELAYS --------

set_output_delay 5 -clock clk [all_outputs]

-------- DRIVE STRENGTH --------

Weak driving → lower switching power

set_driving_cell -lib_cell INV_X1 [all_inputs]

-------- LOAD CAP --------

Keep output load small → reduces power

set_load 0.05 [all_outputs]

-------- FANOUT LIMIT --------

Prevent excessive switching

set_max_fanout 4 [current_design]

-------- TRANSITION LIMIT --------

Avoid sharp transitions (power spikes)

set_max_transition 0.5 [current_design]

-------- CLOCK GATING (IMPORTANT FOR POWER) --------

set_clock_gating_style -sequential_cell latch 
-control_point before 
-control_signal scan_enable

-------- FALSE PATHS (OPTIONAL OPTIMIZATION) --------

Reduce unnecessary optimization effort

set_false_path -from [get_ports cs_n]
set_false_path -from [get_ports oe_n]

-------- DONT USE LARGE CELLS --------

Prevent high power cells

set_dont_use */*X4
set_dont_use */*X8
set_dont_use */*X16

-------- POWER OPTIMIZATION --------

Encourage low power mapping

set_max_leakage_power 0
set_max_dynamic_power 0

================================

END OF FILE

================================
