-- EMACS settings: -*-  tab-width: 2; indent-tabs-mode: t -*-
-- vim: tabstop=2:shiftwidth=2:noexpandtab
-- kate: tab-width 2; replace-tabs off; indent-width 2;
-- 
-- ============================================================================
-- Authors:					Martin Zabel
-- 
-- Module:					Clock Generator for Memory Test on QM XC6SLX16 SDRAM.
--
-- Description:
-- ------------------------------------
-- DCM configuration for module 'memtest_qm_xc6slx16_sdram'.
--
-- The DCMs dcm_mem* have either unstable input clocks upon configuration and/or
-- external feedback, and thus must be reset accordingly. So we do not use
-- the STARTUP_WAIT feature at all.
--
-- After startup the clocks are unstable. Thus, the logic
-- clocked by clk_* must be hold in reset until rst_* is deasserted.
--
-- License:
-- ============================================================================
-- Copyright 2020      Martin Zabel, Berlin, Germany
-- Copyright 2007-2015 Technische Universitaet Dresden - Germany,
--										 Chair for VLSI-Design, Diagnostics and Architecture
-- 
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- 
--		http://www.apache.org/licenses/LICENSE-2.0
-- 
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-- ============================================================================

-------------------------------------------------------------------------------
-- Naming Conventions:
-- (Based on: Keating and Bricaud: "Reuse Methodology Manual")
--
-- active low signals: "*_n"
-- clock signals: "clk", "clk_div#", "clk_#x"
-- reset signals: "rst", "rst_n"
-- generics: all UPPERCASE
-- user defined types: "*_TYPE"
-- state machine next state: "*_ns"
-- state machine current state: "*_cs"
-- output of a register: "*_r"
-- asynchronous signal: "*_a"
-- pipelined or register delay signals: "*_p#"
-- data before being registered into register with the same name: "*_nxt"
-- clock enable signals: "*_ce"
-- internal version of output port: "*_i"
-- tristate internal signal "*_z"
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.ALL;

entity memtest_qm_xc6slx16_sdram_clockgen is
  port (
    clk_in        : in  std_logic;
    user_rst_n    : in  std_logic;
    clk_sys       : out std_logic;
    clk_mem       : out std_logic;
    clk_memout    : out std_logic;
    clk_memout_n  : out std_logic;
    rst_sys       : out std_logic;
    rst_mem       : out std_logic;
    locked        : out std_logic);

end memtest_qm_xc6slx16_sdram_clockgen;

library unisim;
use unisim.VComponents.all;

architecture rtl of memtest_qm_xc6slx16_sdram_clockgen is
  -- input buffer
  signal clk_in_bufo   : std_logic;
  
  -- clock buffer inputs
  signal clk_fb_bufi       : std_logic;
  signal clk_sys_bufi      : std_logic;
  signal clk_mem_bufi      : std_logic;
  signal clk_memout_bufi   : std_logic;
  signal clk_memout_n_bufi : std_logic;

	-- PLL feedback clock
	signal clk_fb : std_logic;
	
  -- global clocks (internal signals)
  signal clk_sys_i    : std_logic;
  signal clk_mem_i    : std_logic;
  signal clk_memout_i : std_logic;

  -- locked signals
  signal pll_locked : std_logic;
  signal locked_i   : std_logic;
  
  -- reset synchronizers for clk_sys and clk_mem*
  signal rst_sys_r      : std_logic_vector(1 downto 0);
  signal rst_mem_r      : std_logic_vector(1 downto 0);

  -- do reset
  signal do_rst : std_logic;

