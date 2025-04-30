// Code your design here
module distortion(
  input clk, rst,
  input [23:0] sin_in,
  output reg signed [23:0] sin_out
);

reg signed [7:0] clip = 8'd100;
wire [7:0] abs_sin;

/*Two's complement absolute value*/
assign abs_sin = (sin_in[7] == 0) ? sin_in: (~sin_in[7:0])+8'h01;

  
  always @(posedge clk) begin
    if(abs_sin < clip) begin
      sin_out <= sin_in;
    end
  end
 
endmodule