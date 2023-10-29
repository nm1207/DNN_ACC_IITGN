`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2023 03:33:40 AM
// Design Name: 
// Module Name: ap_pe
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`define BufferDepthFP 64
module memory_fp(
    input clk,
    input reset,
    input write_enable,// this signal is toggled when new data comes
    input read_enable,
    input [255:0] data_in,
    output reg [255:0] data_out
    );
    reg prev_WE;
    reg [255:0] mem [`BufferDepthFP-1:0];
    reg [$clog2(`BufferDepthFP)-1:0] counter;
    
    always @(posedge clk)
    begin
    if (!reset)
    begin
        data_out = 1'b0;
        counter = 0; 
        prev_WE =0;   
    end    
    else
    begin
        if(write_enable !=prev_WE)
        begin
            mem[counter] = data_in;
            counter = counter +1;
        end
        //else
        //    counter <= counter;
        else if(read_enable)
        begin
            data_out = mem[counter];
            counter = counter+1;
        end
        else
            counter = counter;
        prev_WE =write_enable;
    end
    end
endmodule





//////////////////////////////////////////////////////////////////////////////////

`define P_FP 8
`define N_FP 16 
`define N_FP_exp 10
`define N_FP_add 24
module mac_fp (input [255:0] data_in,
input [255:0] weight_in,
input clk,
input reset,
input [30:0]PP,
output reg [15:0] data_out_exp,
output reg [30:0] data_out_mant);
reg [15:0]t[0:31];
wire [9:0]t1[0:15];
wire [159:0]t2;
wire [7:0]t3;
wire [22:0]t4;
wire [15:0]t5[0:15];
wire [255:0]t6;

always@(posedge clk) 
	begin
		if(!reset) {t[31],t[30],t[29],t[28],t[27],t[26],t[25],t[24],t[23],t[22],t[21],t[20],t[19],t[18],t[17],t[16],t[15],t[14],t[13],t[12],t[11],t[10],t[9],t[8],t[7],t[6],t[5],t[4],t[3],t[2],t[1],t[0]}=0;
		else
		  begin
		      {t[31],t[29],t[27],t[25],t[23],t[21],t[19],t[17],t[15],t[13],t[11],t[9],t[7],t[5],t[3],t[1]}=weight_in;
		      {t[30],t[28],t[26],t[24],t[22],t[20],t[18],t[16],t[14],t[12],t[10],t[8],t[6],t[4],t[2],t[0]}=data_in;
		  end
		      
	end

top_fp_mul_N16_M7_E8 m1(.a1(t[0]),.b1(t[1]),.y_exp(t1[0]),.y_mant(t5[0]));
top_fp_mul_N16_M7_E8 m2(.a1(t[2]),.b1(t[3]),.y_exp(t1[1]),.y_mant(t5[1]));
top_fp_mul_N16_M7_E8 m3(.a1(t[4]),.b1(t[5]),.y_exp(t1[2]),.y_mant(t5[2]));
top_fp_mul_N16_M7_E8 m4(.a1(t[6]),.b1(t[7]),.y_exp(t1[3]),.y_mant(t5[3]));
top_fp_mul_N16_M7_E8 m5(.a1(t[8]),.b1(t[8]),.y_exp(t1[4]),.y_mant(t5[4]));
top_fp_mul_N16_M7_E8 m6(.a1(t[10]),.b1(t[11]),.y_exp(t1[5]),.y_mant(t5[5]));
top_fp_mul_N16_M7_E8 m7(.a1(t[12]),.b1(t[13]),.y_exp(t1[6]),.y_mant(t5[6]));
top_fp_mul_N16_M7_E8 m8(.a1(t[14]),.b1(t[15]),.y_exp(t1[7]),.y_mant(t5[7]));
top_fp_mul_N16_M7_E8 m9(.a1(t[16]),.b1(t[17]),.y_exp(t1[8]),.y_mant(t5[8]));
top_fp_mul_N16_M7_E8 m10(.a1(t[18]),.b1(t[19]),.y_exp(t1[9]),.y_mant(t5[9]));
top_fp_mul_N16_M7_E8 m11(.a1(t[20]),.b1(t[21]),.y_exp(t1[10]),.y_mant(t5[10]));
top_fp_mul_N16_M7_E8 m12(.a1(t[22]),.b1(t[23]),.y_exp(t1[11]),.y_mant(t5[11]));
top_fp_mul_N16_M7_E8 m13(.a1(t[24]),.b1(t[25]),.y_exp(t1[12]),.y_mant(t5[12]));
top_fp_mul_N16_M7_E8 m14(.a1(t[26]),.b1(t[27]),.y_exp(t1[13]),.y_mant(t5[13]));
top_fp_mul_N16_M7_E8 m15(.a1(t[28]),.b1(t[29]),.y_exp(t1[14]),.y_mant(t5[14]));
top_fp_mul_N16_M7_E8 m16(.a1(t[30]),.b1(t[31]),.y_exp(t1[15]),.y_mant(t5[15]));
assign t2= {t1[15],t1[14],t1[13],t1[12],t1[11],t1[10],t1[9],t1[8],t1[7],t1[6],t1[5],t1[4],t1[3],t1[2],t1[1],t1[0]};
assign t6= {t1[15],t5[14],t5[13],t5[12],t5[11],t5[10],t5[9],t5[8],t5[7],t5[6],t5[5],t5[4],t5[3],t5[2],t5[1],t5[0]};
top_f dut(.exponent(t2),.mantissa(t6),.final_exp(t3),.final_mant(t4));
always@(posedge clk)
if(reset)
begin
    data_out_exp<=16'b0;
    data_out_mant<=31'b0;    
