# The PoC-Examples Collection

PoC - “Pile of Cores” provides implementations for often required hardware
functions such as FIFOs, RAM wrapper, and ALUs. The hardware modules are
typically provided as VHDL or Verilog source code, so it can be easily re-used
in a variety of hardware designs.

This repository provides common examples and synthesis tests to show how the
PoC-Library can be used. The PoC-Library is referenced as a git submodule.

Table of Content:
--------------------------------------------------------------------------------
 1. [Overview](#1-overview)
 2. [Download](#2-download)
 3. [Requirements](#3-requirements)
 4. [Configure PoC-Examples on a Local System](#4-configure-poc-examples-on-a-local-system)
 5. [Synthesizing Examples](#5-synthesizing-examples)
 6. [Updating PoC](#6-updating-poc)

--------------------------------------------------------------------------------

## 1 Overview

TODO TODO TODO

## 2 Download

**The PoC-Examples Collection** can be downloaded as a [zip-file][download] (latest
'master' branch) or cloned with `git clone` from GitHub. GitHub offers HTTPS and SSH
as transfer protocols. See the [Download][wiki:download] wiki page for more details.

For SSH protocol use the URL `ssh://git@github.com:VLSI-EDA/PoC-Examples.git` or command
line instruction:

```PowerShell
cd <GitRoot>
git clone --recursive ssh://git@github.com:VLSI-EDA/PoC-Examples.git PoC-Examples
```

For HTTPS protocol use the URL `https://github.com/VLSI-EDA/PoC-Examples.git` or command
line instruction:

```PowerShell
cd <GitRoot>
git clone --recursive https://github.com/VLSI-EDA/PoC-Examples.git PoC-Examples
```

**Note:** The option `--recursive` performs a recursive clone operation for all
linked [git submodules][git_submod]. An additional `git submodule init` and
`git submodule update` call is not needed anymore. 

 [download]: https://github.com/VLSI-EDA/PoC-Examples/archive/master.zip
 [git_submod]: http://git-scm.com/book/en/v2/Git-Tools-Submodules


## 3 Requirements

**The PoC-Examples Collection** and the PoC-Library come with some scripts to ease most
of the common tasks, like running testbenches, generating IP cores or synthesizing
examples. We choose to use Python as a platform independent scripting environment.
All Python scripts are wrapped in PowerShell or Bash scripts, to hide some platform
specifics of Windows or Linux. See the [Requirements][wiki:requirements] wiki page
for more details and download sources.

##### Common requirements:

 - Programming languages and runtimes:
	- [Python 3][python] (&ge; 3.4):
	     - [colorama][colorama]
 - Synthesis tool chains:
     - Xilinx ISE 14.7 or
     - Xilinx Vivado &ge; 2014.1 or
     - Altera Quartus-II &ge; 13.x
 - Simulation tool chains:
     - Xilinx ISE Simulator 14.7 or
     - Xilinx Vivado Simulator &ge; 2014.1 or
     - Mentor Graphics ModelSim Altera Edition or
     - Mentor Graphics QuestaSim or
     - [GHDL][ghdl] and [GTKWave][gtkwave]

 [python]:		https://www.python.org/downloads/
 [colorama]:	https://pypi.python.org/pypi/colorama
 [ghdl]:		https://sourceforge.net/projects/ghdl-updates/
 [gtkwave]:		http://gtkwave.sourceforge.net/

##### Linux specific requirements:
 
 - Debian specific:
	- bash is configured as `/bin/sh` ([read more](https://wiki.debian.org/DashAsBinSh))  
      `dpkg-reconfigure dash`
 
##### Windows specific requirements:

 - PowerShell 4.0 ([Windows Management Framework 4.0][wmf40])
    - Allow local script execution ([read more][execpol])  
      `Set-ExecutionPolicy RemoteSigned`
    - PowerShell Community Extensions 3.2 ([pscx.codeplex.com][pscx])

 [wmf40]:   http://www.microsoft.com/en-US/download/details.aspx?id=40855
 [execpol]: https://technet.microsoft.com/en-us/library/hh849812.aspx
 [pscx]:    http://pscx.codeplex.com/


## 4 Configure PoC-Examples on a Local System

To explore PoC-Examples' and PoC's full potential, it's required to configure
some paths and synthesis or simulation tool chains. The following commands
start a guided configuration process. Please follow the instructions. It's
possible to relaunch the process at every time, for example to register new
tools or to update tool versions. See the [Configuration][wiki:configuration]
wiki page for more details.

#### 4.1 Configuring the Embedded PoC-Library

> All Windows command line instructions are intended for **Windows PowerShell**,
> if not marked otherwise. So executing the following instructions in Windows
> Command Prompt (`cmd.exe`) won't function or result in errors! See the
> [Requirements][wiki:requirements] wiki page on where to download or update
> PowerShell.

Run the following command line instructions to configure the embedded PoC-Library
on your local system.

```PowerShell
cd <ExamplesRoot>
cd lib\PoC\
.\poc.ps1 --configure
```

#### 4.2 Creating PoC's my_project File

The PoC-Library needs two VHDL files for it's configuration. These files are used
to determine the most suitable implementation depending on the provided platform
information. A set of my_config files is provided within the collection, but a per
host `my_project.vhdl` needs to be created.

The **my_project** file can be created from a template provided by PoC in
`<ExamplesRoot>\lib\PoC\src\common\my_project.vhdl.template`.
    
The file must to be copyed into the collection's source directory `<ExamplesRoot>\src\common`
and rename into `my_project.vhdl`. This file **must not** be included into version control
systems - it's private to a host computer. 

```PowerShell
cd <ExamplesRoot>
cp lib\PoC\src\common\my_project.vhdl.template src\common\my_project.vhdl
```

`my_project.vhdl` defines two global constants, which need to be adjusted:

```VHDL
constant MY_PROJECT_DIR      : string := "CHANGE THIS"; -- e.g. d:/vhdl/myproject/, /home/me/projects/myproject/"
constant MY_OPERATING_SYSTEM : string := "CHANGE THIS"; -- e.g. WINDOWS, LINUX
```

## 5 Synthesizing Examples

The PoC-Examples Collection is shipped with project files for various tool chains and IDEs.

#### 5.1 Using Xilinx ISE



#### 5.2 Using Xilinx Vivado


#### 5.3 Using Altera Quartus-II


## 6 Updating PoC-Examples



 [wiki:download]:		https://github.com/VLSI-EDA/PoC-Examples/wiki/Download
 [wiki:requirements]:	https://github.com/VLSI-EDA/PoC-Examples/wiki/Requirements
 [wiki:configuration]:	https://github.com/VLSI-EDA/PoC-Examples/wiki/Configuration
 