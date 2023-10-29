`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2022 10:46:50 AM
// Design Name: 
// Module Name: Main
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


module Main (
    clk1,  //input clock
    reset1,  //input reset 
    RxD,  //input receving data line
    TxD,
    clk_tap,
    isBusy_tap,
    isNewData_tap,
    TxData_tap,
    RxData_tap

);

  input clk1;
  input reset1;
  input RxD;
  output TxD;
  output clk_tap;
  output isBusy_tap;
  output isNewData_tap;
  output TxData_tap;
  output RxData_tap;

  wire reset;
  assign reset = ~reset1;
  wire isNewData;
  wire [3:0] lState;
  wire reach;

  wire doTransmit;
  wire isBusy;
  wire [7:0] TxData;
  wire [7:0] RxData;
  wire [31:0] localState;

  wire clk;

  assign clk_tap = clk;
  assign isBusy_tap = isBusy;
  assign isNewData_tap = isNewData;
  assign TxData_tap = TxData[0];
  assign RxData_tap = RxData[0];
 
  Clock_divider clkdivider (
      clk1,
      clk
  );

  Receiver_V receiver_V (

      .clk(clk),  //input clock
      .reset(reset),  //input reset 
      .RxD(RxD),  //input receving data line
      .RxData(RxData),  // output for 8 bits data
      .isNewData(isNewData)  //changes value 
  );

  DNNProcessingElement dNNProcessingElement (

      //**********inputs***************
      //clock signal
      .reset(reset),
      .clock(clk),
      //data from uart receiver to dnn accelerator
      .dataIn(RxData),
      //to see a valid data is present at dataIn from UART receiver
      .isNewData(isNewData),

      .isBusy(isBusy),

      //*************outputs********************
      // data from DNN accelerator to UART transmitter    
      .dataOut(TxData),
      // to see valid data is present at dataOut
      .doTransmit(doTransmit)

  );



  Sender_V sender_V (
      .clk(clk),
      .reset(reset),
      .TxD(TxD),
      .doTransmit(doTransmit),
      .TxData(TxData),
      .isBusy(isBusy)
  );



endmodule