end
else
begin
    data_out_exp<=t3;
    data_out_mant<=t4+PP;
end

endmodule


 module top_f(input [159:0]exponent,
 input [255:0]mantissa,
 output reg [7:0] final_exp,
 output reg [22:0] final_mant );
 wire [`N_FP_exp-1:0] max_exp;
 wire [`N_FP_exp-1:0] e [0:15];
 wire [15:0] m [0:15];
 wire [`N_FP_add-1:0] shift_m [0:15];
 wire [26:0] out;
 assign {e[15],e[14],e[13],e[12],e[11],e[10],e[9],e[8],e[7],e[6],e[5],e[4],e[3],e[2],e[1],e[0]}=exponent;
 assign {m[15],m[14],m[13],m[12],m[11],m[10],m[9],m[8],m[7],m[6],m[5],m[4],m[3],m[2],m[1],m[0]}=mantissa; 
 Comparator c1(.numbers(exponent),.clk(clk),.highest(max_exp));
 shifter s1(.low(e[0]),.high(max_exp),.num(m[0]),.shift_num(shift_m[0]));
 shifter s2(.low(e[1]),.high(max_exp),.num(m[1]),.shift_num(shift_m[1]));
 shifter s3(.low(e[2]),.high(max_exp),.num(m[2]),.shift_num(shift_m[2]));
 shifter s4(.low(e[3]),.high(max_exp),.num(m[3]),.shift_num(shift_m[3]));
 shifter s5(.low(e[4]),.high(max_exp),.num(m[4]),.shift_num(shift_m[4]));
 shifter s6(.low(e[5]),.high(max_exp),.num(m[5]),.shift_num(shift_m[5]));
 shifter s7(.low(e[6]),.high(max_exp),.num(m[6]),.shift_num(shift_m[6]));
 shifter s8(.low(e[7]),.high(max_exp),.num(m[7]),.shift_num(shift_m[7]));
 shifter s9(.low(e[8]),.high(max_exp),.num(m[8]),.shift_num(shift_m[8]));
 shifter s10(.low(e[9]),.high(max_exp),.num(m[9]),.shift_num(shift_m[9]));
 shifter s11(.low(e[10]),.high(max_exp),.num(m[10]),.shift_num(shift_m[10]));
 shifter s12(.low(e[11]),.high(max_exp),.num(m[11]),.shift_num(shift_m[11]));
 shifter s13(.low(e[12]),.high(max_exp),.num(m[12]),.shift_num(shift_m[12]));
 shifter s14(.low(e[13]),.high(max_exp),.num(m[13]),.shift_num(shift_m[13]));
 shifter s15(.low(e[14]),.high(max_exp),.num(m[14]),.shift_num(shift_m[14]));
 shifter s16(.low(e[15]),.high(max_exp),.num(m[15]),.shift_num(shift_m[15]));
 wire [383:0]adder_i;
 assign adder_i={shift_m[15],shift_m[14],shift_m[13],shift_m[12],shift_m[11],shift_m[10],shift_m[9],shift_m[8],shift_m[7],shift_m[6],shift_m[5],shift_m[4],shift_m[3],shift_m[2],shift_m[1],shift_m[0]};
 AdderTree_FP a1(.clk(clk),.data_in(adder_i),.sum_out(out));
 always @(*) begin
    final_mant<=out[26:4];
    final_exp<=max_exp[7:0];
 end
 endmodule
 
 module shifter (input [`N_FP_exp-1:0]low,
 input [`N_FP_exp-1:0]high,
 input [15:0]num,
 output reg [23:0]shift_num); 
 wire [7:0]shift_amount;
 wire [23:0] temp;
 assign temp={num,8'b0} ;
 assign shift_amount= high-low;
 always @* begin
      shift_num = temp >> shift_amount;  // Perform the right shift operation
  end
 endmodule
 module Comparator (
  input [`N_FP_exp*16-1:0] numbers ,  // 16 input numbers
  output reg [`N_FP_exp-1:0] highest,       // Output for the highest number
  input clk
);
  wire [`N_FP_exp-1:0] t [0:15];
  assign {t[15],t[14],t[13],t[12],t[11],t[10],t[9],t[8],t[7],t[6],t[5],t[4],t[3],t[2],t[1],t[0]}=numbers;
  reg [`N_FP_exp-1:0] temp_highest;

  // Initialize temp_highest with the first input number
  
  

  // Compare the input numbers and update temp_highest
  integer i;
  always @* begin
    temp_highest = t[0];
    for (i = 1; i < 16; i = i + 1) begin
      if (t[i] > temp_highest)
        temp_highest = t[i];
    end
  end

  // Assign temp_highest to the output
  always @*begin
    highest <= temp_highest;
  end

endmodule 
  module AdderTree_FP (
  input [`N_FP_add*16-1:0] data_in ,  // 16 8-bit data inputs
  output reg [`N_FP_add+2:0] sum_out,    // 11-bit output
  input clk
  );
  wire [`N_FP_add+2:0] out;
  wire [`N_FP_add:0] stage1_out [0:7];  // Outputs of the first stage adders
  wire [`N_FP_add+1:0] stage2_out [0:3];  // Outputs of the secoN_addd stage adders
  wire [`N_FP_add+2:0] stage3_out [0:1];  // Outputs of the third stage adders
  wire [`N_FP_add-1:0] t [0:15];
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
  always@*
  begin
    sum_out<=out;
  end

