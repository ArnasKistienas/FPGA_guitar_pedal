// Top-Level Module
module top (
    input       rst,        // Active-high reset
    input       clk,        // Clock
    input       JA_input,   // Serial data in
    output [6:0]JA_output,  // I2S output signals (mclk, lrclk, sclk, sdout)
    input       btnL,       // Button L (left channel enable toggle)
    input       btnR,       // Button R (right channel enable toggle)
    input       sw0,        // Switch for filter enable
    output      led,        // LED output indicating reset state
    output      ledL,       // LED for left channel status (enabled/disabled)
    output      ledR,       // LED for right channel status (enabled/disabled)
    output  [3:0]  an,      // 7-segment display anode enables
    output  [6:0]  seg      // 7-segment display outputs
);
    // Internal signals for audio data and clocks
        // Left/Right channel data
    wire [23:0] i2s_ldata, i2s_rdata, i2s_ldata_out, i2s_rdata_out;
        // Data valid signal (indicates new data is available)
    wire data_valid;
        // I2S clocks: mclk, sclk, lrclk, and inverted lrclk (rlclk)
    wire mclk, sclk, lrclk, rlclk;

    wire buttonL, buttonR;
    reg [2:0] GAIN;

    assign JA_output[0] = mclk;
    assign JA_output[1] = lrclk;
    assign JA_output[2] = sclk;
    assign JA_output[3] = mclk;
    assign JA_output[4] = lrclk;
    assign JA_output[5] = sclk;
    assign led = rst;

    // Generate rlclk as the inverted version of lrclk
    assign rlclk = ~lrclk;

    // Direct Digital Synthesis (DDS) for master clock generation
    dds DDS(
        .clk(clk),
        .rst(rst),
        .mclk(mclk)
    );

    // I2S clock divider to generate serial clock (sclk) and left-right clock (lrclk)
    i2s_clock_divider prescaler(
        .rst(rst),
        .mclk(mclk),
        .sclk(sclk),
        .lrclk(lrclk)
    );

    // I2S Receiver to receive I2S data
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

    // Low-pass filter for left channel data
    FIR_LPF L_filter(
        .clk(rlclk), 
        .rst(rst),
        .D_in(i2s_ldata),
        .en(sw0),
        .D_out(i2s_ldata_out)
    );

    // Low-pass filter for right channel data
    FIR_LPF R_filter(
        .clk(lrclk), 
        .rst(rst),
        .D_in(i2s_rdata),
        .en(sw0),
        .D_out(i2s_rdata_out)
    );

    // 7-segment display driver
    SSEG_driver Segment_display (
    .clk(clk),          
    .rst(rst),        
    .D_in({13'd0,GAIN}),         
    .SSEG_AN(an),      
    .SSEG_CA(seg) 
    );

    // I2S Transmitter to send filtered audio data
    i2s_transmitter TX(
        .rst(rst),
        .sclk(sclk),
        .lrclk(lrclk),
        .ldata(i2s_ldata_out),
        .rdata(i2s_rdata_out),
        .sdout(JA_output[6])
    );

    assign GAIN = 3'd1;

endmodule