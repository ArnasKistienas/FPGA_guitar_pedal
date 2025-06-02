`timescale 1ns / 1ns

module sinetest;

//registers and wires for tb
reg clk, rst;
reg signed [23:0] sin_in;//signed data type for negative values
wire [23:0] sin_out;

  distortion DUT(.clk(clk), .rst(rst), .sin_in(sin_in), .sin_out(sin_out));

parameter real pi = 3.14;//change to more accurate later
parameter int SAMPLERATE = 64;
parameter int Uamp = 120;
real angle, sine;

initial clk = 0;
always #1 clk = ~clk;

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, sinetest);
    rst = 0;
    /*Generates 100 sine values*/
    for (int i = 0; i < SAMPLERATE; i++) begin
      // Compute sine wave values and scale
      angle = 2 * pi * i / SAMPLERATE;
      sine = $sin(angle);
      sin_in = $rtoi(sine * Uamp); // convert to fixed point or smth idk
      #2;  // clk T = 2 ns
    end
    $finish;
end

endmodule