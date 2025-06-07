`timescale 10ps / 10ps

module tb_i2s_transmitter;
    reg reset, in_mclk;
    reg [23:0] in_ldata, in_rdata;
    wire in_sclk, in_lrclk;
    wire out;
    reg [23:0] data_arr[0:6]; //= {50321, 2131, 34245, 12312, 9044432, 0, 16777215};
    integer count;
    i2s_clock_divider TEST_HELP(
        .rst(reset),
        .mclk(in_mclk),
        .sclk(in_sclk),
        .lrclk(in_lrclk)
    );
    i2s_transmitter DUT(
        .rst(reset),
        .sclk(in_sclk),
        .lrclk(in_lrclk),
        .ldata(in_ldata),
        .rdata(in_rdata),
        .sdout(out)
    );
    initial begin
        forever #2214 in_mclk= ~in_mclk;
    end
    initial begin
        reset = 1'b1;
        count = 1'b0;
        in_mclk=1'b1;
        data_arr[0]=50321;
        data_arr[1]=2131;
        data_arr[2]=34245;
        data_arr[3]=12312;
        data_arr[4]=9044432;
        data_arr[5]=0;
        data_arr[6]=16777215;
        #2215 reset = 0;
    end

    always @(in_lrclk) begin
        if(in_lrclk) begin
            in_ldata <= data_arr[count];
        end else begin
            in_rdata <= data_arr[count];
        end
        count++;
        if(count >= 7) begin
            $finish(1);
        end
    end
endmodule