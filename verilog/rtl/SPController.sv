`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2023 06:07:06 AM
// Design Name: 
// Module Name: SPController
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

module SPController(clk ,reset,sp_din_out,sp_load, sp_wt_out,sp_load2, ps_din,ps_load,
 isNewDin,isNewWtin,din,wtin,addrDout,dout,
 state1_tap,state2_tap,state3_tap);
 
   parameter M=16;
  
  
output logic isNewDin,isNewWtin;    
output logic[16*16-1:0] din;   
output logic[16*16*4-1:0]wtin;
output logic[$clog2(M)-1:0] addrDout;
input  [47*4-1:0] dout;
output logic [63:0] ps_din;
input [63:0] sp_wt_out;
input [63:0] sp_din_out;
input sp_load,sp_load2, ps_load;
  
  input reset;
  input clk;
output state1_tap,state2_tap,state3_tap;  
logic  [47*4-1:0] dout_temp;
logic [2:0] state1,state2;
logic [4:0] state3;
logic sp_loaded1,oldsp_load,sp_loaded2,oldsp_load2;

assign {state1_tap,state2_tap,state3_tap} = {state1[0],state2[0],state3[0]};
always_ff @(posedge clk) begin
    if (reset) begin
      ps_din =0;
      addrDout=0;
      ps_din =0;
      {isNewDin,isNewWtin}=0;
      din =0;
      wtin=0;
      state1 =0;
      {sp_loaded1,oldsp_load,sp_loaded2,oldsp_load2}=0;
    end 
    else begin
        if(state1==0) dout_temp = dout;
        ps_din = dout_temp[63:0];
        if(ps_load) begin
            state1 = state1+1;;
            dout_temp = dout_temp >> 64;
            if(state1>=3) begin
                state1=0;
                addrDout=addrDout+1;
            end
        end
        if(sp_loaded1) begin
            din = {din,sp_din_out};
            state2= state2+1;
            sp_loaded1 = 0;
            if(state2 >= 4) begin
                isNewDin = ~isNewDin;
                state2 =0;
            end
        end
        if(sp_load & ~oldsp_load) sp_loaded1 = 1;
        oldsp_load = sp_load;

        if(sp_loaded2) begin
            wtin = {wtin,sp_wt_out};
            state3= state3+1;
            sp_loaded2 = 0;
            if(state3 >= 16) begin
                isNewWtin = ~isNewWtin;
                state3 =0;
            end
        end
        if(sp_load2 & ~oldsp_load2) sp_loaded2 = 1;
        oldsp_load2 = sp_load2;
    end

end 
  
  
 
endmodule

