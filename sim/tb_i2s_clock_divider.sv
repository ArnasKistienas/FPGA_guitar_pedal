`timescale 10ps / 10ps

module tb_i2s_clock_divider;
reg mclk, reset;
wire sclk, lrclk;
i2s_clock_divider DUT(
    .rst(reset),
    .mclk(mclk),
    .sclk(sclk),
    .lrclk(lrclk)
);

initial begin
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