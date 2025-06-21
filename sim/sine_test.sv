`timescale 1ns / 1ns
//`include distortion.sv

module sinetest;

//registers and wires for tb
reg clk, rst, en;
reg signed [23:0] D_in;//signed data type for negative values
wire [23:0] D_out;
reg [2:0] gain;

  FIR_LPF DUT(.clk(clk), .rst(rst), .D_in(D_in), .gain(gain), .D_out(D_out), .en(en));

parameter real pi = 3.14;
parameter int SAMPLERATE = 64;
parameter int Uamp = 120;
real angle, sine;

initial clk = 0;
always #1 clk = ~clk;

initial begin
    rst = 1'b1;
    gain = 3'd1;
    en = 1'b1;
    D_in = 24'd0;
    #10;
    $dumpfile("dump.vcd");
    $dumpvars(0, sinetest);
    rst = 1'b0;
    gain = 3'd4;
    en = 1'b1;
    /*Generates sine values based on samples*/
    for (int i = 0; i < SAMPLERATE; i++) begin
      // Compute sine wave values and scale
      angle = 2 * pi * i / SAMPLERATE;
      sine = $sin(angle);
      D_in = $rtoi(sine * Uamp); // convert to fixed point or smth idk
      if(i==32) begin
        en=1'b0;
      end
      #2;  // clk T = 2 ns
    end
    $finish;
end

endmodule