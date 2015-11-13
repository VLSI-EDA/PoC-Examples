# Content

This directory demonstrates the usage of the SDRAM controller
provided in the namespace [`PoC.mem.sdram`][mem_sdram] of the
[PoC-Library][PoC].

## Examples

#### SDRAM Controller Usage Example for Altera DE0 Board

The module [`memtest_de0`][memtest_de0] is the top-level module of the
memory tester. It uses the sub-module [`memtest_de0_pll`][memtest_de0_pll]
for clock generation.

More project specific files are located [here][de0_project].

#### SDRAM Controller Usage Example for Xilinx Spartan-3E Starter Kit

The module [`memtest_s3esk`][memtest_s3esk] is the top-level module of the
memory tester. It uses the sub-module
[`memtest_s3esk_clockgen`][memtest_s3esk_clockgen] for clock generation.

More project specific files are located [here][s3esk_project].

###### Preferred ISE Setup

For testing the design, the following ISE configuration parameters have
been changed. They are also suitable for other FPGA projects.
(If necessary, change property display level to "Advanced".)

Synthesize:

 - Optimization Goal: Area
 - Optimization Effort: High
 - Use Synthesis Constraints File: Yes
 - Synthesis Constraints File: s3esk.xcf
 - FSM Encoding Algorithm: One-Hot
 - Resource Sharing: No
 - Equivalent Register Removal: No
 - Pack I/O Registers into IOBs: Yes


Implement:

 - Perform Timing-Driven Packing and Placement: Yes
 - Place & Route Effort Level: High


Generate Programming Files: (These are required for clockgen_s3esk)

 - Done:	6
 - Enable Ouputs: 3
 - Release Write Enable: 5
 - Wait for DLL Lock: 4


Do not forget adding `s3esk.ucf` to the project! Or import the timing
constraints to your ucf-file.


 [PoC]:				https://github.com/VLSI-EDA/PoC
 [mem_sdram]: 	    https://github.com/VLSI-EDA/PoC/tree/master/src/mem/sdram
 [memtest_de0]:				memtest_de0.vhdl
 [memtest_de0_pll]:			memtest_de0_pll.vhdl
 [de0_project]:				../../../projects/mem/sdram/memtest_de0
 [memtest_s3esk]:			memtest_s3esk.vhdl
 [memtest_s3esk_clockgen]: 	memtest_s3esk_clockgen.vhdl
 [s3esk_project]: 			../../../projects/mem/sdram/memtest_s3esk
 
