`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module top_DNNAcc(


    input clk2,  //input clock
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
    output isNewWtin_tap, isNewDin_tap , in_tap, wtin_tap, addrDout_tap, ps_din_tap, sp_din_out_tap, sp_wt_out_tap,clk_i_tap, clk_f_tap, clk_p_tap,dout_tap_i, expOut_tap_p, mantOut_tap_p,expOut_tap_f,mantOut_tap_f,
enPE_tap,
    output logic [1:0] globalState_tap,
    
    
  input clk1,
  input RxD_V,
  output TxD_V,
  output clk_tap,
  output isBusy_tap,
  output isNewData_tap,
  output TxData_tap,
  output RxData_tap,
    
    input selClk,
    
    output state1_tap,state2_tap,state3_tap 
    );

logic clk;

 Main acc_V(
    clk,  //input clock
    reset,  //input reset 
    RxD_V,  //input receving data line
    TxD_V,
    clk_tap,
    isBusy_tap,
    isNewData_tap,
    TxData_tap,
    RxData_tap

);

DNNAcc Acc_2(


     clk,  //input clock
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
     isNewWtin_tap, isNewDin_tap , in_tap, wtin_tap, addrDout_tap, ps_din_tap, sp_din_out_tap, sp_wt_out_tap,clk_i_tap, clk_f_tap, clk_p_tap,dout_tap_i, expOut_tap_p, mantOut_tap_p,expOut_tap_f,mantOut_tap_f,
enPE_tap,
      globalState_tap,
       state1_tap,state2_tap,state3_tap
    );
    




assign clk = selClk? clk2:clk1;


endmodule