begin
  -----------------------------------------------------------------------------
  -- 0. Input Clock buffer and system clock.
  -----------------------------------------------------------------------------
  clk_in_buf : IBUFG port map (
    I => clk_in,
    O => clk_in_bufo);

  -----------------------------------------------------------------------------
  -- 1. PLL
  -----------------------------------------------------------------------------
  pll : PLL_BASE
    generic map (
      BANDWIDTH      => "OPTIMIZED",
      CLKIN_PERIOD   => 20.0, -- ns
      CLKFBOUT_MULT  => 20,  	-- Max VCO freq = 1 GHz; divided by 50 MHz
      CLKOUT0_DIVIDE => 20,  	-- 50 MHz * 20 / 20 =  50 MHz
      CLKOUT1_DIVIDE => 10,  	-- 50 MHz * 20 / 10 = 100 MHz
      CLKOUT2_DIVIDE => 10,  	-- 50 MHz * 20 / 10 = 100 MHz
      CLKOUT3_DIVIDE => 10,  	-- 50 MHz * 20 / 10 = 100 MHz
      CLKOUT0_PHASE  => 0.0,  	-- degrees
      CLKOUT1_PHASE  => 0.0,  	-- degrees
      CLKOUT2_PHASE  => 135.0,  	-- degrees
      CLKOUT3_PHASE  => 135.0+180.0) 	-- degrees, must CLKOUT2_PHASE + 180.0
    port map (
      CLKIN    => clk_in_bufo,
      CLKFBIN  => clk_fb,
      CLKFBOUT => clk_fb_bufi,
      CLKOUT0  => clk_sys_bufi,
      CLKOUT1  => clk_mem_bufi,
      CLKOUT2  => clk_memout_bufi,
      CLKOUT3  => clk_memout_n_bufi,
      RST      => '0',
      LOCKED   => pll_locked);

  -- Minimize uncertainty for clk_memout by placing a global clock buffer
	-- into the PLL feedback path. The delay of this global clock will vary
	-- with voltage and temperature in the same way as the global clock buffer
	-- for clk_mem. Thus, the timing report can substract this
	-- variance from the timing calculation for sd_* top-level ports.
  clk_fb_buf : BUFG port map (
    I => clk_fb_bufi,
    O => clk_fb);

  clk_sys_buf : BUFG port map (
    I => clk_sys_bufi,
    O => clk_sys_i);

  clk_sys     <= clk_sys_i;

  clk_mem_buf : BUFG port map (
    I => clk_mem_bufi,
    O => clk_mem_i);

  clk_mem     <= clk_mem_i;

  clk_memout_buf : BUFG port map (
    I => clk_memout_bufi,
    O => clk_memout);

  clk_memout_n_buf : BUFG port map (
    I => clk_memout_n_bufi,
    O => clk_memout_n);

  -----------------------------------------------------------------------------
  -- 4. Locked & Resets
  --
  -- Coordinated Reset removal:
  -- - First, remove reset of clk_mem*, because it always waits for commands
  --   before it writes anything to the read FIFO.
  -- - Second, remove reset from clk_sys because it writes to the command FIFO
  --   as soon as possible. But at this time, the rst_rd from that FIFO must
  --   not be asserted, so that the write_addr is correctly transfered between
  --   the clock domains (gray-encoding is kept).
  -----------------------------------------------------------------------------
  locked_i <= pll_locked;
  locked   <= locked_i;

  do_rst <= (not locked_i) or not user_rst_n;
  
  -- synchronize locked_i with clock domain clk_sys
  process (do_rst, clk_sys_i)
  begin  -- process
    if do_rst = '1' then
      rst_sys_r <= (others => '1');
    elsif rising_edge(clk_sys_i) then
      rst_sys_r(0) <= rst_mem_r(rst_mem_r'left);        -- release as second
      rst_sys_r(rst_sys_r'left downto 1) <=
        rst_sys_r(rst_sys_r'left-1 downto 0);
    end if;
  end process;

  rst_sys <= rst_sys_r(rst_sys_r'left);

  -- synchronize locked_i with clock domain clk_mem
  process (do_rst, clk_mem_i)
  begin  -- process
    if do_rst = '1' then
      rst_mem_r <= (others => '1');
    elsif rising_edge(clk_mem_i) then
      rst_mem_r(0) <= '0';
      rst_mem_r(rst_mem_r'left downto 1) <=
        rst_mem_r(rst_mem_r'left-1 downto 0);
    end if;
  end process;

  rst_mem   <= rst_mem_r(rst_mem_r'left);

end rtl;
