`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2023 12:04:58 AM
// Design Name: 
// Module Name: PE_controller
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


module PE_controller(clk,rst,en,din,isNewDin,wtin,isNewWtin,dout,addrDout,selPE, clk_i_tap, clk_f_tap, clk_p_tap,dout_tap_i, expOut_tap_p, mantOut_tap_p,expOut_tap_f,mantOut_tap_f,
enPE_tap

    );
parameter M =16; // depth of output buffer   
parameter N =64; // depth of input buffer   
  
input clk,rst,en;
input isNewDin,isNewWtin;    
input [16*16-1:0] din;   
input [16*16*4-1:0]wtin;
input [$clog2(M)-1:0] addrDout;
input [1:0] selPE;
output logic [47*4-1:0] dout;
output logic clk_i_tap, clk_f_tap, clk_p_tap;
output logic dout_tap_i, expOut_tap_p, mantOut_tap_p,expOut_tap_f,mantOut_tap_f, enPE_tap; 

logic [16*16-1:0] inBuff [N-1:0];
logic [47*4-1:0] outBuff [M-1:0];



logic [47*4-1:0] doutPE;
logic enPE;
logic old_isNewDin;
logic [$clog2(N)-1:0] i_counter;
logic [$clog2(N)-1:0] j_counter;
logic [$clog2(M)-1:0] k_counter;
logic [16*16-1:0] PEin;


logic reset_pp;

always_ff @(posedge clk) begin
    if(!rst) begin
        dout =0;
    end
    else begin
        if (en) begin
            dout = outBuff[addrDout];
        end
    end
end



always_ff @(posedge clk) begin
    if(!rst) begin
        i_counter =0;
        old_isNewDin = 0;
        enPE =0;
        j_counter=0;
        PEin = 0;
        k_counter=0;
        reset_pp=0;
    end
    else begin 
        if (en) begin
            if(enPE) begin
                PEin = inBuff[j_counter];
                j_counter= j_counter+1;
                reset_pp = 0;
                if (j_counter==0) begin
                    outBuff[k_counter] = doutPE;
                    reset_pp =1;
                    k_counter = k_counter+1;
                 end
            end
            if (isNewDin !=old_isNewDin) begin
                inBuff[i_counter]= din;
                if(i_counter==N-1) enPE=1;
                i_counter = i_counter+1;
                old_isNewDin = isNewDin;
            end
            
        end
        
    end
end

// clock gating
logic clk_i,clk_p,clk_f;

assign clk_i = clk& ~selPE[1]& selPE[0];
assign clk_p = clk& selPE[1]& ~selPE[0];
assign clk_f = clk& selPE[1]& selPE[0];

assign clk_i_tap = clk_i;
assign clk_p_tap = clk_p;
assign clk_f_tap = clk_f;

logic [127:0] weight_in0_i;
logic [127:0] weight_in1_i;
logic [127:0] weight_in2_i;
logic [127:0] weight_in3_i;
logic [26:0] data_out0_i;
logic [26:0] data_out1_i;
logic [26:0] data_out2_i;
logic [26:0] data_out3_i;
logic [47*4-1:0] doutPE_i;
assign {weight_in3_i,weight_in2_i,weight_in1_i,weight_in0_i} = wtin;
assign doutPE_i = {data_out3_i,data_out2_i,data_out1_i,data_out0_i};
//module int_pe(
//    input clk,
//    input reset,
//    input reset_pp, 
//    input isNewWeight,
//    input read_enable,
//    input [127:0] data_in,
//    input [127:0] weight_in0,
//    input [127:0] weight_in1,
//    input [127:0] weight_in2,
//    input [127:0] weight_in3,
//    output [26:0] data_out0,
//    output [26:0] data_out1,
//    output [26:0] data_out2,
//    output [26:0] data_out3  
//);
 int_pe pe_int(
     clk_i,
     rst,
     reset_pp, 
     isNewWtin,
     enPE,
     PEin[127:0],
     weight_in0_i,
     weight_in1_i,
     weight_in2_i,
     weight_in3_i,
     data_out0_i,
     data_out1_i,
     data_out2_i,
     data_out3_i,
     counter_tap,
     dout_tap_i  
);



logic [127:0] weight_in0_p;
logic [127:0] weight_in1_p;
logic [127:0] weight_in2_p;
logic [127:0] weight_in3_p;
logic [18:0] data_out0_p;
logic [18:0] data_out1_p;
logic [18:0] data_out2_p;
logic [18:0] data_out3_p;
logic [47*4-1:0] doutPE_p;
assign {weight_in3_p,weight_in2_p,weight_in1_p,weight_in0_p} = wtin;
assign doutPE_p = {data_out3_p,data_out2_p,data_out1_p,data_out0_p};
//module ap_pe(
//    input clk,
//    input reset,
//    input reset_pp, 
//    input isNewWeight,
//    input read_enable,
//    input [127:0] data_in,
//    input [127:0] weight_in0,
//    input [127:0] weight_in1,
//    input [127:0] weight_in2,
//    input [127:0] weight_in3,
//    output [18:0] data_out0,
//    output [18:0] data_out1,
//    output [18:0] data_out2,
//    output [18:0] data_out3  
//);

 ap_pe pe_ap(
     clk_p,
     rst,
     reset_pp, 
     isNewWtin,
     enPE,
     PEin[127:0],
     weight_in0_p,
     weight_in1_p,
     weight_in2_p,
     weight_in3_p,
     data_out0_p,
     data_out1_p,
     data_out2_p,
     data_out3_p,
     expOut_tap_p,
     mantOut_tap_p 
);



logic [255:0] weight_in0_f;
logic [255:0] weight_in1_f;
logic [255:0] weight_in2_f;
logic [255:0] weight_in3_f;
logic [46:0] data_out0_f;
logic [46:0] data_out1_f;
logic [46:0] data_out2_f;
logic [46:0] data_out3_f;
logic [47*4-1:0] doutPE_f;
assign {weight_in3_f,weight_in2_f,weight_in1_f,weight_in0_f} = wtin;
assign doutPE_f = {data_out3_f,data_out2_f,data_out1_f,data_out0_f};
//module fp_pe(
//    input clk,
//    input reset,
//    input reset_pp, 
//    input isNewWeight,
//    input read_enable,
//    input [255:0] data_in,
//    input [255:0] weight_in0,
//    input [255:0] weight_in1,
//    input [255:0] weight_in2,
//    input [255:0] weight_in3,
//    output [46:0] data_out0,
//    output [46:0] data_out1,
//    output [46:0] data_out2,
//    output [46:0] data_out3  
//);
 fp_pe pe_fp(
     clk_f,
     rst,
     reset_pp, 
     isNewWtin,
     enPE,
     PEin[127:0],
     weight_in0_f,
     weight_in1_f,
     weight_in2_f,
     weight_in3_f,
     data_out0_f,
     data_out1_f,
     data_out2_f,
     data_out3_f,
     expOut_tap_f,
     mantOut_tap_f  
);

assign doutPE=selPE[1]? (selPE[0]? doutPE_f:doutPE_p) : (selPE[0]? doutPE_i:13303);
assign enPE_tap = enPE;
endmodule

