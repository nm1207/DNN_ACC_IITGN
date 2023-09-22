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



module mac (input [255:0] data_in,
input clk,reset,
 output reg [27:0] data_out);
wire [7:0]t[0:31];
wire [15:0]t1[0:15];
wire [255:0]t2;
wire [18:0]t3;
assign {t[31],t[30],t[29],t[28],t[27],t[26],t[25],t[24],t[23],t[22],t[21],t[20],t[19],t[18],t[17],t[16],t[15],t[14],t[13],t[12],t[11],t[10],t[9],t[8],t[7],t[6],t[5],t[4],t[3],t[2],t[1],t[0]}=data_in;
assign t1[0]=t[0]*t[1];
assign t1[1]=t[2]*t[3];
assign t1[2]=t[4]*t[5];
assign t1[3]=t[6]*t[7];
assign t1[4]=t[8]*t[9];
assign t1[5]=t[10]*t[11];
assign t1[6]=t[12]*t[13];
assign t1[7]=t[14]*t[15];
assign t1[8]=t[16]*t[17];
assign t1[9]=t[18]*t[19];
assign t1[10]=t[20]*t[21];
assign t1[11]=t[22]*t[23];
assign t1[12]=t[24]*t[25];
assign t1[13]=t[26]*t[27];
assign t1[14]=t[28]*t[29];
assign t1[15]=t[30]*t[31];
assign t2= {t1[15],t1[14],t1[13],t1[12],t1[11],t1[10],t1[9],t1[8],t1[7],t1[6],t1[5],t1[4],t1[3],t1[2],t1[1],t1[0]};
AdderTree a1(.data_in(t2),.sum_out(t3));
always@(posedge clk)
begin
   if(!reset) data_out=0;
    else data_out=t3+data_out;
end

endmodule


  module AdderTree (
  input [16*16-1:0] data_in ,  // 16 8-bit data inputs
  output reg [16+2:0] sum_out    // 11-bit output
  );
  wire [16+2:0] out;
  wire [16:0] stage1_out [0:7];  // Outputs of the first stage adders
  wire [16+1:0] stage2_out [0:3];  // Outputs of the second stage adders
  wire [16+2:0] stage3_out [0:1];  // Outputs of the third stage adders
  wire [16-1:0] t [0:15];
  assign {t[15],t[14],t[13],t[12],t[11],t[10],t[9],t[8],t[7],t[6],t[5],t[4],t[3],t[2],t[1],t[0]}=data_in;
  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : STAGE1
      assign stage1_out[i] = t[2*i] + t[2*i+1];
    end
  endgenerate

  // Second stage: 4 adders
  genvar j;
  generate
    for (j = 0; j < 4; j = j + 1) begin : STAGE2
      assign stage2_out[j] = stage1_out[2*j] + stage1_out[2*j+1];
    end
  endgenerate

  // Third stage: 2 adders
  assign stage3_out[0] = stage2_out[0] + stage2_out[1];
  assign stage3_out[1] = stage2_out[2] + stage2_out[3];

  // Final stage: 1 adder
  assign out = stage3_out[0] + stage3_out[1];
  always@(*)
  begin
    sum_out=out;
  end

endmodule

