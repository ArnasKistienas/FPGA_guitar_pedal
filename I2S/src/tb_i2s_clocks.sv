`timescale 10ps / 10ps

module tb_i2s_clocks;
reg mclk, reset;
wire sclk, lrclk;
i2s_clock_divider DUT(
    .rst(reset),
    .line_in_mclk(mclk),
    .line_in_sclk(sclk),
    .line_in_lrclk(lrclk)
);

initial begin
    $dumpfile("../sim/tb_i2s_clocks.vcd");
    $dumpvars(0, tb_i2s_clocks);
    mclk=0;
    reset=0;
    forever #2214 mclk=~mclk;
end

initial begin
    #5 reset = 1;
    #2214 reset = 0;
    #2267594 $finish(1);
end
endmodule