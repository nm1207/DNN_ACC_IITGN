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

`define N_AP 8
`define es_AP 4
`define operands 32
`define N_AP_exp 4
`define N_AP_add 12
module mac_ap (input [128-1:0] data_in,
input [128-1:0] weight_in,
input clk,
input reset,
input [`N_AP_add+2:0]PP,
output reg [`es_AP-1:0] data_out_exp,
output reg [`N_AP_add+2:0] data_out_mant);
reg [`N_AP-1:0]t[0:31];
wire [`es_AP-1:0]t1[0:15]; 
wire [(`operands*`es_AP/2)-1:0]t2;
wire [`es_AP-1:0]t3;
wire [`N_AP_add+2:0]t4;
wire [(`N_AP-`es_AP)*2-1:0]t5[0:15];
wire [(`N_AP-`es_AP)*`operands-1:0]t6;

always@(posedge clk)
//starting flip flop


begin
if(reset) {t[31],t[30],t[29],t[28],t[27],t[26],t[25],t[24],t[23],t[22],t[21],t[20],t[19],t[18],t[17],t[16],t[15],t[14],t[13],t[12],t[11],t[10],t[9],t[8],t[7],t[6],t[5],t[4],t[3],t[2],t[1],t[0]}=0;
else 
begin
    {t[31],t[29],t[27],t[25],t[23],t[21],t[19],t[17],t[15],t[13],t[11],t[9],t[7],t[5],t[3],t[1]}=weight_in;
    {t[30],t[28],t[26],t[24],t[22],t[20],t[18],t[16],t[14],t[12],t[10],t[8],t[6],t[4],t[2],t[0]}=data_in;
end
end
//multipliers


pmult m1(.a(t[0]),.b(t[1]),.out_exp(t1[0]),.out_mant(t5[0]), .reset(reset));
pmult m2(.a(t[2]),.b(t[3]),.out_exp(t1[1]),.out_mant(t5[1]), .reset(reset));
pmult m3(.a(t[4]),.b(t[5]),.out_exp(t1[2]),.out_mant(t5[2]), .reset(reset));
pmult m4(.a(t[6]),.b(t[7]),.out_exp(t1[3]),.out_mant(t5[3]), .reset(reset));
pmult m5(.a(t[8]),.b(t[9]),.out_exp(t1[4]),.out_mant(t5[4]), .reset(reset));
pmult m6(.a(t[10]),.b(t[11]),.out_exp(t1[5]),.out_mant(t5[5]), .reset(reset));
pmult m7(.a(t[12]),.b(t[13]),.out_exp(t1[6]),.out_mant(t5[6]), .reset(reset));
pmult m8(.a(t[14]),.b(t[15]),.out_exp(t1[7]),.out_mant(t5[7]), .reset(reset));
pmult m9(.a(t[16]),.b(t[17]),.out_exp(t1[8]),.out_mant(t5[8]), .reset(reset));
pmult m10(.a(t[18]),.b(t[19]),.out_exp(t1[9]),.out_mant(t5[9]), .reset(reset));
pmult m11(.a(t[20]),.b(t[21]),.out_exp(t1[10]),.out_mant(t5[10]), .reset(reset));
pmult m12(.a(t[22]),.b(t[23]),.out_exp(t1[11]),.out_mant(t5[11]), .reset(reset));
pmult m13(.a(t[24]),.b(t[25]),.out_exp(t1[12]),.out_mant(t5[12]), .reset(reset));
pmult m14(.a(t[26]),.b(t[27]),.out_exp(t1[13]),.out_mant(t5[13]), .reset(reset));
pmult m15(.a(t[28]),.b(t[29]),.out_exp(t1[14]),.out_mant(t5[14]), .reset(reset));
pmult m16(.a(t[30]),.b(t[31]),.out_exp(t1[15]),.out_mant(t5[15]), .reset(reset));
assign t2= {t1[15],t1[14],t1[13],t1[12],t1[11],t1[10],t1[9],t1[8],t1[7],t1[6],t1[5],t1[4],t1[3],t1[2],t1[1],t1[0]};
assign t6= {t1[15],t5[14],t5[13],t5[12],t5[11],t5[10],t5[9],t5[8],t5[7],t5[6],t5[5],t5[4],t5[3],t5[2],t5[1],t5[0]};
 wire [`N_AP_exp-1:0] max_exp;
 wire [`N_AP_exp-1:0] e [0:15];
 wire [(`N_AP-`es_AP)*2-1:0] m [0:15];
 wire [`N_AP_add-1:0] shift_m [0:15];
 wire [`N_AP_add+2:0] out;
 assign {e[15],e[14],e[13],e[12],e[11],e[10],e[9],e[8],e[7],e[6],e[5],e[4],e[3],e[2],e[1],e[0]}=t2;
 assign {m[15],m[14],m[13],m[12],m[11],m[10],m[9],m[8],m[7],m[6],m[5],m[4],m[3],m[2],m[1],m[0]}=t6;
 //comparator 


  /*wire [`N_AP_exp-1:0] te [0:15];
  assign {te[15],te[14],te[13],te[12],te[11],te[10],te[9],te[8],te[7],te[6],te[5],te[4],te[3],te[2],te[1],te[0]}=t2;
  reg [`N_AP_exp-1:0] temp_highest;
  // Initialize temp_highest with the first input number
  // Compare the input numbers and update temp_highest
  integer i;
  always @* begin
    temp_highest = t[0];
    for (i = 1; i < 16; i = i + 1) begin
      if (te[i] > temp_highest)
        temp_highest = te[i];
    end
  end*/
  reg [`es_AP-1:0] temp [0:15];
  reg [`es_AP-1:0] temp1 [0:7];
  reg [`es_AP-1:0] temp2 [0:3];
  reg [`es_AP-1:0] temp3 [0:1];
  reg [`es_AP-1:0] temp_highest;

  // Initialize temp_highest with the first input number
 
  
 always@(*)begin
  // Compare the input numbers and update temp_highest
  //generate
    // First stage
      {temp[15],temp[14],temp[13],temp[12],temp[11],temp[10],temp[9],temp[8],temp[7],temp[6],temp[5],temp[4],temp[3],temp[2],temp[1],temp[0]}=t2;
      if (temp[15] > temp[14])
        temp1[7] = temp[15];
      else
        temp1[7] = temp[14];
      if (temp[13] > temp[12])
        temp1[6] = temp[13];
      else
        temp1[6] = temp[12];
      if (temp[11] > temp[10])
        temp1[5] = temp[11];
      else
        temp1[5] = temp[10];
      if (temp[9] > temp[8])
        temp1[4] = temp[9];
      else
        temp1[4] = temp[8];
      if (temp[7] > temp[6])
        temp1[3] = temp[7];
      else
        temp1[3] = temp[6];
      if (temp[5] > temp[4])
        temp1[2] = temp[5];
      else
        temp1[2] = temp[4];
      if (temp[3] > temp[2])
        temp1[1] = temp[3];
      else
        temp1[1] = temp[2];
      if (temp[1] > temp[0])
        temp1[0] = temp[1];
      else
        temp1[0] = temp[0];
        
        

    //2nd Stage
      if (temp1[7] > temp1[6])
         temp2[3] = temp1[7];
      else
         temp2[3] = temp1[6];
      if (temp1[5] > temp1[4])
         temp2[2] = temp1[5];
      else
         temp2[2] = temp1[4];
      if (temp1[3] > temp1[2])
         temp2[1] = temp1[3];
      else
         temp2[1] = temp1[2];
      if (temp1[1] > temp1[0])
        temp2[0] = temp1[1];
      else
         temp2[0] = temp1[0];
    //3rd stage
      if (temp2[3] > temp2[2])
         temp3[1] = temp2[3];
      else
        temp3[1] = temp2[2];
        if (temp2[1] > temp2[0])
        temp3[0] = temp2[1];
      else
         temp3[0] = temp2[0];

    if (temp3[0] > temp3[1])
         temp_highest = t3[0];
      else
         temp_highest = t3[1];
 end

 assign max_exp=temp_highest;
 //shifters


 wire [11:0]te1;
 assign te1={m[0],4'b0};
 assign shift_m[0]=te1 >> (max_exp-e[0]);
 wire [11:0]te2;
 assign te2={m[1],4'b0};
 assign shift_m[1]=te2 >> (max_exp-e[1]);
 wire [11:0]te3;
 assign te3={m[2],4'b0};
 assign shift_m[2]=te3 >> (max_exp-e[2]);
 wire [11:0]te4;
 assign te4={m[3],4'b0};
 assign shift_m[3]=te4 >> (max_exp-e[3]);
 wire [11:0]te5;
 assign te5={m[4],4'b0};
 assign shift_m[4]=te5 >> (max_exp-e[4]);
 wire [11:0]te6;
 assign te6={m[5],4'b0};
 assign shift_m[5]=te6 >> (max_exp-e[5]);
 wire [11:0]te7;
 assign te7={m[6],4'b0};
 assign shift_m[6]=te7 >> (max_exp-e[6]);
 wire [11:0]te8;
 assign te8={m[7],4'b0};
 assign shift_m[7]=te8 >> (max_exp-e[7]);
 wire [11:0]te9;
 assign te9={m[8],4'b0};
 assign shift_m[8]=te9 >> (max_exp-e[8]);
 wire [11:0]te10;
 assign te10={m[9],4'b0};
 assign shift_m[9]=te10 >> (max_exp-e[9]);
 wire [11:0]te11;
 assign te11={m[10],4'b0};
 assign shift_m[10]=te11 >> (max_exp-e[10]);
 wire [11:0]te12;
 assign te12={m[11],4'b0};
 assign shift_m[11]=te12 >> (max_exp-e[11]);
 wire [11:0]te13;
 assign te13={m[12],4'b0};
 assign shift_m[12]=te13 >> (max_exp-e[12]);
 wire [11:0]te14;
 assign te14={m[13],4'b0};
 assign shift_m[13]=te14 >> (max_exp-e[13]);
 wire [11:0]te15;
 assign te15={m[14],4'b0};
 assign shift_m[14]=te15 >> (max_exp-e[14]);
 wire [11:0]te16;
 assign te16={m[15],4'b0};
 assign shift_m[15]=te16 >> (max_exp-e[15]);
 //adder tree


 wire [`N_AP_add*`operands/2-1:0]adder_i;
 assign adder_i={shift_m[15],shift_m[14],shift_m[13],shift_m[12],shift_m[11],shift_m[10],shift_m[9],shift_m[8],shift_m[7],shift_m[6],shift_m[5],shift_m[4],shift_m[3],shift_m[2],shift_m[1],shift_m[0]};
  wire [`N_AP_add:0] stage1_out [0:7];  // Outputs of the first stage adders
  wire [`N_AP_add+1:0] stage2_out [0:3];  // Outputs of the secoN_addd stage adders
  wire [`N_AP_add+2:0] stage3_out [0:1];  // Outputs of the third stage adders
  wire [`N_AP_add-1:0] te17 [0:15];
  assign {te17[15],te17[14],te17[13],te17[12],te17[11],te17[10],te17[9],te17[8],te17[7],te17[6],te17[5],te17[4],te17[3],te17[2],te17[1],te17[0]}=adder_i;
  genvar k;
  generate
    for (k = 0; k < 8; k = k + 1) begin : STAGE1
      assign stage1_out[k] = te17[2*k] + te17[2*k+1];
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
  assign t3=out;
   assign t4=max_exp;
   //final flip flop


always@(posedge clk)
if(reset)
begin
    data_out_exp<=`es_AP'b0;
    data_out_mant<=15'b0;    
end
else
begin
    data_out_exp<=t3;
    data_out_mant<=t4+PP;
end

endmodule


//---------posit multiplication------------------------
module pmult(a,b,out_exp,out_mant,reset);
    input [`N_AP-1:0]a,b;
    input reset;
    reg [`es_AP-1:0]OUT_exp;
    reg [(`N_AP-`es_AP)*2-1:0]OUT_mant;
    output reg [`es_AP-1:0]out_exp;
    output reg [(`N_AP-`es_AP)*2-1:0]out_mant;
    wire pinf,pzero;
    reg [`N_AP-1:0]x,y;
    reg [`N_AP+(`N_AP-`es_AP):0]OUT;
    wire [`N_AP-1:0]result;
    wire [2*(`N_AP-`es_AP)-1:0]mult_out;
    reg [`es_AP-1:0]t_out;
    wire psign;
    wire [`es_AP:0]a_exp,b_exp,t_exp;
    wire [`N_AP-`es_AP-2:0]pfrac;
    wire a_psign,b_psign;
    wire [`es_AP-1:0]a_pexp,b_pexp;
    wire [`N_AP-`es_AP-2:0]a_pfrac,b_pfrac;
    wire a_pzero,a_pinf,b_pzero,b_pinf;
    wire under_over;
    wire uo;



always@(*) begin
if(reset) begin
    x <= `N_AP'b0;
    y <= `N_AP'b0;
    out_exp <= 0;
    out_mant <= 0;	
    end
else begin
    x <= a;
    y <= b;
    out_exp <= OUT_exp;
    out_mant<=OUT_mant;
	end
end

    wire [`N_AP-2:0]x1;

//-----------------------sign----------------------
    assign a_psign = x[`N_AP-1];
    assign x1 = a_psign? ~x[`N_AP-2:0] + 1'b1: x[`N_AP-2:0];

//-----------------------inf\zero check----------------------
    assign a_pzero = a_psign ? 1'b0:( x1[`N_AP-2:0]==`N_AP-1'b0 ? 1'b1:1'b0);
    assign a_pinf = a_psign ? ( x1[`N_AP-2:0]==`N_AP-1'b0 ? 1'b1:1'b0):1'b0;

//-----------------------expo----------------------
    assign a_pexp = x1[`N_AP-2:`N_AP-`es_AP-1];
//-----------------------frac-----------------------
    assign a_pfrac = x1[`N_AP-`es_AP-2:0];
    wire [`N_AP-2:0]x2;

//-----------------------sign----------------------
    assign b_psign = y[`N_AP-1];
    assign x2 = b_psign? ~y[`N_AP-2:0] + 1'b1: y[`N_AP-2:0];

//-----------------------inf\zero check----------------------
    assign b_pzero = b_psign ? 1'b0:( x2[`N_AP-2:0]==`N_AP-1'b0 ? 1'b1:1'b0);
    assign b_pinf = b_psign ? ( x2[`N_AP-2:0]==`N_AP-1'b0 ? 1'b1:1'b0):1'b0;

//-----------------------expo----------------------
    assign b_pexp = x2[`N_AP-2:`N_AP-`es_AP-1];
//-----------------------frac-----------------------
    assign b_pfrac = x2[`N_AP-`es_AP-2:0];


    assign pinf = (a_pinf | b_pinf) ? 1'b1 : 1'b0;
    assign pzero = ~(a_pinf|b_pinf)&(a_pzero|b_pzero) ? 1'b1 : 1'b0;

//-----------------------sign----------------------
    assign psign = a_psign ^ b_psign;

//-----------------------frac----------------------
    assign mult_out={1'b1,a_pfrac}*{1'b1,b_pfrac};
    assign result[`N_AP-`es_AP-2:0] = mult_out;

//-----------------------total_exp----------------------
    assign a_exp =  a_pexp;
    assign b_exp =  b_pexp;
    assign t_exp = a_exp + b_exp + mult_out[2*(`N_AP-`es_AP)-1];
    assign under_over = t_exp[`es_AP];
    assign uo = under_over?1'b0:1'b1;

    assign result[`N_AP-2:`N_AP-`es_AP-1] = t_exp[`es_AP-1:0];

    assign result[`N_AP-2:`N_AP-`es_AP-1] = t_exp[`es_AP-1:0];
    assign result[`N_AP-1] = psign;
    always@(*) begin
        case(uo) 
	    1'b1 : OUT = psign ? 13'b1000000000000 : 13'b0000000000000;
        1'b0: OUT = (result[`N_AP-1]? {result[`N_AP-1],~result[`N_AP-2:0]+1'b1} : result);
        endcase
    end
    always@(*)
    begin
        OUT_exp=OUT[ `N_AP-2:`N_AP-`es_AP-1 ];
        OUT_mant=OUT[`N_AP-`es_AP-2:0 ];
    end
    

endmodule



/////////////////////////////////////////////////////////////////////////////////////////

`define BufferDepthAP 64
module memory_ap(
    input clk,
    input reset,
    input write_enable,// this signal is toggled when new data comes
    input read_enable,
    input [127:0] data_in,
    output reg [127:0] data_out
    );
    reg prev_WE;
    reg [127:0] mem [`BufferDepthAP-1:0];
    reg [$clog2(`BufferDepthAP)-1:0] counter;
    
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


//////////////////////////////////////////////////////////////////////////////
module ap_pe(
    input clk,
    input reset,
    input reset_pp, 
    input isNewWeight,
    input read_enable,
    input [127:0] data_in,
    input [127:0] weight_in0,
    input [127:0] weight_in1,
    input [127:0] weight_in2,
    input [127:0] weight_in3,
    output [18:0] data_out0,
    output [18:0] data_out1,
    output [18:0] data_out2,
    output [18:0] data_out3,
    output dout_exp_tap,
    output dout_mant_tap  
);

reg [14:0]pp0;
reg [14:0]pp1;
reg [14:0]pp2;
reg [14:0]pp3;

wire [14:0]data_out_mant0;
wire [14:0]data_out_mant1;
wire [14:0]data_out_mant2;
wire [14:0]data_out_mant3;

wire [3:0]data_out_exp0;
wire [3:0]data_out_exp1;
wire [3:0]data_out_exp2;
wire [3:0]data_out_exp3;

wire [127:0] weight_out0;
wire [127:0] weight_out1;
wire [127:0] weight_out2;
wire [127:0] weight_out3;
memory_ap mem0(
    .clk(clk),
    .reset(reset),
    .write_enable(isNewWeight),// this signal is toggled when new data comes
    .read_enable(read_enable),
    .data_in(weight_in0),
    .data_out(weight_out0)
    );
    memory_ap mem1(
    .clk(clk),
    .reset(reset),
    .write_enable(isNewWeight),// this signal is toggled when new data comes
    .read_enable(read_enable),
    .data_in(weight_in1),
    .data_out(weight_out1)
    );
    memory_ap mem2(
    .clk(clk),
    .reset(reset),
    .write_enable(isNewWeight),// this signal is toggled when new data comes
    .read_enable(read_enable),
    .data_in(weight_in2),
    .data_out(weight_out2)
    );
    memory_ap mem3(
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

mac_ap m0 (
    .data_in(data_in),
    .weight_in(weight_out0),
    .clk(clk),
    .reset(reset),
    .PP(pp0),
    .data_out_exp(data_out_exp0),
    .data_out_mant(data_out_mant0)
    );
    
mac_ap m1 (
    .data_in(data_in),
    .weight_in(weight_out1),
    .clk(clk),
    .reset(reset),
    .PP(pp0),
    .data_out_exp(data_out_exp1),
    .data_out_mant(data_out_mant1));
    
mac_ap m2 (
    .data_in(data_in),
    .weight_in(weight_out2),
    .clk(clk),
    .reset(reset),
    .PP(pp0),
    .data_out_exp(data_out_exp2),
    .data_out_mant(data_out_mant2));
    
mac_ap m3 (
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

