`timescale 10ps / 10ps

module i2s_clock_divider(
    //input [23:0] data;
    //input lineInSDOUT;
    input rst,
    input line_in_mclk,
    output reg line_in_sclk,
    output reg line_in_lrclk
    );

    reg [2:0] mclk_count;
    reg [5:0] sclk_count;

    always @(line_in_mclk) begin
        if(rst) begin
            line_in_sclk = line_in_mclk;
            line_in_lrclk = line_in_mclk;
            mclk_count = 0;
            sclk_count = 0;
        end
        if(mclk_count == 3'd7) begin
            line_in_sclk <= ~line_in_sclk;
            if(sclk_count == 6'd63) begin
                line_in_lrclk <= ~line_in_lrclk;
            end
            sclk_count++;
        end
        mclk_count++;
    end
endmodule