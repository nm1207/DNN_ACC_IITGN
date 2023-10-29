`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2023 11:43:23 AM
// Design Name: 
// Module Name: UController
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


module UController(
    //**********inputs***************
    //clock signal
    reset,
    clock,
    //data from uart receiver to dnn accelerator
    dataIn,
    //to see a valid data is present at dataIn from UART receiver
    isNewData,

    isBusy,
    
    //*************outputs********************
    // data from DNN accelerator to UART transmitter    
    dataOut,
    // to see valid data is present at dataOut
    doTransmit,
 isNewDin,isNewWtin,din,wtin,addrDout,dout, globalState_tap);

  //parameters
  parameter BITWIDTH = 8;
  parameter M=16;

  parameter READ_BUF = 3'd1;
  parameter WRITE_IN_BUF = 3'd2;
  parameter WRITE_WT_BUF = 3'd3;

//  parameter CONFIG_ADDR = 3'd4;
  
  
output logic isNewDin,isNewWtin;    
output logic[16*16-1:0] din;   
output logic[16*16*4-1:0]wtin;
output logic[$clog2(M)-1:0] addrDout;
output logic [1:0] globalState_tap;
input  [47*4-1:0] dout;

  
  input reset;
  input clock;

  input [BITWIDTH-1:0] dataIn;
  input isNewData;

  output reg [BITWIDTH-1:0] dataOut;

  output reg doTransmit;

  input isBusy;
  
  
  logic [47*4-1:0] dout_temp;

  
  //state variables
  reg [4:0] globalState;
  reg [4:0] localState;
  reg [8:0] sequenceCounter;

  reg previousDataState;
  
  


  always_ff @(posedge clock) begin

    if (reset) begin

      //state variables
      globalState = 0;
      localState = 0;
      sequenceCounter = 0;

      dataOut = 0;
      doTransmit = 0;
      previousDataState = 0;
      addrDout=0;
      dout_temp =0;
      {isNewDin,isNewWtin}=0;
      din =0;
      wtin=0;

    end else begin

    if (globalState == 0) begin
        doTransmit = 0;


        if (previousDataState != isNewData) begin

          previousDataState = isNewData;
          case (dataIn[2:0])
            READ_BUF: begin
              globalState = READ_BUF;
              addrDout = dataIn[7:3];
            end
            WRITE_IN_BUF: begin
              globalState = WRITE_IN_BUF;
            end
            WRITE_WT_BUF: begin
              globalState = WRITE_WT_BUF;
            end     
//            CONFIG_ADDR: begin
//              globalState = CONFIG_ADDR;
//            end                     
            default: begin
              globalState = 0;
            end
          endcase
        end
    end
    else if (globalState == WRITE_IN_BUF) begin
        if(sequenceCounter == 32 ) sequenceCounter=sequenceCounter+1;
        if (previousDataState != isNewData) begin
          previousDataState = isNewData;
          din = {din,dataIn};
          sequenceCounter=sequenceCounter+1;
          end
          if(sequenceCounter > 32) begin
              sequenceCounter = 0;
              globalState = 0;
              localState = 0;
              isNewDin = ~isNewDin;
          end   
          
        
    end
    else if (globalState == READ_BUF) begin
        if(sequenceCounter == 12 ) sequenceCounter=sequenceCounter+1;
        if(localState==0) begin
            doTransmit = 0;
            dout_temp = dout;
            localState=1;
            dataOut = dout_temp[7:0];
        end
        else if(localState==1) begin
            dout_temp = dout_temp >> 8;
            dataOut = dout_temp[7:0];
            localState =2;
            doTransmit = 1;
        end
        else if(localState==2) begin
            localState = 3;
        end
        if (isBusy==0 & doTransmit ==0) begin
          localState = 1;
          sequenceCounter=sequenceCounter+1;
          end
          
          if(sequenceCounter > 12 ) begin
              sequenceCounter = 0;
              globalState = 0;
              localState = 0;
          end   
          
        
    end   
    else if (globalState == WRITE_WT_BUF) begin
        if(sequenceCounter == 128 ) sequenceCounter=sequenceCounter+1;
        if (previousDataState != isNewData) begin
          previousDataState = isNewData;
          wtin = {wtin,dataIn};
          sequenceCounter=sequenceCounter+1;
          end
          if(sequenceCounter > 128) begin
              sequenceCounter = 0;
              globalState = 0;
              localState = 0;
              isNewWtin = ~isNewWtin;
          end   
          
        
    end
//    else if (globalState == CONFIG_ADDR) begin
//        if (previousDataState != isNewData) begin
//          previousDataState = isNewData;
//          DATA_NUM = dataIn;
//          globalState = 0;
//        end
//    end  
  end
 end 
endmodule 

