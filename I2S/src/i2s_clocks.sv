`timescale 10ps / 10ps

module i2s_clocks(
    //input [23:0] data;
    //input lineInSDOUT;
    input rst,
    output reg line_in_mclk,
    output reg line_in_sclk,
    output reg line_in_lrclk
    );

    parameter [12:0] MCLK_PERIOD = 13'd4428;

    reg [2:0] mclk_count;
    reg [5:0] sclk_count;

    always @(posedge rst) begin
        line_in_mclk  <= 1'b0;
        line_in_sclk  <= 1'b0;
        line_in_lrclk <= 1'b0;
        mclk_count <= 3'b0;
        sclk_count <= 6'b0;
    end

    initial begin
        forever begin
            line_in_mclk <= ~line_in_mclk;
            if(mclk_count == 3'd7) begin
                line_in_sclk <= ~line_in_sclk;
                if(sclk_count == 6'd63) begin
                    line_in_lrclk <= ~line_in_lrclk;
                end
                sclk_count++;
            end
            mclk_count++;
            #(MCLK_PERIOD >> 1);
        end
    end
endmodule