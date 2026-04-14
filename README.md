1KB Low Power SRAM (RTL → GDS Flow)

This project focuses on designing and implementing a 1KB low-power SRAM starting from RTL design all the way towards physical design. The goal was to understand both digital design concepts and VLSI backend flow while also applying basic power optimization techniques.

Overview

The SRAM is designed in Verilog with an emphasis on reducing unnecessary switching activity. The memory is divided into multiple banks and controlled using enable signals to achieve lower dynamic power consumption.

Features
1KB SRAM (256 × 32-bit)
Banked architecture (4 banks × 256B each)
Chip Select (CS), Write Enable (WE), Output Enable (OE)
Reduced switching activity for low power
Block RAM inference (synthesis-friendly design)

Some simple but effective techniques used:

Banking: Memory divided into 4 smaller blocks so only one bank is active at a time
Chip Select Gating: No internal activity when chip is not selected
Conditional Write: Avoid writing if data is unchanged
Registered Inputs: Reduces glitches and unnecessary toggling

These help in reducing dynamic power consumption.

Design Flow
1. RTL Design
Wrote SRAM module in Verilog
Implemented bank selection and control logic
2. Testbench Verification
Created testbench for read/write operations
Verified functionality across different memory banks
3. Simulation
Used nclaunch to run simulations
Checked waveform outputs to ensure correctness
4. Synthesis
Wrote constraints file (.sdc)
Created TCL script for automation
Used Genus for logic synthesis

Generated reports:

Area report
Timing report
Power report
5. Physical Design (Backend)

Performed using Innovus:

Floorplanning
Power planning
Placement

Remaining steps:(things i am still learning)

Clock Tree Synthesis (CTS)
Routing
