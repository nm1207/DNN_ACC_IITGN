`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2023 05:05:41 PM
// Design Name: 
// Module Name: DNNAcc
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


module DNNAcc(


    input clk,  //input clock
    input en,
   input reset,  //input reset 
   input RxD,  //input receving data line
   output TxD,  // output transmitting data line
   
   
   
    output logic [7:0] RxData,
    output logic isNewData,  //changes value 
    input [1:0] selPE,
    input sipo_en, sipo_en2, sp_din, sp_load, sp_load2,
    input ps_load,
    input selSPMode,
    output ps_out,
    output isNewWtin_tap, isNewDin_tap , din_tap, wtin_tap, addrDout_tap, ps_din_tap, sp_din_out_tap, sp_wt_out_tap,clk_i_tap, clk_f_tap, clk_p_tap,dout_tap_i, expOut_tap_p, mantOut_tap_p,expOut_tap_f,mantOut_tap_f,
enPE_tap,
    output logic [1:0] globalState_tap,
    output state1_tap,state2_tap,state3_tap
    );
    
//   logic [7:0] RxData;  // output for 8 bits data    
// logic isNewData ; //changes value 
  logic doTransmit;
  logic [7:0] TxData;
  logic isBusy;


//module PE_controller(clk,rst,en,din,isNewDin,wtin,isNewWtin,dout,addrDout,selPE

//    );
//parameter M =16; // depth of output buffer   
//parameter N =64; // depth of input buffer   
  
//input clk,rst,en;
//input isNewDin,isNewWtin;    
//input [16*16-1:0] din;   
//input [16*16*4-1:0]wtin;
//input [$clog2(M)-1:0] addrDout;
//input [1:0] selPE;
//output logic [47*4-1:0] dout;
parameter M =16; // depth of output buffer   
  
logic isNewDin,isNewWtin;    
logic [16*16-1:0] din;   
logic [16*16*4-1:0]wtin;
logic [$clog2(M)-1:0] addrDout;

logic [47*4-1:0] dout;


logic isNewDin1,isNewWtin1;    
logic [16*16-1:0] din1;   
logic [16*16*4-1:0]wtin1;
logic [$clog2(M)-1:0] addrDout1;

logic isNewDin2,isNewWtin2;    
logic [16*16-1:0] din2;   
logic [16*16*4-1:0]wtin2;
logic [$clog2(M)-1:0] addrDout2;



PE_controller pec(clk,reset,en,din,isNewDin,wtin,isNewWtin,dout,addrDout,selPE,clk_i_tap, clk_f_tap, clk_p_tap,dout_tap_i, expOut_tap_p, mantOut_tap_p,expOut_tap_f,mantOut_tap_f,
enPE_tap );

    
 Receiver #(.W5Frequency(100_000_000), .baudRate(230400)) R(

    clk,  //input clock
    ~reset,  //input reset 
    RxD,  //input receving data line
    RxData,  // output for 8 bits data
    isNewData  //changes value 
);


Sender #(.W5Frequency(100_000_000), .baudRate(230400)) S(
    clk, 
    ~reset,
    TxD,
    doTransmit,
    TxData,
    isBusy
);

//  output reg TxD;
//  input doTransmit;
//  input [7:0] TxData;
//  output reg isBusy;



UController C(clk ,~reset,RxData,isNewData, isBusy,TxData,doTransmit,
 isNewDin1,isNewWtin1,din1,wtin1,addrDout1,dout, globalState_tap);

logic [63:0] sp_din_out;
sipo sipo_din(clk,reset,sipo_en,sp_din,sp_load,sp_din_out);
logic [63:0] sp_wt_out;
sipo sipo_wt(clk,reset,sipo_en2,sp_din,sp_load2,sp_wt_out);
logic [63:0] ps_din;

piso ps(clk,reset,ps_din,ps_load, ps_out);


SPController SPC(clk ,~reset,sp_din_out,sp_load, sp_wt_out,sp_load2, ps_din,ps_load,
 isNewDin2,isNewWtin2,din2,wtin2,addrDout2,dout,
 state1_tap,state2_tap,state3_tap);

assign {isNewDin,isNewWtin,din,wtin,addrDout} = selSPMode? {isNewDin2,isNewWtin2,din2,wtin2,addrDout2} : {isNewDin1,isNewWtin1,din1,wtin1,addrDout1};

assign isNewWtin_tap = isNewWtin;
assign isNewDin_tap = isNewDin;
assign din_tap = din[0];
assign wtin_tap = wtin[0];
assign addrDout_tap = addrDout[0];
assign ps_din_tap = ps_din[0];
assign sp_din_out_tap = sp_din_out[0];
assign sp_wt_out_tap = sp_wt_out[0];
endmodule


