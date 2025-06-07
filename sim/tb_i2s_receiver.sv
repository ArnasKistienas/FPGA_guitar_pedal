`timescale 10ps / 10ps

module tb_i2s_receiver;
    reg reset, in_mclk;
    wire [23:0] out_ldata, out_rdata;
    wire in_sclk, in_lrclk, data_valid, ledL, ledR;
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
        .sclk(in_sclk),
        .lrclk(in_lrclk),
        .sdin(in),
        .btnL(1'b0),
        .btnR(1'b0),
        .ldata(out_ldata),
        .rdata(out_rdata),
        .dvalid(data_valid),
        .ledL(ledL),
        .ledR(ledR)
    );
    initial begin
        forever #2214 in_mclk= ~in_mclk;
    end
    initial begin
        reset = 1'b1;
        count = 1'b0;
        in_mclk=1'b0;
        #(4428*8) reset = 0;
        #(4428*8*32)
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