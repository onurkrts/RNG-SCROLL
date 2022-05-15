// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module user_proj_example #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq
);
    wire clk;
    wire rst;

	wire [31:0]x;
	wire [31:0]y;
	wire [31:0]z;


    // WB MI A
    assign wbs_dat_o = 31'h0;
    assign wbs_ack_o = 1'b0;

    // IO
    assign io_out = x;
    assign io_oeb = {(`MPRJ_IO_PADS-1){rst}};

    // IRQ
    assign irq = 3'b000;	// Unused

    // LA
    assign la_data_out = {{32{1'b0}}, z, y, x};
	
    // Assuming LA probes [97:96] are for controlling the count clk & reset  
    assign clk = (~la_oenb[96]) ? la_data_in[96]: wb_clk_i;
    assign rst = (~la_oenb[97]) ? la_data_in[97]: wb_rst_i;

    rng_chaos_scroll u_rng_chaos_chaos(
        .clk(clk),
        .rst(rst),
		.x(x),
		.y(y),
		.z(z)
    );

endmodule

module rng_chaos_scroll(
	input	 			clk, 
	input 				rst, 
	output reg [31:0]	x, 
	output reg [31:0]	y, 
	output reg [31:0]	z
);

// wires                                                                   
wire [31:0] xn, xo;                                                       
wire [31:0] yn, yo;                                                       
wire [31:0] zn, zo, zd, zd1, zd2;                                                 

wire [ 3:0] Lx;                                                            
wire [ 2:0] Ux;                                                             

assign Lx = 4'b1011;                                                      
assign Ux = 3'b100;

func F_func(                                                     
    .F_i(x),                                                               
    .U_i(Ux),                                                              
    .L_i(Lx),                                                              
    .F_o(xo)                                                               
    );                                                                            

assign yo = y;
assign zo = z;

assign zd1 = xo+yo+zo;
assign zd2 = {{4{ zd1[31]}},  zd1[31:4]};                        
assign zd =   zd1 - zd2;

assign xn = x + {{3{yo[31]}}, yo[31:3]};
assign yn = y + {{3{zo[31]}}, zo[31:3]};
assign zn = z - {{3{zd[31]}}, zd[31:3]}; 

always @(posedge clk or negedge rst)                                                    
begin                                                                      
	if(!rst) begin                                                      
        x <= 32'hDE78D681;                                                          
        y <= 32'hFEEE4640;                                                         
        z <= 32'hFE8E511B;                                                          
	end else begin                                                            
		x <= xn;                                                                 
		y <= yn;                                                                 
		z <= zn;                                                             
	end	                                                                      
end

endmodule

module func(
    input   [31:0] F_i,
    input   [ 2:0] U_i,
    input   [ 3:0] L_i,
    output  [31:0] F_o
    );   
 
 wire [ 5:0] Xhigh;
 wire [ 5:0] X26_6n;
 wire [ 5:0] Se_U;
 wire [ 5:0] XU;
 wire [ 5:0] XU_X26;
 wire [ 5:0] out_6b;

  assign Xhigh  = F_i[31:26] - {L_i[3],L_i,1'b1};
  assign X26_6n = ~{6{F_i[26]}};
  assign Se_U   = {U_i[2],U_i[2],U_i,1'b1};
  assign XU     = F_i[31:26] - Se_U;
  assign XU_X26 = (XU[5]) ? X26_6n : XU;
  assign out_6b = (Xhigh[5]) ?  Xhigh : XU_X26;
  assign F_o = {out_6b, F_i[25:0]};

endmodule

`default_nettype wire
