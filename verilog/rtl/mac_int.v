`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2023 23:55:30
// Design Name: 
// Module Name: memory
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

`define N_INT 16 
module mac_int (input [127:0] data_in,
input [127:0] weight_in,
input clk,
input [26:0]PP,
input reset,
 output reg [26:0] data_out);
reg [7:0]t[0:31];
wire [15:0]t1[0:15];
wire [255:0]t2;
wire [18:0]t3;
always@(posedge clk)
begin 
if(reset){t[31],t[30],t[29],t[28],t[27],t[26],t[25],t[24],t[23],t[22],t[21],t[20],t[19],t[18],t[17],t[16],t[15],t[14],t[13],t[12],t[11],t[10],t[9],t[8],t[7],t[6],t[5],t[4],t[3],t[2],t[1],t[0]}=0;
else 
begin
    {t[31],t[29],t[27],t[25],t[23],t[21],t[19],t[17],t[15],t[13],t[11],t[9],t[7],t[5],t[3],t[1]}=weight_in;
    {t[30],t[28],t[26],t[24],t[22],t[20],t[18],t[16],t[14],t[12],t[10],t[8],t[6],t[4],t[2],t[0]}=data_in;
end
end
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
if(reset)
data_out<=0;
else
    data_out<=t3+PP;
end

endmodule


  module AdderTree (
  input [`N_INT*16-1:0] data_in ,  // 16 8-bit data inputs
  output reg [`N_INT+2:0] sum_out    // 11-bit output
  );
  wire [`N_INT+2:0] out;
  wire [`N_INT:0] stage1_out [0:7];  // Outputs of the first stage adders
  wire [`N_INT+1:0] stage2_out [0:3];  // Outputs of the second stage adders
  wire [`N_INT+2:0] stage3_out [0:1];  // Outputs of the third stage adders
  wire [`N_INT-1:0] t [0:15];
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
    sum_out<=out;
  end

endmodule

/////////////////////////////////////////////////////////////////////////////////////////////////////



`define BufferDepthInt 64
module memory_int(
    input clk,
    input reset,
    input write_enable,// this signal is toggled when new data comes
    input read_enable,
    input [127:0] data_in,
    output reg [127:0] data_out,
    output reg [$clog2(`BufferDepthInt)-1:0] counter
    );
    reg prev_WE;
    reg [127:0] mem [`BufferDepthInt-1:0];
    
    
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




/////////////////////////////////////////////////////////////////////////////////////////////////////////////



module int_pe(
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
    output [26:0] data_out0,
    output [26:0] data_out1,
    output [26:0] data_out2,
    output [26:0] data_out3,
    output counter_tap,
    output dout_int_tap  
);

reg [26:0]pp0;
reg [26:0]pp1;
reg [26:0]pp2;
reg [26:0]pp3;

wire [127:0] weight_out0;
wire [127:0] weight_out1;
wire [127:0] weight_out2;
wire [127:0] weight_out3;

wire [$clog2(`BufferDepthInt)-1:0] counter0;
wire [$clog2(`BufferDepthInt)-1:0] counter1;
wire [$clog2(`BufferDepthInt)-1:0] counter2;
wire [$clog2(`BufferDepthInt)-1:0] counter3;

memory_int mem0(
    .clk(clk),
    .reset(reset),
    .write_enable(isNewWeight),// this signal is toggled when new data comes
    .read_enable(read_enable),
    .data_in(weight_in0),
    .data_out(weight_out0),
    .counter(counter0)
    );
    memory_int mem1(
    .clk(clk),
    .reset(reset),
    .write_enable(isNewWeight),// this signal is toggled when new data comes
    .read_enable(read_enable),
    .data_in(weight_in1),
    .data_out(weight_out1),
    .counter(counter1)
    );
    memory_int mem2(
    .clk(clk),
    .reset(reset),
    .write_enable(isNewWeight),// this signal is toggled when new data comes
    .read_enable(read_enable),
    .data_in(weight_in2),
    .data_out(weight_out2),
    .counter(counter2)
    );
    memory_int mem3(
    .clk(clk),
    .reset(reset),
    .write_enable(isNewWeight),// this signal is toggled when new data comes
    .read_enable(read_enable),
    .data_in(weight_in3),
    .data_out(weight_out3),
    .counter(counter3)
    );
    
    assign counter_tap = counter0[0];
    
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
            pp0 = data_out0;
            pp1 = data_out1;
            pp2 = data_out2;
            pp3 = data_out3;
        end
    end
end

mac_int m0 (
    .data_in(data_in),
    .weight_in(weight_out0),
    .clk(clk),
    .reset(reset),
    .PP(pp0),
    .data_out(data_out0)
    );
    
mac_int m1 (
    .data_in(data_in),
    .weight_in(weight_out1),
    .clk(clk),
    .reset(reset),
    .PP(pp0),
    .data_out(data_out1)
    );
    
mac_int m2 (
    .data_in(data_in),
    .weight_in(weight_out2),
    .clk(clk),
    .reset(reset),
    .PP(pp0),
    .data_out(data_out2)
    );
    
mac_int m3 (
    .data_in(data_in),
    .weight_in(weight_out3),
    .clk(clk),
    .reset(reset),
    .PP(pp3),
    .data_out(data_out3)
    );
    
    assign dout_int_tap = data_out0[0];

endmodule

