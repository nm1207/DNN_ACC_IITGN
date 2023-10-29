`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2022 04:25:04 PM
// Design Name: 
// Module Name: sipo
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


module sipo(clk,rst,en,in,load,out);
  parameter N=64;
  input clk,rst,en;
  input in,load;
  output logic [N-1:0]out;
  logic [N-1:0]temp;
  bit [$clog2(N)-1:0] i;
  bit full;
  always_ff@(posedge clk)
    begin
      if(!rst) begin
        temp=0;
        i = 0;
        out=0;
	full = 0;
      end
      else if ((full == 0) & en)
		begin
		   if(i<N-1) begin 
			temp=temp<<1'b1;
			temp[0]=in;
		   	i = i+5'b1;
			full = 0;
			end
		   else begin
			temp=temp<<1'b1;
			temp[0]=in;
		   	i = i+5'b1;
			full = 1 ;
			end
		end 
	else if (en == 0) begin
			full = 0;
		end

      else if(load)
        out=temp ;
    end
endmodule

