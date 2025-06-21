module FIR_LPF(
  input                     clk, 
  input                     rst,
  input [2:0]               gain,
  input signed [23:0]       D_in,
  input                     en,     // |en = 1 LPF ON | en = 0 LPF OFF|
  output reg signed [23:0]  D_out
);

parameter signed [23:0] limiter=24'sd550000;//signed decimal clipping amplitude value

//FIR filter register
reg signed [23:0] buff [0:8];

wire [23:0] abs_filtered;
wire signed [23:0] filtered;

/*FIR filter structure bit shifted so that the sound doesn't get amplified too much*/
assign filtered = (3*buff[0] + buff[1] + 4*buff[2] + buff[3] + buff[4] + 6*buff[5] + 7*buff[6] + 4*buff[7] + 6*buff[8]) >> 4;
/*Two's complement absolute value*/
assign abs_filtered = (filtered[23] == 1'd0) ? filtered : (~filtered)+24'd1;

// If (en == 1)
//  d_in -> LPF
// else
//  d_in -> D_out 

always @(posedge clk or posedge rst) begin
  if (rst) begin
    for(int i = 0; i < 9; i++) begin
      buff[i] <= 24'd0;
    end
    D_out<= 24'd0;
  end else begin
      buff[0] <= D_in;
      for(int j = 1; j < 9; j++) begin
          buff[j] <= buff[j-1];
      end
      if (en) begin
        if(abs_filtered<limiter) begin
          D_out <= filtered;
        end else begin
          if(filtered[23]==1'd0) begin
            D_out<=limiter;
          end else begin
            D_out<=-limiter;
          end
        end
      end else begin
        D_out <= D_in;
      end
  end
end

endmodule 