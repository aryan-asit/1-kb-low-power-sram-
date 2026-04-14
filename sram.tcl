# Use set_db instead of legacy set_attribute
set_db lib_search_path {/home/install/FOUNDRY/digital/45nm/dig/lib}
set_db library {slow.lib} ;# or whatever your .lib file is called

# If needed, define HDL search path
set_db init_hdl_search_path {./}

# Read your RTL design
read_hdl sram_1KB.v
elaborate
set_db lp_insert_clock_gating true
# Load constraints
read_sdc constraints.sdc

check_design



#clock
create_clock -name clk -period 10 clk



# Synthesis effort
set_db syn_map_effort medium
set_db syn_opt_effort medium



# Synthesis steps
syn_generic
syn_map
syn_opt

# Write results
write_hdl > sram_netlist.v
write_sdc > sram.sdc
report_timing > timing.rpt
report_area > area.rpt
report_power > power.rpt 
gui_show
