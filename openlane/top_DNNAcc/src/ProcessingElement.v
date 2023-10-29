`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2022 10:46:21 AM
// Design Name: 
// Module Name: DNNProcessingElement
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

module DNNProcessingElement (

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
    doTransmit

);

  //parameters
  parameter BITWIDTH = 8;
  parameter INPUT_ARRAY_SIZE = 485;
  parameter OUTPUT_ARRAY_SIZE = 197;
  parameter WEIGHT_ARRAY_SIZE = 401;

  parameter CNN_LAYER = 1;
  parameter MAX_POOL_LAYER = 2;
  parameter RELU_LAYER = 3;
  parameter FULLY_CONNECTED_LAYER = 4;
  input reset;
  input clock;

  input [BITWIDTH-1:0] dataIn;
  input isNewData;

  output reg [BITWIDTH-1:0] dataOut;

  output reg doTransmit;

  input isBusy;

  //state variables
  reg [15:0] globalState;
  reg [15:0] localState;
  reg [15:0] sequenceCounter;
  reg [15:0] skipCounter;
  reg previousDataState;
  reg [15:0] inputSize;
  reg [15:0] weightSize;
  reg [15:0] outputSize;



  //layerSizes
  // reg [31:0] N;
  reg [BITWIDTH-1:0] M;
  reg [BITWIDTH-1:0] C;
  reg [BITWIDTH-1:0] P;
  reg [BITWIDTH-1:0] Q;
  reg [BITWIDTH-1:0] R;
  reg [BITWIDTH-1:0] S;
  reg [BITWIDTH-1:0] W;
  reg [BITWIDTH-1:0] H;

  reg [BITWIDTH-1:0] xStride;
  reg [BITWIDTH-1:0] yStride;

  //iterators
  // reg [31:0] n;
  reg [BITWIDTH-1:0] m;
  reg [BITWIDTH-1:0] c;
  reg [BITWIDTH-1:0] p;
  reg [BITWIDTH-1:0] q;
  reg [BITWIDTH-1:0] r;
  reg [BITWIDTH-1:0] s;

  reg [15:0] indexOutput;

  reg [15:0] indexInput;

  reg [15:0] indexWeight;

  reg [BITWIDTH-1:0] reuse;
  reg [BITWIDTH-1:0] transferBack;
  reg [BITWIDTH-1:0] scaler;
  reg [15:0] inputOffset;
  reg [15:0] weightOffsetInChannel;
  reg [15:0] weightOffsetOutChannel;
  reg [15:0] outputOffset;


  //local buffer
  reg [BITWIDTH-1:0] inputs[0:INPUT_ARRAY_SIZE];
  reg [BITWIDTH-1:0] weights[0:WEIGHT_ARRAY_SIZE];
  reg [BITWIDTH + 15:0] outputs[0:OUTPUT_ARRAY_SIZE];



  always @(posedge clock) begin

    if (reset) begin

      //state variables
      globalState = 0;
      localState = 0;
      sequenceCounter = 0;
      skipCounter = 0;
      inputSize = 0;
      weightSize = 0;
      outputSize = 0;
      dataOut = 0;
      doTransmit = 0;
      previousDataState = 0;
      //layerSizes
      // N = 0;
      M = 0;
      C = 0;
      P = 0;
      Q = 0;
      R = 0;
      S = 0;
      W = 0;
      H = 0;

      //iterators
      // n = 0;
      m = 0;
      c = 0;
      p = 0;
      q = 0;
      r = 0;
      s = 0;

      reuse = 0;
      transferBack = 0;
      scaler = 0;


      indexOutput = 0;

      indexInput = 0;

      indexWeight = 0;


    end else begin

      if (globalState == 0) begin


        if (previousDataState != isNewData) begin

          previousDataState = isNewData;
          case (dataIn)
            CNN_LAYER: begin
              globalState = CNN_LAYER;
            end
            MAX_POOL_LAYER: begin
              globalState = MAX_POOL_LAYER;
            end
            RELU_LAYER: begin
              globalState = RELU_LAYER;
            end
            FULLY_CONNECTED_LAYER: begin
              globalState = FULLY_CONNECTED_LAYER;
            end
            default: begin
              globalState = 0;
            end
          endcase

        end else begin
          //do not
        end


      end else if (globalState == CNN_LAYER) begin
        //CNN layer

        case (localState)
          0: begin
            //loading data into layerSizes
            if (previousDataState != isNewData) begin
              previousDataState = isNewData;
              case (sequenceCounter)
                0: begin
                  M = dataIn;
                  sequenceCounter = sequenceCounter + 1;
                end
                1: begin
                  C = dataIn;
                  sequenceCounter = sequenceCounter + 1;
                end
                2: begin
                  P = dataIn;
                  sequenceCounter = sequenceCounter + 1;
                end
                3: begin
                  Q = dataIn;
                  sequenceCounter = sequenceCounter + 1;
                end
                4: begin
                  R = dataIn;
                  sequenceCounter = sequenceCounter + 1;
                end
                5: begin
                  S = dataIn;
                  sequenceCounter = sequenceCounter + 1;
                end
                6: begin
                  xStride = dataIn;
                  sequenceCounter = sequenceCounter + 1;
                end
                7: begin
                  yStride = dataIn;
                  sequenceCounter = sequenceCounter + 1;
                end

                8: begin
                  reuse = dataIn;
                  sequenceCounter = sequenceCounter + 1;
                end
                9: begin
                  transferBack = dataIn;
                  sequenceCounter = sequenceCounter + 1;
                end
                10: begin
                  scaler = dataIn;
                  sequenceCounter = sequenceCounter + 1;

                  W = (Q - 1) * xStride + S;
                  H = (P - 1) * yStride + R;
                  inputSize = W * H * C;
                  weightSize = S * R * C * M;
                  outputSize = Q * P * M;
                  sequenceCounter = 0;
                  localState = localState + 1;
                end
                default: begin
                  //do nothing
                end
              endcase
            end else begin
              //skip the cycle
            end

          end
          1: begin
            //loading data into inputs
            if (previousDataState != isNewData) begin
              previousDataState = isNewData;
              if (sequenceCounter < inputSize) begin
                inputs[sequenceCounter] = dataIn;
                sequenceCounter = sequenceCounter + 1;
                if (sequenceCounter == inputSize) begin
                  sequenceCounter = 0;
                  localState = localState + 1;
                end else begin
                  //do nothing
                end

              end else begin

                // do nothing
                //this shouldn't happen

              end
            end else begin
              //skip cycle
            end
          end

          2: begin

            //loading weights
            if (previousDataState != isNewData) begin
              previousDataState = isNewData;
              if (sequenceCounter < weightSize) begin
                weights[sequenceCounter] = dataIn;
                sequenceCounter = sequenceCounter + 1;
                if (sequenceCounter == weightSize) begin
                  sequenceCounter = 0;
                  localState = localState + 1;
                end else begin
                  //do nothing
                end

              end else begin

                // do nothing
                //this shouldn't happen

              end
            end else begin
              //skip cycle
            end
          end
          // 

          3: begin

            //later set this up such that partial products can be loaded from python by seeting dataIn
            // if (validIn) begin
            if (reuse == 0) begin
              if (sequenceCounter < outputSize) begin
                outputs[sequenceCounter] = 0;
                sequenceCounter = sequenceCounter + 1;
                if (sequenceCounter == outputSize) begin
                  sequenceCounter = 0;
                  localState = localState + 1;
                end else begin
                  //do nothing

                end

              end else begin

                // do nothing
                //this shouldn't happen

              end
            end else begin
              sequenceCounter = 0;
              localState = localState + 1;
              //do nothing let the data remain as such
            end
            // end
            // else begin

            //   //skip cycle if expecting partial data 
            // end
          end






          4: begin
            //compute
            indexInput = ((q * xStride) + s) + (((p * yStride) + r) * W) + (c * W * H);
            inputOffset = W * H;
            indexWeight = s + (r * S) + (c * R * S) + (m * C * R * S);
            weightOffsetInChannel = R * S;
            weightOffsetOutChannel = C * R * S;

            indexOutput = q + (p * Q) + (m * Q * P);
            outputOffset = Q * P;

            outputs[indexOutput] = outputs[indexOutput] + (inputs[indexInput] * weights[indexWeight]) + (inputs[indexInput+inputOffset] * weights[indexWeight+weightOffsetInChannel]) + (inputs[indexInput+ 2*inputOffset] * weights[indexWeight+2*weightOffsetInChannel])+ (inputs[indexInput+3*inputOffset] * weights[indexWeight+3*weightOffsetInChannel]);
            outputs[indexOutput+outputOffset] = outputs[indexOutput+outputOffset] + (inputs[indexInput] * weights[indexWeight+weightOffsetOutChannel]) + (inputs[indexInput+inputOffset] * weights[indexWeight+weightOffsetInChannel+weightOffsetOutChannel]) + (inputs[indexInput+ 2*inputOffset] * weights[indexWeight+2*weightOffsetInChannel+weightOffsetOutChannel])+ (inputs[indexInput+3*inputOffset] * weights[indexWeight+3*weightOffsetInChannel+weightOffsetOutChannel]);
            outputs[indexOutput+2*outputOffset] = outputs[indexOutput+2*outputOffset] + (inputs[indexInput] * weights[indexWeight+2*weightOffsetOutChannel]) + (inputs[indexInput+inputOffset] * weights[indexWeight+weightOffsetInChannel+2*weightOffsetOutChannel]) + (inputs[indexInput+ 2*inputOffset] * weights[indexWeight+2*weightOffsetInChannel+2*weightOffsetOutChannel])+ (inputs[indexInput+3*inputOffset] * weights[indexWeight+3*weightOffsetInChannel+2*weightOffsetOutChannel]);
            outputs[indexOutput+3*outputOffset] = outputs[indexOutput+3*outputOffset] + (inputs[indexInput] * weights[indexWeight+3*weightOffsetOutChannel]) + (inputs[indexInput+inputOffset] * weights[indexWeight+weightOffsetInChannel+3*weightOffsetOutChannel]) + (inputs[indexInput+ 2*inputOffset] * weights[indexWeight+2*weightOffsetInChannel+3*weightOffsetOutChannel])+ (inputs[indexInput+3*inputOffset] * weights[indexWeight+3*weightOffsetInChannel+3*weightOffsetOutChannel]);

            //            sequenceCounter = sequenceCounter + 1;
            //            outputs[indexOutput] = sequenceCounter;
            //            outputs[outputSize-2]= sequenceCounter[15:8];
            //            outputs[outputSize-1] =sequenceCounter[7:0];

            //schedule
            // s,r, q, p, c, m 
            if (s < S - 1) begin
              s = s + 1;
            end else begin
              s = 0;
              if (r < R - 1) begin
                r = r + 1;
              end else begin
                r = 0;
                if (q < Q - 1) begin
                  q = q + 1;
                end else begin
                  q = 0;
                  if (p < P - 1) begin
                    p = p + 1;
                  end else begin
                    p = 0;
                    if (c < (C>>2) - 1) begin
                      c = c + 1;
                    end else begin
                      c = 0;
                      if (m < (M>>2) - 1) begin
                        m = m + 1;
                      end else begin
                        m = 0;
                        localState = localState + 1;
                        sequenceCounter = 0;
                      end
                    end
                  end
                end
              end
            end
          end

          5: begin
            // wait for the uart in the server to come active.
            //            if (sequenceCounter > 100000) begin
            //              localState = 6;
            //              sequenceCounter = 0;
            //            end else begin
            //              sequenceCounter = sequenceCounter + 1;

            //            end

            // or you can do some post processing stuff here
            localState = 6;
          end
          6: begin
            //now you have to send out the data

            if (transferBack == 1) begin

              if (isBusy == 0) begin
                if (skipCounter > 10) begin
                  skipCounter = 0;

                  if (sequenceCounter >= outputSize) begin
                    sequenceCounter = 0;
                    localState = 0;
                    globalState = 0;

                  end else begin
                    dataOut = (outputs[sequenceCounter]) >> scaler;
                    sequenceCounter = sequenceCounter + 1;
                    doTransmit = 1;
                  end





                end else begin
                  skipCounter = skipCounter + 1;
                  doTransmit  = 0;
                end
              end else begin
                doTransmit = 0;
              end
            end else begin
              sequenceCounter = 0;
              localState = 0;
              globalState = 0;

            end


          end

        endcase

      end else if (globalState == MAX_POOL_LAYER) begin
        //MAX_POOL_LAYER

      end else if (globalState == RELU_LAYER) begin
        //RELU_LAYER

      end else if (globalState == FULLY_CONNECTED_LAYER) begin
        //FULLY_CONNECTED_LAYER

      end else begin
        //do nothing
        globalState = 0;
        //
      end

    end

  end


endmodule

