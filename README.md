The PoC-Examples Collection
================================================================================

PoC - “Pile of Cores” provides implementations for often required hardware
functions such as FIFOs, RAM wrapper, and ALUs. The hardware modules are
typically provided as VHDL or Verilog source code, so it can be easily re-used
in a variety of hardware designs.

This repository provides common examples and synthesis tests to show how the
PoC-Library can be used. The PoC-Library is referenced as a git submodule.

Table of Content:
================================================================================
 1. [Overview](#1-overview)
 2. [Download](#2-download)
 3. [Requirements](#3-requirements)
 4. [Configure PoC on a local system](#4-configure-poc-on-a-local-system)
 5. [Synthesizing Examples](#5-synthesizing-examples)
 6. [Updating PoC](#6-updating-poc)


1 Overview
================================================================================



2 Download
================================================================================
The PoC-Examples Collection can be [downloaded][21] as a zip-file (latest 'master'
branch) or cloned with `git` from GitHub. GitHub offers HTTPS and SSH as transfer
protocols.

For SSH protocol use the URL `ssh://git@github.com:VLSI-EDA/PoC-Examples.git` or
command line instruction:

    cd <GitRoot>
    git clone ssh://git@github.com:VLSI-EDA/PoC-Examples.git PoC-Examples

For HTTPS protocol use the URL `https://github.com/VLSI-EDA/PoC-Examples.git` or
command line instruction:

    cd <GitRoot>
    git clone https://github.com/VLSI-EDA/PoC-Examples.git PoC-Examples

3 Requirements
================================================================================
### Common requirements:

 - Python 3.4
     - [colorama][301]
 - Synthesis tool chains:
     - Xilinx ISE 14.7 or
     - Xilinx Vivado 2014.x or
     - Altera Quartus II 13.x
 - Simulation tool chains:
     - Xilinx ISE Simulator 14.7 or
     - Xilinx Vivado Simulator 2014.x or
     - Mentor Graphics ModelSim Altera Edition or
     - Mentor Graphics QuestaSim or
     - [GHDL][302] and [GTKWave][303]

### Linux specific requirements:

 
### Windows specific requirements:

 - PowerShell 4.0 ([Windows Management Framework 4.0][321])
    - Allow local script execution ([read more][322])  
      `PS> Set-ExecutionPolicy RemoteSigned`
    - PowerShell Community Extensions 3.2 ([pscx.codeplex.com][323])


4 Configure PoC-Examples on a local system
================================================================================

### 4.1 Configuring the embedded PoC Library

Run the configuration process of PoC.

**Linux system**

    cd <PoCExRoot>/lib/PoC
    ./poc.sh --configure

**Windows system**

    cd <PoCExRoot>\lib\PoC
    .\poc.ps1 --configure


### 4.2 Linux system

Run the following command line instructions to configure PoC-Examples on your local system.

    cd <PoCExRoot>
    ./pocex.sh --configure


### 4.3 Windows system

All Windows command line instructions are build for PowerShell. So executing the following instructions in `cmd.exe` won't function or result in errors! PowerShell is shipped with Windows since Vista.  

    cd <PoCExRoot>
    .\pocex.ps1 --configure

### 4.4 Create a *my_project.vhdl* from template file

*TODO:*

5 Synthesizing Examples
================================================================================
The PoC-Examples Collection is shipped with project files for various tool chains and IDEs.

### 5.1 Using Xilinx ISE



### 5.2 Using Xilinx Vivado


6 Updating PoC-Examples
================================================================================



 [21]: https://github.com/VLSI-EDA/PoC-Examples/archive/master.zip
 [301]: https://pypi.python.org/pypi/colorama
 [302]: https://sourceforge.net/projects/ghdl-updates/
 [303]: http://gtkwave.sourceforge.net/
 [321]: http://www.microsoft.com/en-US/download/details.aspx?id=40855
 [322]: https://technet.microsoft.com/en-us/library/hh849812.aspx
 [323]: http://pscx.codeplex.com/
 