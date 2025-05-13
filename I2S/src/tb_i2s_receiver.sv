`timescale 10ps / 10ps

module tb_i2s_receiver;
    reg reset, in_mclk;
    wire [23:0] out_data;
    wire in_sclk, in_lrclk, out_mclk, out_sclk, out_lrclk, data_valid;
    reg in;
    integer count, I;
    i2s_clock_divider TEST_HELP(
        .rst(reset),
        .mclk(in_mclk),
        .sclk(in_sclk),
        .lrclk(in_lrclk)
    );
    i2s_receiver DUT(
        .rst(reset),
        .mclk(in_mclk),
        .sclk(in_sclk),
        .lrclk(in_lrclk),
        .sdin(in),
        .data(out_data),
        .dvalid(data_valid),
        .mclk_out(out_mclk),
        .sclk_out(out_sclk),
        .lrclk_out(out_lrclk)
    );
    initial begin
        $dumpfile("../sim/i2s_receiver.vcd");
        $dumpvars(1, tb_i2s_receiver);
        forever #2214 in_mclk= ~in_mclk;
    end
    initial begin
        reset = 1'b1;
        count = 1'b0;
        in_mclk=1'b1;
        #2215 reset = 0;
        send_chunk(24'd50321);
        #(4428*8*7);
        send_chunk(24'd16777215);
        #(4428*8*7);
        send_chunk(24'd0);
        #(4428*8*7);
        send_chunk(24'd34245);
        #(4428*8*7);
        $finish(1);
    end

    always @(in_lrclk) begin

    end
    task send_chunk(input [23:0] message);
        begin
            #(4428*8);
            for(I = 23; I >= 0; I--)
                begin
                    in = message[I];
                    #(4428*8);
                end
        end
    endtask
endmodule