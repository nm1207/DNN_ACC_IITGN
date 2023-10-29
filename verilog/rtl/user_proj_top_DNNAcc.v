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

module user_proj_top_DNNAcc #(
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
    


wire clk2;  //wire clock
wire en;
wire reset;  //wire reset 
wire RxD;  //wire receving data line
wire TxD;  // wire transmitting data line



wire  [7:0] RxData;
wire  isNewData;  //changes value 
wire [1:0] selPE;
wire sipo_en, sipo_en2, sp_din, sp_load, sp_load2;
wire ps_load;
wire selSPMode;
wire ps_out;
wire isNewWtin_tap, isNewDin_tap , din_tap, wtin_tap, addrDout_tap, ps_din_tap, sp_din_out_tap, sp_wt_out_tap,clk_i_tap, clk_f_tap, clk_p_tap,dout_tap_i, expOut_tap_p, mantOut_tap_p,expOut_tap_f,mantOut_tap_f, enPE_tap;
wire [1:0] globalState_tap;


wire clk1;
wire RxD_V;
wire TxD_V;
wire clk_tap;
wire isBusy_tap;
wire isNewData_tap;
wire TxData_tap;
wire RxData_tap;

wire selClk;

wire state1_tap,state2_tap,state3_tap ;


// inputs
assign clk2 = user_clock2;
assign {clk1, selClk, reset,RxD, selPE[1], selPE[0], RxD_V, sipo_en, sipo_en2, sp_din, sp_load, sp_load2,ps_load, selSPMode,en} = {io_in[18:5],io_in[37]};
assign {io_oeb[18:5],io_oeb[37]} = {15{1'b1}};

// outputs
assign {io_oeb[36:19],io_oeb[4:0]} = 23'b0;

// assign io_oeb = {38{1'b1}};  // 0 for output , 1 for input
//assign la_oenb[15:0] = 16'b0;

assign {TxD, RxData, isNewData, ps_out, TxD_V, isNewWtin_tap, isNewDin_tap, din_tap, wtin_tap, addrDout_tap, ps_din_tap, sp_din_out_tap, sp_wt_out_tap, clk_i_tap, clk_f_tap, clk_p_tap } = {io_out[36:19], io_out[4:0]};
assign { dout_tap_i, expOut_tap_p, mantOut_tap_p,expOut_tap_f,mantOut_tap_f, enPE_tap, globalState_tap,  clk_tap, isBusy_tap, isNewData_tap, TxData_tap, RxData_tap, state1_tap, state2_tap, state3_tap} = la_data_out[15:0];




  // IRQ
 assign irq = 3'b000;	// Unused




// mac Mac_unit( .data_in(data_in), .clk(clk),.reset(rst), .data_out(data_out));
top_DNNAcc top_Acc(


     clk2,  //input clock
     en,
    reset,  //input reset 
    RxD,  //input receving data line
    TxD,  // output transmitting data line
   
   
   
      RxData,
     isNewData,  //changes value 
     selPE,
     sipo_en, sipo_en2, sp_din, sp_load, sp_load2,
     ps_load,
     selSPMode,
     ps_out,
     isNewWtin_tap, isNewDin_tap , din_tap, wtin_tap, addrDout_tap, ps_din_tap, sp_din_out_tap, sp_wt_out_tap,clk_i_tap, clk_f_tap, clk_p_tap,dout_tap_i, expOut_tap_p, mantOut_tap_p,expOut_tap_f,mantOut_tap_f,
enPE_tap,
     globalState_tap,
    
    
   clk1,
   RxD_V,
   TxD_V,
   clk_tap,
   isBusy_tap,
   isNewData_tap,
   TxData_tap,
   RxData_tap,
    
     selClk,
    
     state1_tap,state2_tap,state3_tap 
    );

endmodule


`default_nettype wire
