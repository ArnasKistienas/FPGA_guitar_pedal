module FIR_LPF(
  input                     clk,     // Clock signal
  input                     rst,     // Asynchronous reset
  input [2:0]               gain,    // Gain input (currently unused)
  input signed [23:0]       D_in,    // 24-bit signed input data
  input                     en,      // Filter enable: 1 = LPF ON, 0 = bypass
  output reg signed [23:0]  D_out    // 24-bit signed output data
);

// Maximum allowed amplitude for output signal (clipping threshold)
parameter signed [23:0] limiter = 24'sd550000;

// 9-sample buffer (delay line) for FIR filter
reg signed [23:0] buff [0:8];

// Intermediate signals
wire [23:0] abs_filtered;           // Absolute value of filtered output
wire signed [23:0] filtered;        // FIR filtered output

/*FIR filter structure bit shifted so that the sound doesn't get amplified too much*/
assign filtered = (3*buff[0] + buff[1] + 4*buff[2] + buff[3] + buff[4] + 6*buff[5] + 7*buff[6] + 4*buff[7] + 6*buff[8]) >> 4;

// Compute absolute value of filtered result using two's complement
assign abs_filtered = (filtered[23] == 1'd0) ? filtered : (~filtered) + 24'd1;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    // Reset condition: clear buffer and output
    for (int i = 0; i < 9; i++) begin
      buff[i] <= 24'd0;
    end
    D_out <= 24'd0;
  end else begin
    // Shift buffer to make room for new input sample
    buff[0] <= D_in;
    for (int j = 1; j < 9; j++) begin
      buff[j] <= buff[j-1];
    end

    if (en) begin
      // Filter enabled: clip output signal from both sides
      if (abs_filtered < limiter) begin
        D_out <= filtered;
      end else begin
        // Clipping logic: saturate to ±limiter
        if (filtered[23] == 1'd0) begin
          D_out <= limiter;
        end else begin
          D_out <= -limiter;
        end
      end
    end else begin
      // Filter bypassed: output direct input
      D_out <= D_in;
    end
  end
end

endmodule
