`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2022 04:35:00 PM
// Design Name: 
// Module Name: piso
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


module piso(clk,rst,in,load, out);
  parameter N = 64;
  input clk,rst,load;
  input [N-1:0] in;
  output logic out;
  
  logic [N-1:0]temp;
  
  always @(posedge clk)
    begin
      if (!rst)
	begin
        temp<=0;
	out<=0;
	end
      else if(load)
	begin
        temp<=in;
	out<=0;
	end     
      else
        begin
          out<=temp[N-1]; // out MSB first
          temp<={temp[N-2:0],1'b0}; // adding zero to LSB
          end
      end
endmodule

