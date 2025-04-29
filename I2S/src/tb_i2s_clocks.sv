`timescale 10ps / 10ps

module tb_i2s_clocks;
reg reset;
wire mclk, sclk, lrclk;
i2s_clocks DUT(
    .rst(reset),
    .line_in_mclk(mclk),
    .line_in_sclk(sclk),
    .line_in_lrclk(lrclk)
);

initial begin
    $dumpfile("../sim/tb_i2s_clocks.vcd");
    $dumpvars(0, tb_i2s_clocks);
end

initial begin
    #1 reset<=1'bx;
    #20 reset<=1'b1;

    #2267594 $finish(1);
end
endmodule