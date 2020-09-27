-- EMACS settings: -*-  tab-width: 2; indent-tabs-mode: t -*-
-- vim: tabstop=2:shiftwidth=2:noexpandtab
-- kate: tab-width 2; replace-tabs off; indent-width 2;
-- 
-- ============================================================================
-- Authors:					Martin Zabel
-- 
-- Module:					Memory Controller Test for QM XC6SLX16 SDRAM.
--
-- Description:
-- ------------------------------------
-- Top-Level of Memory Controller Test for QM XC6SLX16 SDRAM.
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library poc;
use poc.utils.all;
use poc.fifo.all;

entity memtest_qm_xc6slx16_sdram is

  port (
    clk_in : in std_logic;
    sw3_n  : in std_logic;
    led1_n : out std_logic;
    led3_n : out std_logic;

    sd_ck  : out   std_logic;
    sd_cke : out   std_logic;
    sd_cs  : out   std_logic;
    sd_ras : out   std_logic;
    sd_cas : out   std_logic;
    sd_we  : out   std_logic;
    sd_ba  : out   std_logic_vector(1 downto 0);
    sd_a   : out   std_logic_vector(12 downto 0);
    sd_ldm : out   std_logic;
    sd_udm : out   std_logic;
    sd_dq  : inout std_logic_vector(15 downto 0));

end memtest_qm_xc6slx16_sdram;

architecture rtl of memtest_qm_xc6slx16_sdram is

	-- 32 MiB
  constant CTRL_A_BITS : positive := 24;
  constant CTRL_D_BITS : positive := 16;
  constant RATIO       : positive := 8;  -- burst length: 1, 2, 4 or 8
  constant MEM_A_BITS  : positive := CTRL_A_BITS-log2ceil(RATIO);
  constant MEM_D_BITS  : positive := CTRL_D_BITS*RATIO;
	
  signal clk_sys       : std_logic;
  signal clk_mem       : std_logic;
  signal clk_memout    : std_logic;
  signal clk_memout_n  : std_logic;
  signal rst_sys       : std_logic;
  signal rst_mem       : std_logic;
  signal locked        : std_logic;

  signal clk_tb : std_logic;
  signal rst_tb : std_logic;

  signal user_cmd_valid   : std_logic;
  signal user_wdata_valid : std_logic;
  signal user_write       : std_logic;
  signal user_addr        : std_logic_vector(CTRL_A_BITS-1 downto 0);
  signal user_wdata       : std_logic_vector(CTRL_D_BITS-1 downto 0);
  signal user_wmask       : std_logic_vector(CTRL_D_BITS/8-1 downto 0) := (others => '0');
  signal user_got_cmd     : std_logic;
  signal user_got_wdata   : std_logic;
  signal user_rdata       : std_logic_vector(CTRL_D_BITS-1 downto 0);
  signal user_rstb        : std_logic;

  signal mem_rdy    : std_logic;
  signal mem_rstb   : std_logic;
  signal mem_rdata  : std_logic_vector(MEM_D_BITS-1 downto 0);
  signal mem_req    : std_logic;
  signal mem_write  : std_logic;
  signal mem_addr   : unsigned(MEM_A_BITS-1 downto 0);
  signal mem_wdata  : std_logic_vector(MEM_D_BITS-1 downto 0);
  signal fsm_status : std_logic_vector(2 downto 0);

begin  -- rtl

  clockgen : entity work.memtest_qm_xc6slx16_sdram_clockgen
    port map (
      clk_in       => clk_in,
      user_rst_n   => sw3_n,
      clk_sys      => clk_sys,
      clk_mem      => clk_mem,
      clk_memout   => clk_memout,
      clk_memout_n => clk_memout_n,
      rst_sys      => rst_sys,
      rst_mem      => rst_mem,
      locked       => locked);

  -- Testbench clock selection
  -- Also update chipscope configuration.
--  clk_tb <= clk_mem;
--  rst_tb <= rst_mem;
  clk_tb <= clk_sys;
  rst_tb <= rst_sys;
  

  -- uses default configuration, see entity declaration
  mem_ctrl: entity poc.sdram_ctrl_qm_xc6slx16_sdram
    generic map (
      CLK_PERIOD  => 10.0, -- 100 MHz, must match configuration of clockgen
      CL          => 2,
      BL          => RATIO) -- BL = RATIO for single data-rate SDRAM
    port map (
      clk              => clk_mem,
      clkout           => clk_memout,
      clkout_n         => clk_memout_n,
      rst              => rst_mem,
      user_cmd_valid   => user_cmd_valid,
      user_wdata_valid => user_wdata_valid,
      user_write       => user_write,
      user_addr        => user_addr,
      user_wdata       => user_wdata,
      user_wmask       => user_wmask,
      user_got_cmd     => user_got_cmd,
      user_got_wdata   => user_got_wdata,
      user_rdata       => user_rdata,
      user_rstb        => user_rstb,
      sd_ck            => sd_ck,
      sd_cke           => sd_cke,
      sd_cs            => sd_cs,
      sd_ras           => sd_ras,
      sd_cas           => sd_cas,
      sd_we            => sd_we,
      sd_ba            => sd_ba,
      sd_a             => sd_a,
			sd_dqm(0)        => sd_ldm,
			sd_dqm(1)        => sd_udm,
      sd_dq            => sd_dq);

	mem2ctrl_adapter: entity PoC.sdram_mem2ctrl_adapter
    generic map (
      MEM_A_BITS => MEM_A_BITS,
      MEM_D_BITS => MEM_D_BITS,
			RATIO      => RATIO)
    port map (
      clk_sys          => clk_tb,
      clk_ctrl         => clk_mem,
      rst_sys          => rst_tb,
      rst_ctrl         => rst_mem,
      mem_req          => mem_req,
      mem_write        => mem_write,
      mem_addr         => mem_addr,
      mem_wdata        => mem_wdata,
      --mem_wmask        => mem_wmask,
      mem_rdy          => mem_rdy,
      mem_rstb         => mem_rstb,
      mem_rdata        => mem_rdata,
      user_cmd_valid   => user_cmd_valid,
      user_wdata_valid => user_wdata_valid,
      user_write       => user_write,
      user_addr        => user_addr,
      user_wdata       => user_wdata,
      user_wmask       => user_wmask,
      user_got_cmd     => user_got_cmd,
      user_got_wdata   => user_got_wdata,
      user_rdata       => user_rdata,
      user_rstb        => user_rstb);
	
  fsm: entity work.memtest_fsm
    generic map (
      A_BITS => MEM_A_BITS,
      D_BITS => MEM_D_BITS)
    port map (
      clk       => clk_tb,
      rst       => rst_tb,
      mem_rdy   => mem_rdy,
      mem_rstb  => mem_rstb,
      mem_rdata => mem_rdata,
      mem_req   => mem_req,
      mem_write => mem_write,
      mem_addr  => mem_addr,
      mem_wdata => mem_wdata,
      status    => fsm_status);

	--mem_addr(mem_addr'left downto 3) <= (others => '0');

  -----------------------------------------------------------------------------
  -- Outputs
  -----------------------------------------------------------------------------

  led1_n <= not fsm_status(0);
  led3_n <= not fsm_status(1);

end rtl;
