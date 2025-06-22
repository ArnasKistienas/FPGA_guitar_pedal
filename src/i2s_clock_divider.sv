// I2S Clock Divider Module that derives serial
// and left-right clocks from master clock.
module i2s_clock_divider(
    input rst,              // Active-high reset
    input mclk,             // Master clock
    output reg sclk,        // Serial clock
    output reg lrclk        // Left-right clock
    );

    reg [1:0] mclk_count;
    reg [5:0] sclk_count;

    always @(posedge mclk or posedge rst) begin
        // Reset all outputs and counters
        if(rst) begin
            sclk <= 1'b0;
            lrclk <= 1'b0;
            mclk_count <= 2'd0;
            sclk_count <= 6'd0;
        end else begin
            if (mclk_count == 2'd3) begin
                // Toggle sclk every 4 mclk cycles (divide by 8 full period)
                sclk <= ~sclk;
                if(sclk_count == 6'd63) begin
                    // Toggle lrclk every 64 sclk edges (128 sclk cycles = 1 frame)
                    lrclk <= ~lrclk;
                    sclk_count <= 6'd0;
                end else begin
                    sclk_count <= sclk_count + 1;
                end
                mclk_count <= 2'd0;
            end else begin
                mclk_count <= mclk_count + 1;
            end
        end
        
    end
endmodule