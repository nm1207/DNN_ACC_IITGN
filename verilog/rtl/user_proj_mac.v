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

module user_proj_mac #(
    parameter BITS = 38
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
    output reg wbs_ack_o,
    output reg [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [BITS-1:0] io_in,
    output [BITS-1:0] io_out,
    output [BITS-1:0] io_oeb,

   // Independent clock (on independent integer divider)
    input   user_clock2,
    // IRQ
    output [2:0] irq
);
    
wire clk,rst;
assign clk = wb_clk_i;
assign rst = wb_rst_i;

wire [255:0] data_in;

wire [27:0] data_out;


wire xor_output;

assign xor_output = io_in[0] ^ io_in[1] ^ io_in[2] ^ io_in[3] ^ io_in[4] ^ io_in[5] ^ io_in[6]
                 ^ io_in[7] ^ io_in[8] ^ io_in[9] ^ io_in[10] ^ io_in[11] ^ io_in[12] ^ io_in[13]
                 ^ io_in[14] ^ io_in[15] ^ io_in[16] ^ io_in[17] ^ io_in[18] ^ io_in[19] ^ io_in[20]
                 ^ io_in[21] ^ io_in[22] ^ io_in[23] ^ io_in[24] ^ io_in[25] ^ io_in[26] ^ io_in[27]
                 ^ io_in[28] ^ io_in[29] ^ io_in[30] ^ io_in[31] ^ io_in[32] ^ io_in[33] ^ io_in[34]
                 ^ io_in[35] ^ io_in[36] ^ io_in[37];

assign io_out = {xor_output,5'b0,wbs_sel_i,data_out};
assign io_oeb = {38{1'b1}};
assign la_data_out =user_clock2? la_oenb:{wbs_adr, wbs_dat, wbs_dat, wbs_dat};

  // Register to store the Wishbone Slave address.
  reg [31:0] wbs_adr;

  // Register to store the Wishbone Slave data.
  reg [31:0] wbs_dat;

  // Register to store the Wishbone Slave write enable signal.
  reg wbs_we;

  // Wire to connect the Wishbone Slave acknowledge signal.
  // wire wbs_ack;
  // assign wbs_ack_o=wbs_ack;
  // Wire to connect the Wishbone Slave data output signal.
  // wire [31:0] wbs_dat_o;

  // Always block to write data to the Wishbone Slave.
  always @(posedge wb_clk_i) begin
    if (wb_rst_i) begin
      wbs_adr <= 0;
      wbs_dat <= 0;
      wbs_we <= 0;
    end else if (wbs_stb_i && wbs_cyc_i && !wbs_ack_o) begin
      wbs_adr <= wbs_adr_i;
      wbs_dat <= wbs_dat_i;
      wbs_we <= wbs_we_i;
    end
  end

  // Always block to read data from the Wishbone Slave.
  always @(posedge wb_clk_i) begin
    if (wb_rst_i) begin
      wbs_dat_o <= 0;
    end else wbs_ack_o <= (wbs_stb_i && wbs_cyc_i && !wbs_we && !wbs_ack_o) ? 1'b1 : 1'b0;
     if (wbs_stb_i && wbs_cyc_i && !wbs_we && !wbs_ack_o) begin
      wbs_dat_o <= wbs_dat;
     end
  end

  // Assign the Wishbone Slave acknowledge signal.
  // assign wbs_ack_o = (wbs_stb_i && wbs_cyc_i && !wbs_we && !wbs_ack_o) ? 1'b1 : 1'b0;



  // IRQ
 assign irq = 3'b000;	// Unused



assign data_in ={la_data_in,la_data_in};

mac Mac_unit( .data_in(data_in), .clk(clk),.reset(rst), .data_out(data_out));

endmodule


`default_nettype wire
