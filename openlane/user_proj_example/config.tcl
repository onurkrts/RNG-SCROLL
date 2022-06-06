# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

set ::env(PDK) "sky130A"
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) user_proj_example

set ::env(VERILOG_FILES) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/user_proj_example.v"

set ::env(DESIGN_IS_CORE) 0

set ::env(CLOCK_PORT) "wb_clk_i"
set ::env(CLOCK_NET) "rng_chaos.clk"
set ::env(CLOCK_PERIOD) "10"

set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 1000 1400"

set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg

set ::env(DRT_MAX_LAYER) {met4}
set ::env(RT_MAX_LAYER) {met4}

# You can draw more power domains if you need to 
set ::env(VDD_NETS) [list {vccd1}]
set ::env(GND_NETS) [list {vssd1}]


##################################################################
# Flow Control
##################################################################

set ::env(RUN_ROUTING_DETAILED) 1
# If you're going to use multiple power domains, then disable cvc run.
set ::env(RUN_CVC) 1
set ::env(RUN_LVS) 1
set ::env(TAP_DECAP_INSERTION) 1
set ::env(LEC_ENABLE) 0
set ::env(FILL_INSERTION) 1

##################################################################
# Synthesis
##################################################################

set ::env(SYNTH_STRATEGY) {DELAY 1}
set ::env(SYNTH_READ_BLACKBOX_LIB) 0
set ::env(SYNTH_MAX_FANOUT) 5
set ::env(SYNTH_MIN_BUF_PORT) {sky130_fd_sc_hd__buf_4 A X}
set ::env(SYNTH_BUFFERING) 1
set ::env(SYNTH_MAX_TRAN) {0.5}

##################################################################
# Floorplan
##################################################################

set ::env(FP_CORE_UTIL) 18
set ::env(DESIGN_IS_CORE) 0
set ::env(FP_PDN_CHECK_NODES) 1
	
##################################################################
# Placement
##################################################################

set ::env(PL_BASIC_PLACEMENT) 0
set ::env(PL_TARGET_DENSITY) 0.2
set ::env(PL_RANDOM_GLB_PLACEMENT) 0
set ::env(PL_TIME_DRIVEN) 1
set ::env(PL_ROUTABILITY_DRIVEN) 1
set ::env(PL_MAX_DISPLACEMENT_X) 800
set ::env(PL_MAX_DISPLACEMENT_Y) 600
set ::env(PL_RESIZER_BUFFER_INPUT_PORTS) 1
set ::env(PL_RESIZER_BUFFER_OUTPUT_PORTS) 1
set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) 1
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) 1

set ::env(CELL_PAD) 6

set ::env(PL_RESIZER_SETUP_MAX_BUFFER_PERCENT) 30
set ::env(PL_RESIZER_HOLD_MAX_BUFFER_PERCENT) 70
set ::env(PL_RESIZER_ALLOW_SETUP_VIOS) 1
set ::env(PL_RESIZER_HOLD_SLACK_MARGIN) 0.3
set ::env(PL_RESIZER_MAX_SLEW_MARGIN) 50
set ::env(PL_RESIZER_MAX_WIRE_LENGTH) 200

##################################################################
# CTS
##################################################################

set ::env(CTS_TARGET_SKEW) 150
set ::env(CTS_TOLERANCE) 25
set ::env(CTS_SINK_CLUSTERING_SIZE) 8
set ::env(CLOCK_BUFFER_FANOUT) 5
set ::env(CTS_CLK_MAX_WIRE_LENGTH) 300

##################################################################
# Global Routing
##################################################################

set ::env(GLB_RT_ANT_ITERS) 30
set ::env(GLB_RT_MAX_DIODE_INS_ITERS) 30
set ::env(GLOBAL_ROUTER) fastroute
set ::env(GLB_RESIZER_TIMING_OPTIMIZATIONS) 1
set ::env(GLB_RESIZER_ALLOW_SETUP_VIOS) 1
set ::env(GLB_RESIZER_HOLD_SLACK_MARGIN) 0.4
set ::env(GLB_RESIZER_HOLD_MAX_BUFFER_PERCENT) 70

##################################################################
# Antenna Diodes Insertion
##################################################################

set ::env(DIODE_PADDING) 2
set ::env(DIODE_INSERTION_STRATEGY) 3

##################################################################
# Detailed Routing
##################################################################

set ::env(DRT_OPT_ITERS) 40
set ::env(ROUTING_CORES) 6
set ::env(DETAILED_ROUTER) tritonroute

##################################################################
# Physical Verification
##################################################################

set ::env(MAGIC_DRC_USE_GDS) 1
set ::env(MAGIC_EXT_USE_GDS) 1
set ::env(LVS_CONNECT_BY_LABEL) 0