endmodule

`define N       16
`define E       8
`define MA      7

// indices of components of IEEE 754 FP
`define SIGN   	15
`define EXP    	14:7
`define M    	6:0

`define P    	8    // number of bits for mantissa (including 
`define G    	7    // guard bit index
`define R    	6    // round bit index
`define S    	5:0  // sticky bits range

`define BIAS   	127


module top_fp_mul_N16_M7_E8(input  wire[`N-1:0] a1,
              input  wire[`N-1:0] b1,
              output reg[9:0] y_exp,
              output reg[15:0] y_mant);

  reg [`P-2:0] m;
  reg [`E:0] e;
  reg s;
  
  reg [`P*2-1:0] product;
  reg G;
  reg R;
  reg S;
  reg normalized;


  reg [`N-1:0] a,b;
  wire [15:0] y1;
  wire [9:0] y2;


  always @(*) begin
      a = {a1};
      b = {b1};
      y_exp = y2;
      y_mant =y1; 
  end


  always @(*) begin
      //$monitor("product = %b, S = %b, s = %b, m = %b, e = %b", product, S,s,m,e);
      // mantissa is product of a and b's mantissas, 
      // with a 1 added as the MSB to each
      product = {1'b1, a[`M]} * {1'b1, b[`M]};

      // get sticky bits by ORing together all bits right of R
      S = |product[`S]; 

      // if the MSB of the resulting product is 0
      // normalize by shifting right    
      normalized = product[2*`MA+1];
      
      if(!normalized) product = product << 1; 
      else product = product;
      

      // sign is xor of signs
      s = a[`SIGN] ^ b[`SIGN];

      // mantissa is upper 22-bits of product w/ nearest-even rounding
      m = product;

      // exponent is sum of a and b's exponents, minus the bias 
      // if the mantissa was shifted, increment the exponent to balance it
      e = a[`EXP] + b[`EXP] - `BIAS + normalized;

  end

  // output is concatenation of sign, exponent, and mantissa    
  assign y1 = m;
  assign y2 = {e[8],e};

endmodule 






//////////////////////////////////////////////////////////////////////////////////

module fp_pe(
    input clk,
    input reset,
    input reset_pp, 
    input isNewWeight,
    input read_enable,
    input [255:0] data_in,
    input [255:0] weight_in0,
    input [255:0] weight_in1,
    input [255:0] weight_in2,
    input [255:0] weight_in3,
    output [46:0] data_out0,
    output [46:0] data_out1,
    output [46:0] data_out2,
    output [46:0] data_out3,
    output dout_exp_tap,
    output dout_mant_tap  
);

reg [30:0]pp0;
reg [30:0]pp1;
reg [30:0]pp2;
reg [30:0]pp3;

wire [30:0]data_out_mant0;
wire [30:0]data_out_mant1;
wire [30:0]data_out_mant2;
wire [30:0]data_out_mant3;

wire [15:0]data_out_exp0;
wire [15:0]data_out_exp1;
wire [15:0]data_out_exp2;
wire [15:0]data_out_exp3;

wire [255:0] weight_out0;
wire [255:0] weight_out1;
wire [255:0] weight_out2;
wire [255:0] weight_out3;
memory_fp mem0(
    .clk(clk),
    .reset(reset),
    .write_enable(isNewWeight),// this signal is toggled when new data comes
    .read_enable(read_enable),
    .data_in(weight_in0),
    .data_out(weight_out0)
    );
    memory_fp mem1(
    .clk(clk),
    .reset(reset),
    .write_enable(isNewWeight),// this signal is toggled when new data comes
    .read_enable(read_enable),
    .data_in(weight_in1),
    .data_out(weight_out1)
    );
    memory_fp mem2(
    .clk(clk),
    .reset(reset),
    .write_enable(isNewWeight),// this signal is toggled when new data comes
    .read_enable(read_enable),
    .data_in(weight_in2),
    .data_out(weight_out2)
    );
    memory_fp mem3(
    .clk(clk),
    .reset(reset),
    .write_enable(isNewWeight),// this signal is toggled when new data comes
    .read_enable(read_enable),
    .data_in(weight_in3),
    .data_out(weight_out3)
    );
always @(posedge clk)
begin
    if(!reset)
    begin
        pp0 = 0;
        pp1 = 0;
        pp2 = 0;
        pp3 = 0;  
    end   
    else 
    begin
        if(reset_pp)
        begin
            pp0 = 0;
            pp1 = 0;
            pp2 = 0;
            pp3 = 0;
        end
        else
        begin
            pp0 = data_out_mant0;
            pp1 = data_out_mant1;
            pp2 = data_out_mant2;
            pp3 = data_out_mant3;
        end
    end
end

mac_fp m0 (
    .data_in(data_in),
    .weight_in(weight_out0),
    .clk(clk),
    .reset(reset),
    .PP(pp0),
    .data_out_exp(data_out_exp0),
    .data_out_mant(data_out_mant0)
    );
    
mac_fp m1 (
    .data_in(data_in),
    .weight_in(weight_out1),
    .clk(clk),
    .reset(reset),
    .PP(pp0),
    .data_out_exp(data_out_exp1),
    .data_out_mant(data_out_mant1));
    
mac_fp m2 (
    .data_in(data_in),
    .weight_in(weight_out2),
    .clk(clk),
    .reset(reset),
    .PP(pp0),
    .data_out_exp(data_out_exp2),
    .data_out_mant(data_out_mant2));
    
mac_fp m3 (
    .data_in(data_in),
    .weight_in(weight_out3),
    .clk(clk),
    .reset(reset),
    .PP(pp3),
    .data_out_exp(data_out_exp3),
    .data_out_mant(data_out_mant3));
    
assign data_out0 = {data_out_exp0, data_out_mant0};
assign data_out1 = {data_out_exp1, data_out_mant1};
assign data_out2 = {data_out_exp2, data_out_mant2};
assign data_out3 = {data_out_exp3, data_out_mant3};

assign dout_exp_tap = data_out_exp0[0];
assign dout_mant_tap = data_out_mant0[0];
endmodule

