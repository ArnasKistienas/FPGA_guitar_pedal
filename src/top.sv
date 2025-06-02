module top (
    input       rst, //Reset
    input       clk,
    input       JA_input,  //SDin
    output [6:0]JA_output,
    input       btnL,
    input       btnR,
    input       sw0,
    input       sw1,
    output      JB1,
    output      led,
    output      ledL,
    output      ledR
);
    wire [23:0] i2s_ldata, i2s_rdata, i2s_ldata_out, i2s_rdata_out;
    wire data_valid;
    wire mclk, sclk, lrclk;
    wire buttonL, buttonR;

    assign JA_output[0] = mclk;
    assign JA_output[1] = lrclk;
    assign JA_output[2] = sclk;
    assign JA_output[3] = mclk;
    assign JA_output[4] = lrclk;
    assign JA_output[5] = sclk;
    assign JB1 = JA_input;
    assign led = rst;

    /*debounce debouncerL(
        .rst(rst),
        .btn(btnL),
        .clk(lrclk),
        .signal(buttonL)
    );
    debounce debouncerR(
        .rst(rst),
        .btn(btnR),
        .clk(lrclk),
        .signal(buttonR)
    );*/

    dds DDS(
        .clk(clk),
        .rst(rst),
        .mclk(mclk)
    );

    i2s_clock_divider prescaler(
        .rst(rst),
        .mclk(mclk),
        .sclk(sclk),
        .lrclk(lrclk)
    );

    i2s_receiver RX(
        .rst(rst),
        .sclk(sclk),
        .lrclk(lrclk),
        .sdin(JA_input),
        .btnL(btnL),
        .btnR(btnR),
        .ldata(i2s_ldata),
        .rdata(i2s_rdata),
        .dvalid(data_valid),
        .ledL(ledL),
        .ledR(ledR)
    );

    FIR_LPF L_filter(
        .clk(lrclk), 
        .rst(rst),
        .gain(4'd1),
        .D_in(i2s_ldata),
        .en(sw1),
        .D_out(i2s_ldata_out)
    );


    FIR_LPF R_filter(
        .clk(lrclk), 
        .rst(rst),
        .gain(4'd1),
        .D_in(i2s_rdata),
        .en(sw0),
        .D_out(i2s_rdata_out)
    );

    i2s_transmitter TX(
        .rst(rst),
        .sclk(sclk),
        .lrclk(lrclk),
        .ldata(i2s_ldata_out),
        .rdata(i2s_rdata_out),
        .sdout(JA_output[6])
    );
endmodule